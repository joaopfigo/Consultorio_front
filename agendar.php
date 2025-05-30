<?php
include 'conexao.php';
session_start();

// 1. Captura de dados do POST (vindo do formulário de agendamento)
$servico_id   = $_POST['servico_id'];    // ID da especialidade escolhida
$data         = $_POST['data'];         // data selecionada (formato yyyy-mm-dd)
$hora         = $_POST['hora'];         // hora selecionada (HH:MM)
$duracao      = $_POST['duracao'];      // duração em minutos
$add_reflexo  = isset($_POST['add_reflexo']) ? 1 : 0;  // se veio marcado o combo

// Formulário de queixas:
$desconforto_princ = $_POST['principal_desconforto'] ?? null;
$queixa_secundaria = $_POST['queixa_secundaria'] ?? null;
$tempo_desc       = $_POST['tempo_desconforto'] ?? null;
$classif_dor      = $_POST['classificacao_dor'] ?? null;
$tratamento_med   = $_POST['tratamento_medico'] ?? null;
// ... (demais campos de checkbox e radio, exemplo:)
$em_cuidados      = isset($_POST['check1']) ? 1 : 0;
$medicacao        = isset($_POST['check2']) ? 1 : 0;
$gravida          = isset($_POST['check3']) ? 1 : 0;
// (... repetir para check4..check31 ...)
$ansiedade        = $_POST['ansiedade'] ?? null;
$tristeza         = $_POST['tristeza'] ?? null;
$raiva            = $_POST['raiva'] ?? null;
$preocupacao      = $_POST['preocupacao'] ?? null;
$medo             = $_POST['medo'] ?? null;
$irritacao        = $_POST['irritacao'] ?? null;
$angustia         = $_POST['angustia'] ?? null;
$termo            = isset($_POST['termo']) ? 1 : 0;  // checkbox final de aceite

// Dados do usuário/visitante:
$user_id   = $_SESSION['user_id'] ?? null;
$nome      = $_POST['guest_name'] ?? null;
$email     = $_POST['guest_email'] ?? null;
$telefone  = $_POST['guest_phone'] ?? null;
$idade     = $_POST['guest_idade'] ?? null;   // *adicione este campo no form se quiser coletar*

$criarConta = isset($_POST['criar_conta']);   // se o visitante marcou para criar conta

// 2. Validações mínimas:
if (empty($user_id) && (!$nome || !$email || !$telefone)) {
    die("DADOS_INCOMPLETOS");
}
if (!$termo) {
    die("TERMO_NAO_ACEITO");
}

// (Poderia também validar formato de email, etc., e se data/hora/duração são válidos)

// 3. Verifica disponibilidade do horário selecionado (para evitar dupla marcação)
$datetime = "$data $hora:00";  // monta string tipo '2024-07-01 14:00:00'
$query = "SELECT id FROM agendamentos WHERE data_horario = ? AND status <> 'Cancelada'";
$stmt = $conn->prepare($query);
$stmt->bind_param("s", $datetime);
$stmt->execute();
$stmt->store_result();
if ($stmt->num_rows > 0) {
    die("HORARIO_OCUPADO");
}
$stmt->close();

// 4. Se marcar criar conta e não logado, processa registro do novo usuário (antes do agendamento)
$new_user_id = null;
if ($criarConta && !$user_id) {
    // Checa se já existe usuário com aquele email
    $st = $conn->prepare("SELECT id FROM usuarios WHERE email = ?");
    $st->bind_param("s", $email);
    $st->execute();
    $st->bind_result($uid_existente);
    if ($st->fetch()) {
        // Já existe um usuário com esse email
        $new_user_id = $uid_existente;
    }
    $st->close();
    if (!$new_user_id) {
        // Cria nova conta
        $tempPass = substr(str_shuffle('abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789'), 0, 8);
        $hash = password_hash($tempPass, PASSWORD_BCRYPT);
        $st2 = $conn->prepare("INSERT INTO usuarios (nome, email, telefone, idade, senha_hash) VALUES (?,?,?,?,?)");
        $st2->bind_param("sssis", $nome, $email, $telefone, $idade, $hash);
        if ($st2->execute()) {
            $new_user_id = $st2->insert_id;
            // Opcional: enviar email ao usuário com $tempPass
            // (Ver envio de email mais abaixo)
        }
        $st2->close();
    }
    // vincula agendamento ao novo ou existente usuário
    $user_id = $new_user_id;
}

