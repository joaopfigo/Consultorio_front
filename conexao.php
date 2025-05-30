<?php
// NÃO precisa de conexão com o banco para apenas enviar e-mail

// Pegue os dados do formulário
$nome = $_POST['nome'] ?? '';
$email = $_POST['email'] ?? '';
$mensagem = $_POST['mensagem'] ?? '';

// Defina o destinatário fixo
$destino = "joao.pedro@gbv.g12.br";

// Monta o assunto e corpo do e-mail
$assunto = "Contato do site - $nome";
$corpo = "Nome: $nome\n";
$corpo .= "E-mail: $email\n";
$corpo .= "Mensagem:\n$mensagem\n";

// Cabeçalhos para mostrar o remetente
$cabecalhos = "From: $email\r\n";
$cabecalhos .= "Reply-To: $email\r\n";
$cabecalhos .= "Content-Type: text/plain; charset=UTF-8\r\n";

// Tenta enviar o e-mail
if (mail($destino, $assunto, $corpo, $cabecalhos)) {
    echo "SUCESSO";
} else {
    echo "ERRO";
}
?>
