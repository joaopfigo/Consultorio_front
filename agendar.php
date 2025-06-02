<?php
include 'conexao.php';
session_start();

$user_id = $_SESSION['usuario_id'] ?? null;
$nome = $_POST['guest_name'] ?? null;
$email = $_POST['guest_email'] ?? null;
$telefone = $_POST['guest_phone'] ?? null;
$idade = $_POST['guest_idade'] ?? null;
$servico_id = $_POST['servico_id'] ?? null;
$data = $_POST['data'] ?? null;
$hora = $_POST['hora'] ?? null;
$duracao = $_POST['duracao'] ?? null;
$add_reflexo = isset($_POST['add_reflexo']) ? 1 : 0;
$status = 'Pendente';

if (!$servico_id || !$data || !$hora || !$duracao) {
    die("DADOS_INCOMPLETOS");
}
$datetime = "$data $hora:00";

// 1. Verifica disponibilidade do horário
$stmt = $conn->prepare("SELECT id FROM agendamentos WHERE data_horario = ? AND status <> 'Cancelada'");
$stmt->bind_param("s", $datetime);
$stmt->execute();
$stmt->store_result();
if ($stmt->num_rows > 0) {
    die("HORARIO_OCUPADO");
}
$stmt->close();

$conn->begin_transaction();
try {
    // 2. Se for pacote, verifica e debita sessão
    $usou_pacote = false;
    $pacote_id = null;
    if ($user_id && $duracao === 'pacote') {
        // Busca pacote ativo
        $stmt = $conn->prepare("SELECT id, total_sessoes, sessoes_usadas FROM pacotes WHERE usuario_id = ? ORDER BY id DESC LIMIT 1");
        $stmt->bind_param("i", $user_id);
        $stmt->execute();
        $stmt->bind_result($pacote_id, $total, $usadas);
        if ($stmt->fetch()) {
            if ($usadas >= $total) {
                throw new Exception("Você não possui sessões de pacote disponíveis.");
            }
        } else {
            throw new Exception("Nenhum pacote encontrado.");
        }
        $stmt->close();
        // Debita sessão
        $stmt = $conn->prepare("UPDATE pacotes SET sessoes_usadas = sessoes_usadas + 1 WHERE id = ?");
        $stmt->bind_param("i", $pacote_id);
        $stmt->execute();
        $usou_pacote = true;
        $duracao = 50; // ou o valor padrão do seu sistema
    }
    $duracao = (int)$duracao;

    // 3. Cria o agendamento
    if ($user_id) {
        $null = null;
        $stmt = $conn->prepare("INSERT INTO agendamentos 
            (usuario_id, nome_visitante, email_visitante, telefone_visitante, idade_visitante, especialidade_id, data_horario, duracao, adicional_reflexo, status, criado_em) 
            VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, NOW())");
        $stmt->bind_param(
            "isssissiis", 
            $user_id, $null, $null, $null, $null, $servico_id, $datetime, $duracao, $add_reflexo, $status
        );
    } else {
        $null = null;
        $stmt = $conn->prepare("INSERT INTO agendamentos 
            (usuario_id, nome_visitante, email_visitante, telefone_visitante, idade_visitante, especialidade_id, data_horario, duracao, adicional_reflexo, status, criado_em) 
            VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, NOW())");
        $stmt->bind_param(
            "isssissiis", 
            $null, $nome, $email, $telefone, $idade, 
            $servico_id, $datetime, $duracao, $add_reflexo, $status
        );
    }
    $stmt->execute();
    $agendamentoId = $stmt->insert_id;
    $stmt->close();

    // 4. Se usou pacote, registra uso
    if ($usou_pacote && $pacote_id && $agendamentoId) {
        $stmt = $conn->prepare("INSERT INTO uso_pacote (pacote_id, agendamento_id) VALUES (?, ?)");
        $stmt->bind_param("ii", $pacote_id, $agendamentoId);
        $stmt->execute();
        $stmt->close();
    }

    $conn->commit();
    echo "SUCESSO|$agendamentoId";
} catch (Exception $e) {
    $conn->rollback();
    die("ERRO_AGENDAR: " . $e->getMessage());
}
?>
