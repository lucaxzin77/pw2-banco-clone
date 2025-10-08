USE sistema_bancario;

DROP PROCEDURE IF EXISTS p_CadClientePF;
DELIMITER $$

CREATE PROCEDURE IF NOT EXISTS p_CadClientePF(
    IN p_nome VARCHAR(100),
    IN p_email VARCHAR(100),
    IN p_tel VARCHAR(20),
    IN p_endereco VARCHAR(200),
    IN p_user VARCHAR(50),
    IN p_pass VARCHAR(100),
    IN p_cpf VARCHAR(14),
    IN p_data_nasc DATE
)
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION 
    BEGIN
        ROLLBACK;
    END;

    START TRANSACTION;

    INSERT INTO Clientes(nome, email, telefone, endereco, username, password)
    VALUES (p_nome, p_email, p_tel, p_endereco, p_user, p_pass);

    SET @cliente_id = LAST_INSERT_ID();

    INSERT INTO Clientes_PF(id_cliente, cpf, data_nascimento)
    VALUES (@cliente_id, p_cpf, p_data_nasc);

    COMMIT;
END$$

DELIMITER ;

DROP PROCEDURE IF EXISTS p_CadClientePJ;
DELIMITER $$

CREATE PROCEDURE IF NOT EXISTS p_CadClientePJ(
    IN p_nome VARCHAR(100),
    IN p_email VARCHAR(100),
    IN p_tel VARCHAR(20),
    IN p_endereco VARCHAR(200),
    IN p_user VARCHAR(50),
    IN p_pass VARCHAR(100),
    IN p_cnpj VARCHAR(18),
    IN p_razao_social VARCHAR(100),
    IN p_data_fundacao DATE
)
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION 
    BEGIN
        ROLLBACK;
    END;

    START TRANSACTION;

    INSERT INTO Clientes(nome, email, telefone, endereco, username, password)
    VALUES (p_nome, p_email, p_tel, p_endereco, p_user, p_pass);

    SET @cliente_id = LAST_INSERT_ID();

    INSERT INTO Clientes_PJ(id_cliente, cnpj, razao_social, data_fundacao)
    VALUES (@cliente_id, p_cnpj , p_razao_social, p_data_fundacao);

    COMMIT;
END$$

DELIMITER;

DROP PROCEDURE IF EXISTS p_CadConta;

DELIMITER $$

CREATE PROCEDURE IF NOT EXISTS p_CadConta(
    IN p_cliente_id INT,
    IN p_tipo_conta ENUM('corrente', 'poupanca'),
    IN p_saldo_inicial DECIMAL(15,2) DEFAULT 0.00,
    IN p_limite DECIMAL(15,2) DEFAULT 0.00
)
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
    END;

    START TRANSACTION;

    IF NOT EXISTS (SELECT 1 FROM Clientes WHERE id = p_cliente_id) THEN
        ROLLBACK;
    END IF;

    INSERT INTO Contas(cliente_id, tipo_conta, saldo, limite)
    VALUES (p_cliente_id, p_tipo_conta, p_saldo_inicial, p_limite);

    COMMIT;
END$$

DELIMITER ;

DELIMITER $$

CREATE PROCEDURE IF NOT EXISTS p_Saque(
    IN p_conta_id INT,
    IN p_valor DECIMAL(15,2)
)
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
    END;

    START TRANSACTION;
        
    INSERT INTO Transacoes(conta_id, tipo, valor, descricao)
    VALUES(p_conta_id,'saque', p_valor, CONCAT('Saque de R$', p_valor, ' realizado!'));

    COMMIT;
END$$

DELIMITER;

DELIMITER $$

CREATE PROCEDURE p_Deposito(
    IN p_conta_id INT,
    IN p_valor DECIMAL(15,2)
)
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
    END;

    START TRANSACTION;
        
    INSERT INTO Transacoes(conta_id, tipo, valor, descricao)
    VALUES(p_conta_id,'deposito', p_valor, CONCAT('Deposito de R$', p_valor, ' realizado!'));

    COMMIT;
END$$

DELIMITER;

DELIMITER $$

CREATE PROCEDURE p_Transferencia(
    IN p_conta_origem INT,
    IN p_conta_destino INT,
    IN p_valor_saque DECIMAL(15,2),
    IN p_valor_deposito DECIMAL(15,2)
)
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
    END;

    IF NOT EXISTS (SELECT 1 FROM Contas WHERE id = p_conta_origem) THEN
        ROLLBACK;
    END IF;

    IF NOT EXISTS (SELECT 1 FROM Contas WHERE id = p_conta_destino) THEN
        ROLLBACK;
    END IF;

    START TRANSACTION;
        
    CALL p_Saque(p_conta_origem, p_valor_saque);
    CALL p_Deposito(p_conta_destino, p_valor_deposito);

    INSERT INTO Transacoes(conta_id, tipo, valor, descricao)
    VALUES(p_conta_origem, 'transferencia', p_valor_saque, CONCAT('Transferencia de R$', p_valor_deposito, ' realizada para a conta ID:', p_conta_destino));

    COMMIT;
END$$

DELIMITER;