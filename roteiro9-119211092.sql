-- Roteiro 9 comentado:

-- Questão 1:

-- A vw_dptmgr: contém apenas o número do departamento e o nome do gerente (primeiro nome)
CREATE VIEW vw_dptmgr AS
SELECT D.dnumber AS dept_id, E.fname AS manager_name
FROM department D
JOIN employee E ON D.mgrssn = E.ssn;

-- B vw_empl_houston: contém o ssn e o primeiro nome dos empregados com endereço em Houston
CREATE VIEW vw_empl_houston AS
SELECT E.ssn, E.fname
FROM employee E
WHERE E.address LIKE '%Houston%';

-- C vw_deptstats: contém o número do departamento, o nome do departamento e o número de funcionários que trabalham no departamento
CREATE VIEW vw_deptstats AS
SELECT D.dnumber AS dept_id, D.dname AS dept_name, COUNT(E.ssn) AS num_employees
FROM department D
LEFT JOIN employee E ON D.dnumber = E.dno
GROUP BY D.dnumber, D.dname;

-- D vw_projstats: contém o id do projeto e a quantidade de funcionários que trabalham no projeto
CREATE VIEW vw_projstats AS
SELECT P.pnumber AS proj_id, COUNT(W.essn) AS num_employees
FROM project P
LEFT JOIN works_on W ON P.pnumber = W.pno
GROUP BY P.pnumber;

-- Questão 2:

-- Consultando as views criadas:
SELECT * FROM vw_dptmgr;
SELECT * FROM vw_empl_houston;
SELECT * FROM vw_deptstats;
SELECT * FROM vw_projstats;

-- Questão 3:

-- Removendo as views criadas:
DROP VIEW IF EXISTS vw_dptmgr;
DROP VIEW IF EXISTS vw_empl_houston;
DROP VIEW IF EXISTS vw_deptstats;
DROP VIEW IF EXISTS vw_projstats;

-- Questão 4:

CREATE OR REPLACE FUNCTION check_age(emp_ssn CHARACTER(9))
RETURNS TEXT AS
$$

DECLARE
    birth_date DATE;
    current_date DATE := CURRENT_DATE;

BEGIN
    -- Pega a data de nascimento do empregado com base no ssn
    SELECT bdate INTO birth_date
    FROM employee
    WHERE ssn = emp_ssn;

    -- Se a data de nascimento é NULL
    IF birth_date IS NULL THEN
        RETURN 'UNKNOWN';
    END IF;

    -- Se a data de nascimento é uma data futura
    IF birth_date > current_date THEN
        RETURN 'INVALID';
    END IF;

    -- Calcula a idade e retorna o status correspondente
    IF EXTRACT(YEAR FROM age(birth_date)) >= 50 THEN
        RETURN 'SENIOR';
    ELSE
        RETURN 'YOUNG';
    END IF;
END;
$$ LANGUAGE plpgsql;

-- Testando a função.

SELECT check_age('666666609'); 
SELECT check_age('555555500'); 
SELECT check_age('987987987'); 
SELECT check_age('x');         
SELECT check_age(NULL);       

-- Questão 5:

-- Criando a Trigger Procedure:

CREATE OR REPLACE FUNCTION check_mgr()
RETURNS TRIGGER AS
$$
BEGIN
    IF NOT EXISTS (
        SELECT 1 
        FROM employee 
        WHERE ssn = NEW.mgrssn AND dno = NEW.dnumber
    ) THEN
        RAISE EXCEPTION 'Gerente precisa ser empregado do departamento';
    END IF;

    IF NOT EXISTS (
        SELECT 1 
        FROM employee 
        WHERE superssn = NEW.mgrssn
    ) THEN
        RAISE EXCEPTION 'Gerente precisa ter subordinado';
    END IF;

    IF check_age(NEW.mgrssn) <> 'SENIOR' THEN
        RAISE EXCEPTION 'Gerente precisa ser um funcioário SENIOR';
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;
-- Lembrar do uso das exceções para pegar casos que não se encaixem na especificação do roteiro.

-- Criando a Trigger:

CREATE TRIGGER check_mgr_trigger
BEFORE INSERT OR UPDATE ON department
FOR EACH ROW EXECUTE FUNCTION check_mgr();
-- check_mgr() será chamada para cada linha afetada em caso de mudanças.

-- Testando a Trigger:

-- Deletando ela para fazer as inserções:
DROP TRIGGER IF EXISTS check_mgr_trigger ON department;

-- Inserções
INSERT INTO department VALUES ('Test', 2, '999999999', NOW());
INSERT INTO employee VALUES ('Joao', 'A', 'Silva', '999999999', '10-OCT-1950', '123 Peachtree, Atlanta, GA', 'M', 85000, NULL, 2);
INSERT INTO employee VALUES ('Jose', 'A', 'Santos', '999999998', '10-OCT-1950', '123 Peachtree, Atlanta, GA', 'M', 85000, '999999999', 2);

-- Criando novamente a Trigger:
CREATE TRIGGER check_mgr_trigger
BEFORE INSERT OR UPDATE ON department
FOR EACH ROW EXECUTE FUNCTION check_mgr();

-- Testando Updates e Deletes:

UPDATE department SET mgrssn = '999999999' WHERE dnumber = 2;
UPDATE department SET mgrssn = NULL WHERE dnumber = 2; -- Falhou como descrito.
UPDATE department SET mgrssn = '999' WHERE dnumber = 2; --Falhou como descrito.
UPDATE department SET mgrssn = '111111100' WHERE dnumber = 2;-- Falhou como descrito.
UPDATE employee SET bdate = '10-OCT-2000' WHERE ssn = '999999999';
UPDATE department SET mgrssn = '999999999' WHERE dnumber = 2; -- Falhou como descrito.
UPDATE employee SET bdate = '10-OCT-1950' WHERE ssn = '999999999';
UPDATE department SET mgrssn = '999999999' WHERE dnumber = 2;
DELETE FROM employee WHERE superssn = '999999999';
UPDATE department SET mgrssn = '999999999' WHERE dnumber = 2; --Falha como descrito.
DELETE FROM employee WHERE ssn = '999999999';
DELETE FROM department WHERE dnumber = 2;

-- Ao final de tudo, os updates e deletes funcionaram como estão descritos no roteiro, garantindo que a função e os trigger's funcionario de forma correta :D.

-- Testes adicionais (Irei comentar apenas as falhas.):

-- Inserir Departamente sem existir gerente.
INSERT INTO department VALUES ('Invalid Dept', 3, '000000001');

INSERT INTO employee VALUES ('Alice', 'B', 'Smith', '111111110', '10-OCT-1970', '456 Elm St, Seattle, WA', 'F', 75000, NULL, 1);

-- Inserir um departamento com o gerente sem empregados.
INSERT INTO department VALUES ('Dept with Invalid Manager', 4, '111111110');

-- Inserir um funcionário que é SENIOR e possui empregados.
INSERT INTO employee VALUES ('Bob', 'C', 'Johnson', '222222220', '10-OCT-1950', '789 Maple St, Portland, OR', 'M', 85000, NULL, 2);
INSERT INTO employee VALUES ('Charlie', 'C', 'Brown', '222222221', '10-OCT-1980', '789 Maple St, Portland, OR', 'M', 65000, '222222220', 2);

-- Essa deveria passar mas da erro, deveria inserir um departamento com esse gerente.
INSERT INTO department VALUES ('Valid Dept', 5, '222222220');