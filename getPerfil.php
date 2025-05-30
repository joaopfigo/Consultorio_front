<?php
include 'conexao.php';
session_start();
header('Content-Type: application/json');

// Verifica autenticação
if (!isset($_SESSION['usuario_id'])) {
    http_response_code(401);
    echo json_encode(["erro" => "Não autenticado"]);
    exit;
}
$user_id = $_SESSION['usuario_id'];

// 1. Busca dados do usuário
$stmt = $conn->prepare("SELECT nome, email, telefone, idade, sexo, foto_perfil FROM usuarios WHERE id = ?");
$stmt->bind_param("i", $user_id);
$stmt->execute();
$stmt->bind_result($nome, $email, $telefone, $idade, $sexo, $foto);
$stmt->fetch();
$stmt->close();

// 2. Busca agendamentos do usuário
// Vamos pegar todos inclusive futuros e passados. Podemos identificar status/tempo depois.
$sql = "SELECT ag.id, e.nome as servico, ag.data_horario, ag.duracao, ag.adicional_reflexo, ag.status,
               fq.desconforto_principal, fq.tempo_desconforto, fq.classificacao_dor, fq.tratamento_medico,
               an.resumo, an.orientacoes
        FROM agendamentos ag
        JOIN especialidades e ON e.id = ag.especialidade_id
        LEFT JOIN formularios_queixa fq ON fq.agendamento_id = ag.id
        LEFT JOIN anamneses an ON an.agendamento_id = ag.id
        WHERE ag.usuario_id = ?
        ORDER BY ag.data_horario DESC";
$stmt2 = $conn->prepare($sql);
$stmt2->bind_param("i", $user_id);
$stmt2->execute();
$result = $stmt2->get_result();
$sessoes = [];
while ($row = $result->fetch_assoc()) {
    // Formata dados em um array PHP (depois será convertido em JSON)
    $sessoes[] = [
       "id" => $row['id'],
       "tratamento" => $row['servico'],
       "data_horario" => $row['data_horario'],
       "duracao" => $row['duracao'],
       "status" => $row['status'],
       "reclamacao" => ($row['desconforto_principal'] ? [
            "sintomas"    => $row['desconforto_principal'],
            "tempo"       => $row['tempo_desconforto'],
            "intensidade" => $row['classificacao_dor'],
            "tratamento"  => $row['tratamento_medico']
       ] : null),
       "anamnese" => ($row['resumo'] ? [
            "geral"       => $row['resumo'],
            "orientacoes" => $row['orientacoes']
       ] : null)
    ];
}
$stmt2->close();

// 3. Retorna JSON com todos os dados
echo json_encode([
    "usuario" => [
       "nome" => $nome,
       "email" => $email,
       "telefone" => $telefone,
       "idade" => $idade,
       "sexo" => $sexo,
       "foto" => $foto
    ],
    "sessoes" => $sessoes
]);

?>
