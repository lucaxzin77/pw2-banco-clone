CREATE DATABASE IF NOT EXISTS sistema_bancario;

USE sistema_bancario;

DROP TABLE IF EXISTS Transacoes;

DROP TABLE IF EXISTS Contas;

DROP TABLE IF EXISTS Clientes_PJ;

DROP TABLE IF EXISTS Clientes_PF;

DROP Table IF EXISTS Clientes;

CREATE TABLE IF NOT EXISTS Clientes (
    id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    telefone VARCHAR(15),
    endereco VARCHAR(255),
    username VARCHAR(50) NOT NULL UNIQUE,
    password VARCHAR(255) NOT NULL,
    status ENUM('ativo', 'inativo') DEFAULT 'ativo',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS Clientes_PF (
    cliente_id INT UNSIGNED PRIMARY KEY,
    cpf VARCHAR(14) NOT NULL UNIQUE,
    data_nascimento DATE,
    FOREIGN KEY (cliente_id) REFERENCES Clientes(id) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS Clientes_PJ (
    cliente_id INT UNSIGNED PRIMARY KEY,
    cnpj VARCHAR(18) NOT NULL UNIQUE,
    razao_social VARCHAR(100),
    data_fundacao DATE,
    FOREIGN KEY (cliente_id) REFERENCES Clientes(id) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS Contas (
    id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    cliente_id INT UNSIGNED,
    tipo_conta ENUM('corrente', 'poupanca') NOT NULL,
    saldo DECIMAL(15, 2) DEFAULT 0.00,
    limite DECIMAL(15, 2) DEFAULT 0.00,
    status ENUM('ativa', 'inativa') DEFAULT 'ativa',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (cliente_id) REFERENCES Clientes(id) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS Transacoes (
    id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    conta_id BIGINT UNSIGNED,
    data_transacao TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    tipo ENUM('deposito', 'saque', 'transferencia') NOT NULL,
    valor DECIMAL(15, 2) NOT NULL,
    descricao VARCHAR(255),
    FOREIGN KEY (conta_id) REFERENCES Contas(id) ON DELETE CASCADE
);
CREATE INDEX idx_cliente_id ON Contas(cliente_id);
CREATE INDEX idx_conta_id ON Transacoes(conta_id);