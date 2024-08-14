-- Roteiro 4 (Consultas em SQL)

--Questão 1:
SELECT * FROM department;

--Questão 2:
SELECT * FROM dependent;

--Questão 3:
SELECT * FROM dept_locatipons;

--Questão 4:
SELECT * FROM employee;

--Questão 5:
SELECT * FROM project;

--Questão 6:
SELECT * FROM works_on;

--Questão 7: Retornar os nomes(Primeiro e Ultimo) dos funcionários homens;
SELECT fname, lname FROM employee WHERE sex = 'M';

--Questão 8: Retornar os nomes(primeiro) dos funcionários homens que não possuem surpervirsor.
SELECT fname FROM employee WHERE superssn IS NULL;

--Questão 9: Retornar os nomes dos funcionários (primeiro) e o nome (primeiro) do seu surpervisor, apenas para os funcionarios que possuem surpervisor.
SELECT fname AS nome_funcionario, (SELECT fname FROM employee s WHERE e.superssn = s.ssn)AS nome_Supervisor FROM employee e WHERE e.superssn IS NOT NULL;

--Questão 10: Retornar nomes (primeiro) dos funcionários cujo supervisor se chama Fraklin;
SELECT fname AS nome_funcionario FROM employee WHERE superssn = (SELECT ssn FROM employee WHERE fname = 'Franklin');

--Questão 11: Retornar os nomes dos departamentos e suas Localizações;
SELECT dname AS nome_departamento,(SELECT dLocation FROM dept_locations dl WHERE dl.dnumber = d.dnumber)AS local_departamento FROM department d;
--11 Perguntar ao professor, como fazer sem subconsultas, ou se é permitido o resultado com duas consultas separadas.

--Implementação sem SUBQUERRY:
SELECT dname AS nome_departamento, dLocation AS local_departamento FROM department d, dept_locations dl WHERE d.dnumber = dl.dnumber;


--Questão 12: Retornar os nomes dos departamentos localizados em cidades que começa com a letra 'S'.
SELECT d.dname AS nome_departamento FROM department d, dept_locations dl WHERE d.dnumber = dl.dnumber, dl.location 'f';