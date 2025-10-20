USE sistema_bancario;

DROP PROCEDURE IF EXISTS clientePF_cadastrar;

DELIMITER $$

CREATE PROCEDURE IF NOT EXISTS clientePF_cadastrar(
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

DROP PROCEDURE IF EXISTS clientePF_update;

DELIMITER $$

CREATE PROCEDURE IF NOT EXISTS clientePF_update(
    IN p_id INT UNSIGNED,
    IN p_nome VARCHAR(100),
    IN p_email VARCHAR(100),
    IN p_tel VARCHAR(20),
    IN p_endereco VARCHAR(200),
    IN p_user VARCHAR(50),
    IN p_pass VARCHAR(100),
    IN p_status ENUM('ativo', 'inativo'),
    IN p_cpf VARCHAR(14),
    IN p_data_nasc DATE
)
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION 
    BEGIN
        ROLLBACK;
    END;

    START TRANSACTION;

    UPDATE Clientes SET nome = p_nome, email = p_email, telefone = p_tel, endereco = p_endereco, username = p_user, password = p_pass, status = p_status
    WHERE id = p_id;

    UPDATE Clientes_PF SET cpf = p_cpf, data_nascimento = p_data_nasc 
    WHERE id = p_id;

    COMMIT;
END$$

DELIMITER ;

DROP PROCEDURE IF EXISTS clientePF_getAll;

DELIMITER $$
CREATE PROCEDURE IF NOT EXISTS clientePF_getAll(
    IN p_nome VARCHAR(100)
)
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
    END;

    START TRANSACTION;
        SELECT * FROM Clientes_PF WHERE nome LIKE "%p_nome%";

    COMMIT;
END$$

DELIMITER ;

DROP PROCEDURE IF EXISTS clientePF_getByCPF;

DELIMITER $$
CREATE PROCEDURE IF NOT EXISTS clientePF_getByCPF(
    IN p_cpf VARCHAR(14)
)
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
    END;

    START TRANSACTION;
        SELECT * FROM Clientes_PF, Clientes WHERE Clientes.id = Clientes_PF.cliente_id 
        AND cpf LIKE "%p_cpf%";

    COMMIT;
END$$

DELIMITER ;

DROP PROCEDURE IF EXISTS clientePF_getByID;

DELIMITER $$
CREATE PROCEDURE IF NOT EXISTS clientePF_getByID(
    IN p_id INT UNSIGNED
)
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
    END;

    START TRANSACTION;
        SELECT * FROM Clientes_PF, Clientes WHERE Clientes_PF.cliente_id = p_id 
        AND Clientes_PF.cliente_id = Clientes.id ;

    COMMIT;
END$$

DELIMITER ;

DROP PROCEDURE IF EXISTS clientePF_getByEmail;

DELIMITER $$
CREATE PROCEDURE IF NOT EXISTS clientePF_getByEmail(
    IN p_email VARCHAR(100)
)
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
    END;

    START TRANSACTION;
        SELECT * FROM Clientes_PF, Clientes WHERE Clientes_PF.cliente_id = Clientes.id
        AND Clientes.email LIKE "%p_email%";

    COMMIT;
END$$
DELIMITER ;
-- CLIENTE PJ ---------------------------------

 DROP PROCEDURE IF EXISTS clientePJ_cadastrar;
 DELIMITER $$
 CREATE PROCEDURE IF NOT EXISTS clientePJ_cadastrar(
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

     INSERT INTO Clientes_PJ(id_cliente, cnpj, razao_social, data_fundacao)
     VALUES (LAST_INSERT_ID(), p_cnpj , p_razao_social, p_data_fundacao);

     COMMIT;
 END$$
 DELIMITER ;

DROP PROCEDURE IF EXISTS clientePJ_update;
DELIMITER $$
CREATE PROCEDURE IF NOT EXISTS clientePJ_update(
    IN p_id INT UNSIGNED,
    IN p_nome VARCHAR(100),
    IN p_email VARCHAR(100),
    IN p_tel VARCHAR(20),
    IN p_endereco VARCHAR(200),
    IN p_user VARCHAR(50),
    IN p_pass VARCHAR(100),
    IN p_status ENUM('ativo', 'inativo'),
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

        UPDATE Clientes 
        SET nome = p_nome, email = p_email, telefone = p_tel, endereco = p_endereco, username = p_user, password = p_pass, status = p_status;
    
        UPDATE Clientes_PJ 
        SET cnpj = p_cnpj, razao_social = p_razao_social, data_fundacao = p_data_fundacao;

     COMMIT;
 END$$
 DELIMITER ;

DROP PROCEDURE IF EXISTS ClientePJ_getAll;

DELIMITER $$
CREATE PROCEDURE IF NOT EXISTS ClientePJ_getAll(
    IN p_nome VARCHAR(100),
    IN p_razao_social VARCHAR(100)
)
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
    END;

    START TRANSACTION;
        SELECT * FROM Clientes_PJ, Clientes WHERE Clientes_PJ.cliente_id = Clientes.id 
        AND Clientes.nome LIKE "%p_nome%"
        AND razao_social LIKE "%p_razao_social%";
    COMMIT;
END$$
DELIMITER ;

DROP PROCEDURE IF EXISTS ClientePJ_getByCNPJ;

DELIMITER $$

CREATE PROCEDURE IF NOT EXISTS ClientePJ_getbyCNPJ(
    IN p_cnpj VARCHAR(18)
)
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
    END;

    START TRANSACTION;
        SELECT * FROM Clientes_PJ, Clientes WHERE Clientes_PJ.cliente_id = Clientes.id
        AND cnpj LIKE "%p_cnpj%";
    COMMIT;
END$$

DELIMITER ;

DROP PROCEDURE IF EXISTS ClientePJ_getByID;

DELIMITER $$

CREATE PROCEDURE IF NOT EXISTS ClientePJ_getByID(
    IN p_id INT UNSIGNED
)
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
    END;

    START TRANSACTION;
        SELECT * FROM Clientes_PJ, Clientes WHERE Clientes_PJ.cliente_id = Clientes.id
        AND Clientes_PJ.cliente_id = Clientes.id; 
    COMMIT;
END$$

DELIMITER ;

DROP PROCEDURE IF EXISTS clientePJ_getByEmail;

DELIMITER $$
CREATE PROCEDURE IF NOT EXISTS clientePJ_getByEmail(
    IN p_email VARCHAR(100)
)
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
    END;

    START TRANSACTION;
        SELECT * FROM Clientes_PJ, Clientes WHERE Clientes_PJ.cliente_id = Clientes.id
        AND Clientes.email LIKE "%p_email%";

    COMMIT;
END$$
DELIMITER ;

-- CONTA -----------------------------------------------------------------------------

DROP PROCEDURE IF EXISTS Conta_create;

DELIMITER $$

CREATE PROCEDURE IF NOT EXISTS Conta_create(
    IN p_nome VARCHAR(100),
    IN p_email VARCHAR(100),
    IN p_tel VARCHAR(20),
    IN p_endereco VARCHAR(200),
    IN p_user VARCHAR(50),
    IN p_pass VARCHAR(100),
    IN p_cliente_id INT UNSIGNED,
    IN p_tipo_conta ENUM('corrente', 'poupanca') NOT NULL,
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

        INSERT INTO Contas(cliente_id, tipo_conta)
        VALUES (@cliente_id, p_tipo_conta);

    COMMIT;
END$$

