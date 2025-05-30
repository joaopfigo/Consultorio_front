<?php
$host = "localhost";
$user = "root";
$pass = "";
$dbname = "terapia_corporal";

$conn = new mysqli($host, $user, $pass, $dbname);

if ($conn->connect_error) {
    die(json_encode(["success" => false, "message" => "Erro na conexão com o banco de dados."]));
}
?>
