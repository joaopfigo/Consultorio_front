<?php
include 'conexao.php';
session_start();

$agendamento_id = $_POST['agendamento_id'] ?? null;
$desconforto_principal = $_POST['principal_desconforto'] ?? '';
$queixa_secundaria = $_POST['queixa_secundaria'] ?? '';
$tempo_desconforto = $_POST['tempo_desconforto'] ?? '';
$classificacao_dor = $_POST['classificacao_dor'] ?? '';
$tratamento_medico = $_POST['tratamento_medico'] ?? '';

if (!$agendamento_id) {
    die("AGENDAMENTO_INVALIDO");
}

$stmt = $conn->prepare("INSERT INTO formularios_queixa 
    (agendamento_id, desconforto_principal, queixa_secundaria, tempo_desconforto, classificacao_dor, tratamento_medico) 
    VALUES (?, ?, ?, ?, ?, ?)
    ON DUPLICATE KEY UPDATE
    desconforto_principal = VALUES(desconforto_principal),
    queixa_secundaria = VALUES(queixa_secundaria),
    tempo_desconforto = VALUES(tempo_desconforto),
    classificacao_dor = VALUES(classificacao_dor),
    tratamento_medico = VALUES(tratamento_medico)
");
$stmt->bind_param("isssss", $agendamento_id, $desconforto_principal, $queixa_secundaria, $tempo_desconforto, $classificacao_dor, $tratamento_medico);
$stmt->execute();
$stmt->close();

echo "SUCESSO";
?>