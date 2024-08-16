--Roteiro 5:

--Questão 1:
SELECT count(sex) FROM employee e WHERE e.sex = 'F';

--Questão 2:


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
WHERE pno IN (SELECT COUNT(pno) AS ocorrencia
    FROM works_on
    GROUP BY pno 
    ORDER BY ocorrencia ASC
);













--Questão 7:
SELECT COUNT(essn) AS qtd
FROM works_on
WHERE pno IN (SELECT COUNT(pno) AS ocorrencia
    FROM works_on
    GROUP BY pno 
    ORDER BY ocorrencia ASC
    LIMIT 1
);


