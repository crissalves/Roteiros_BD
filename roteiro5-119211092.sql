--Roteiro 5:

--Questão 1:
SELECT count(sex) 
FROM employee e 
WHERE e.sex = 'F';

--Questão 2:
SELECT AVG(salary) AS avg
FROM employee
WHERE TRIM(RIGHT(address, 2)) = 'TX' AND sex = 'M';

--Questão 3: Terminada
SELECT s.ssn AS ssn_supervisor,COUNT(e.ssn) AS qtd_supervisionados 
FROM employee e
LEFT OUTER JOIN employee s ON e.superssn = s.ssn
GROUP by s.ssn 
ORDER BY qtd_supervisionados;
-- Falta os sem Supervisores.(feito)
-- Usar o Join para pegar os sem supervisores usando uma segunda tabela.

--Questão 4: Terminada
SELECT s.fname AS nome_supervisor, COUNT(e.ssn) AS qtd_supervisionados 
FROM employee e 
INNER JOIN employee s ON e.superssn = s.ssn
GROUP BY nome_supervisor
ORDER BY qtd_supervisionados;
-- Inner join é os valores que a tabela tem em comum levando em consideração a condição.

--Questão 5:
SELECT s.fname AS nome_supervisor,COUNT(e.ssn) AS qtd_supervisionados 
FROM employee e
LEFT OUTER JOIN employee s ON e.superssn = s.ssn
GROUP by nome_supervisor;
--LEFT OUTER são so valores que se repeten nas tabelas levando em consideração a condição.

--Questão 6:
SELECT COUNT(essn) AS qtd
FROM works_on 
WHERE pno IN (
    SELECT pno
    FROM works_on 
    GROUP BY pno
    ORDER BY COUNT(pno) ASC
    LIMIT 1
);


--Questão 7:
SELECT pno AS num_projeto, COUNT(essn) AS qtd_func
FROM works_on
GROUP BY pno
HAVING COUNT(essn) = (
    SELECT MIN(ocorrencia)
    FROM (
        SELECT COUNT(essn) AS ocorrencia
        FROM works_on
        GROUP BY pno
    ) AS subconsulta
)
ORDER BY num_projeto;


--Questão 8:
SELECT pno AS num_proj, AVG(salary) AS media_sal
FROM works_on wo
JOIN employee e ON wo.essn = e.ssn
GROUP BY pno;


-- Questão 9:
SELECT wo.pno AS num_proj, p.pname AS nome_proj, AVG(e.salary) AS media_sal
FROM works_on wo
JOIN employee e ON wo.essn = e.ssn
JOIN project p ON wo.pno = p.pnumber
GROUP BY p.pnumber, p.pname, wo.pno;

--Questão 10:

SELECT e.fname, e.salary
FROM employee e
WHERE e.salary > (
    SELECT MAX(emp.salary)
    FROM works_on wo
    JOIN employee emp ON wo.essn = emp.ssn
    WHERE wo.pno = 92
)
AND e.ssn NOT IN (
    SELECT wo2.essn
    FROM works_on wo2
    WHERE wo2.pno = 92
);


--Questão 11:
SELECT e.ssn, COUNT(wo.pno) AS qtd_proj
FROM employee e
LEFT OUTER JOIN works_on wo ON e.ssn = wo.essn
GROUP BY e.ssn
ORDER BY qtd_proj;

--Questão 12:
SELECT p.pnumber AS num_proj, COUNT(wo.essn) AS qtd_func
FROM project p
LEFT OUTER JOIN works_on wo ON p.pnumber = wo.pno
GROUP BY p.pnumber
HAVING COUNT(wo.essn) < 5
ORDER BY qtd_func;


--Questão 13:
SELECT e.fname
FROM employee e
WHERE e.ssn IN (
    SELECT d.essn
    FROM dependent d
) AND d.ssn IN (
    SELECT wo.essn
    FROM works_on wo
    WHERE wo.pno IN (
        SELECT p.pnumber
        FROM project p
        WHERE p.plocation = 'Sugarland'
    )
);


--Questão 14:
SELECT dname
FROM department d
WHERE NOT EXISTS (
    SELECT 1
    FROM project p
    WHERE p.dnum = d.dnumber
);


--Questão 15:
SELECT fname, lname
FROM employee e
WHERE ssn <> '123456789'
AND NOT EXISTS (
    SELECT 1
    FROM works_on w1
    WHERE w1.essn = '123456789'
    AND NOT EXISTS (
        SELECT 1
        FROM works_on w2
        WHERE w2.essn = e.ssn
        AND w2.pno = w1.pno
    )
);
