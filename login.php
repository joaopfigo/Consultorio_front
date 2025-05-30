<?php
require_once 'conexao.php'; // caminho correto

header('Content-Type: application/json');

if (empty($_POST['email']) || empty($_POST['senha'])) {
    echo json_encode(['success' => false, 'message' => 'Preencha email e senha.']);
    exit;
}

$email = $_POST['email'];
$senha = $_POST['senha'];

// Busca o usuário pelo email
$stmt = $conn->prepare("SELECT id, nome, senha_hash FROM usuarios WHERE email = ?");
$stmt->bind_param("s", $email);
$stmt->execute();
$result = $stmt->get_result();
if ($row = $result->fetch_assoc()) {
    if (password_verify($senha, $row['senha_hash'])) {
        // Login ok!
        session_start();
        $_SESSION['usuario_id'] = $row['id'];
        $_SESSION['usuario_nome'] = $row['nome'];
        echo json_encode(['success' => true]);
    } else {
        echo json_encode(['success' => false, 'message' => 'Senha incorreta!']);
    }
} else {
    echo json_encode(['success' => false, 'message' => 'Usuário não encontrado!']);
}
$stmt->close();
$conn->close();
?>
