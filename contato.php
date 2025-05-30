<?php
include 'conexao.php';
$nome = $_POST['nome'];
$email = $_POST['email'];
$mensagem = $_POST['mensagem'];

// Envia email para admin
$para = "profissional@seudominio.com";
$assunto = "Mensagem de Contato de $nome";
$corpo = "Nome: $nome\nEmail: $email\nMensagem:\n$mensagem";
$headers = "From: $email";  // define remetente como o email do usuário
mail($para, $assunto, $corpo, $headers);

// Salva no banco (opcional)
$stmt = $conn->prepare("INSERT INTO contatos (nome, email, mensagem) VALUES (?,?,?)");
$stmt->bind_param("sss", $nome, $email, $mensagem);
$stmt->execute();
$stmt->close();

echo "OK";
?>