// 5. Insere o agendamento (usando transação para garantir consistência)
$conn->begin_transaction();
try {
    $stmt = $conn->prepare("INSERT INTO agendamentos (usuario_id, nome_visitante, email_visitante, telefone_visitante, idade_visitante, especialidade_id, data_horario, duracao, adicional_reflexo) VALUES (?,?,?,?,?,?,?,?,?)");
    $stmt->bind_param(
        "issssisis", 
        $user_id, $nome, $email, $telefone, $idade, 
        $servico_id, $datetime, $duracao, $add_reflexo
    );
    $stmt->execute();
    $agendamentoId = $stmt->insert_id;
    $stmt->close();

    // 6. Insere formulário de queixa
    $stmt2 = $conn->prepare(
      "INSERT INTO formularios_queixa 
       (agendamento_id, desconforto_principal, queixa_secundaria, tempo_desconforto, classificacao_dor, tratamento_medico,
        em_cuidados_medicos, medicacao, gravida, lesao, torcicolo, dor_coluna, caimbras, distensoes, fraturas, edemas,
        outras_dores, cirurgias, prob_pele, digestivo, intestino, prisao_ventre, circulacao, trombose, cardiaco, pressao,
        artrite, asma, alergia, rinite, diabetes, colesterol, epilepsia, osteoporose, cancer, contagiosa, sono,
        ansiedade, tristeza, raiva, preocupacao, medo, irritacao, angustia, termo_aceite)
       VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)"
    );
    // Muitos parâmetros, vamos bindar em partes para legibilidade:
    $stmt2->bind_param("issssssiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiii", 
        $agendamentoId, $desconforto_princ, $queixa_secundaria, $tempo_desc, $classif_dor, $tratamento_med,
        $em_cuidados, $medicacao, $gravida, /*... continue todos os checkboxes ...*/ $contagiosa, $sono,
        $ansiedade, $tristeza, $raiva, $preocupacao, $medo, $irritacao, $angustia, $termo
    );
    $stmt2->execute();
    $stmt2->close();

    // 7. (Opcional) Commit da transação
    $conn->commit();
} catch (Exception $e) {
    $conn->rollback();
    die("ERRO_AGENDAR");
}

// 8. Envio de emails de notificação
// Email para o administrador com detalhes
$adminEmail = "profissional@seudominio.com";  // colocar e-mail real da terapeuta/admin
$assuntoAdmin = "Novo agendamento solicitado";
$mensagemAdmin = "Detalhes do agendamento:\n";
$mensagemAdmin .= "Nome: ".($user_id ? $nome : $nome)." (".($user_id ? "usuário registrado" : "visitante").")\n";
$mensagemAdmin .= "Email: ".$email."\nTelefone: ".$telefone."\n";
$mensagemAdmin .= "Data/Hora: ".$datetime."\nServiço: ".$servico_id."\nDuração: ".$duracao." min".($add_reflexo? " + Reflexologia adicional":"")."\n";
// Inclui resumo das queixas
if ($desconforto_princ) {
    $mensagemAdmin .= "Queixa principal: $desconforto_princ\n";
    if ($queixa_secundaria) $mensagemAdmin .= "Queixa secundária: $queixa_secundaria\n";
    $mensagemAdmin .= "Tempo de desconforto: $tempo_desc\nIntensidade da dor: $classif_dor\n";
    if ($tratamento_med) $mensagemAdmin .= "Tratamento médico prévio: $tratamento_med\n";
}
// (poderia incluir info sobre checkbox marcados, mas talvez não necessário no email)

// Envia para admin:
mail($adminEmail, $assuntoAdmin, $mensagemAdmin, "From: $email");

// Email de confirmação para o cliente
$assuntoCli = "Agendamento recebido - Terapia Corporal Sistêmica";
$mensagemCli = "Olá $nome,\nSeu agendamento foi recebido e está PENDENTE de confirmação.\n";
$mensagemCli .= "Detalhes: $data às $hora, $duracao min de sessão de ID $servico_id.\n";
$mensagemCli .= "Em breve entraremos em contato para confirmar.\n";
if ($criarConta) {
    if ($new_user_id && isset($tempPass)) {
        $mensagemCli .= "\nUma conta foi criada para você no nosso portal.\n";
        $mensagemCli .= "Login: $email\nSenha temporária: $tempPass\n";
        $mensagemCli .= "Use esses dados para fazer login e acompanhar suas consultas.\n";
    } else if ($user_id) {
        $mensagemCli .= "\nVocê já possui uma conta em nosso portal. Use seu login para acompanhar suas consultas.\n";
    }
}
$mensagemCli .= "\nAtenciosamente,\nConsultório Terapia Corporal";
mail($email, $assuntoCli, $mensagemCli, "From: $adminEmail");

echo "SUCESSO";
?>
