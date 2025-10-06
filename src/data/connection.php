<?php
require_once 'db_config.php';
try {
    $conn = new PDO(
        dsn: "mysql:host=" . DB_HOST . ";dbname=" . DB_NAME, 
        username: DB_USER, 
        password: DB_PASS
    );
    $conn->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
} catch (PDOException $e) {
    echo "Conexão falhou: " . $e->getMessage();
}