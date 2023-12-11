## 1-Selecionar a quantidade total de estudantes cadastrados no banco
```mysql
-- Seleciona a quantidade total de alunos cadastrados no banco de dados
SELECT 'Total de Alunos' AS Categoria, COUNT(id_aluno) AS Valor
FROM aluno;
```
**Resultado**
| Categoria        | Valor |
|------------------|-------|
| Total de Alunos  | 234   |
## 2-Selecionar quais pessoas facilitadoras atuam em mais de uma turma
```mysql
-- Seleciona os professores que atuam em mais de uma turma
SELECT
    professor.nome_professor,
    COUNT(DISTINCT turma.id_turma) AS quantidade_turmas
FROM
    professor
JOIN disciplinas ON professor.id_professor = disciplinas.id_professor
JOIN modulo ON disciplinas.id_modulo = modulo.id_modulo
JOIN turno ON modulo.id_curso = turno.id_curso
JOIN turma ON turno.id_turma = turma.id_turma
GROUP BY
    professor.id_professor
HAVING
    quantidade_turmas > 1;
```
**Resultado**
| Nome Professor           | Quantidade de Turmas |
|--------------------------|-----------------------|
| Isabella Teixeira        | 2                     |
| Sr. Kevin Moura          | 3                     |
| Sarah Nunes              | 6                     |
| Caio Moraes              | 2                     |
| Pedro Henrique Cardoso   | 4                     |
| Yuri Castro              | 3                     |
| Raquel Costela           | 4                     |
| Bárbara das Neves        | 3                     |
| Leandro Fogaça           | 2                     |
| Dr. Augusto Nascimento   | 3                     |
| Eloah Campos             | 2                     |
| Davi Souza               | 4                     |

## 3-Crie uma view que selecione a porcentagem de estudantes com status de evasão agrupados por turma
```mysql
-- View para descobrir a porcentagem de evasão por turma
CREATE VIEW evasao_turma AS
SELECT
    t.id_turma,
    COUNT(a.id_aluno) AS total_alunos,
    SUM(CASE WHEN at.status = 'evasão' THEN 1 ELSE 0 END) AS alunos_evasao,
    (SUM(CASE WHEN at.status = 'evasão' THEN 1 ELSE 0 END) / COUNT(a.id_aluno)) * 100 AS percentual_evasao
FROM
    turma t
    JOIN aluno_turma at ON t.id_turma = at.id_turma
    JOIN aluno a ON at.id_aluno = a.id_aluno
GROUP BY
    t.id_turma;
```
**Seleciona a view**
```mysql
SELECT * FROM evasao_turma;
```
**Resultado**
| id_turma | Total de Alunos | Alunos com Evasão | Percentual de Evasão |
|----------|------------------|-------------------|-----------------------|
| 1        | 2                | 0                 | 0.0000                |
| 2        | 6                | 2                 | 33.3333               |
| 4        | 6                | 4                 | 66.6667               |
| 5        | 6                | 5                 | 83.3333               |
| 6        | 5                | 2                 | 40.0000               |
| 7        | 6                | 3                 | 50.0000               |
| 8        | 3                | 1                 | 33.3333               |
| 9        | 6                | 3                 | 50.0000               |
| 10       | 2                | 1                 | 50.0000               |
| 11       | 6                | 3                 | 50.0000               |
| 12       | 5                | 1                 | 20.0000               |
| 13       | 6                | 2                 | 33.3333               |
| 14       | 5                | 2                 | 40.0000               |
| 15       | 2                | 0                 | 0.0000                |
| 16       | 4                | 0                 | 0.0000                |
| 17       | 4                | 2                 | 50.0000               |
| 18       | 8                | 3                 | 37.5000               |
| 19       | 4                | 1                 | 25.0000               |
| 20       | 7                | 5                 | 71.4286               |
| 21       | 4                | 3                 | 75.0000               |
| 22       | 5                | 3                 | 60.0000               |
| 23       | 7                | 4                 | 57.1429               |
| 24       | 5                | 1                 | 20.0000               |
| 25       | 4                | 0                 | 0.0000                |
| 26       | 4                | 3                 | 75.0000               |
| 27       | 7                | 4                 | 57.1429               |
| 28       | 5                | 4                 | 80.0000               |
| 29       | 5                | 2                 | 40.0000               |
| 30       | 8                | 4                 | 50.0000               |
| 31       | 5                | 2                 | 40.0000               |
| 32       | 6                | 3                 | 50.0000               |
| 34       | 4                | 2                 | 50.0000               |
| 35       | 6                | 2                 | 33.3333               |
| 36       | 3                | 3                 | 100.0000              |
| 37       | 1                | 0                 | 0.0000                |
| 38       | 3                | 1                 | 33.3333               |
| 39       | 8                | 7                 | 87.5000               |
| 40       | 4                | 2                 | 50.0000               |
| 41       | 5                | 3                 | 60.0000               |
| 42       | 5                | 2                 | 40.0000               |
| 43       | 5                | 2                 | 40.0000               |
| 44       | 6                | 4                 | 66.6667               |
| 45       | 6                | 3                 | 50.0000               |
| 46       | 4                | 2                 | 50.0000               |
| 47       | 4                | 0                 | 0.0000                |
| 48       | 4                | 1                 | 25.0000               |
| 49       | 4                | 2                 | 50.0000               |
| 50       | 4                | 3                 | 75.0000               |

## 4-Crie um trigger para ser disparado quando o atributo status de um estudante for atualizado e inserir um novo dado em uma tabela de log
```mysql
-- Definição do delimitador para o trigger
DELIMITER //
-- Criação do trigger para registrar alterações no status de alunos em aluno_turma
CREATE TRIGGER aluno_status AFTER
    UPDATE ON aluno_turma
FOR EACH ROW
BEGIN
    INSERT INTO log(id_aluno, novo_status, antigo_status, data_modificacao)
    VALUES(NEW.id_aluno, NEW.status, OLD.status, NOW());
END;
//
-- Restauração do delimitador padrão
DELIMITER ;
```
**Atualizando o atributo "presenca" na tabela "aluno_turma".**
```mysql
update aluno_turma
SET status = 'teste'
where id_aluno = 3 ;
```
**Seleciona o log**
```mysql
SELECT * FROM log
```
**Resultado**
| id_log | id_aluno | novo_status | antigo_status | data_modificacao       |
|--------|----------|-------------|---------------|------------------------|
| 36     | 9        | teste       | ativo         | 2023-12-11 15:18:34    |
| 37     | 17       | teste       | ativo         | 2023-12-11 15:18:34    |
| 38     | 27       | teste       | ativo         | 2023-12-11 15:18:34    |
| 39     | 45       | teste       | ativo         | 2023-12-11 15:18:34    |
| 40     | 77       | teste       | ativo         | 2023-12-11 15:18:34    |
| 41     | 104      | teste       | ativo         | 2023-12-11 15:18:34    |
## 5-Crie um script que consulte os nomes dos alunos que estão matriculados em uma turma específica, juntamente com o nome do professor responsável pela disciplina associada a essa turma.
```mysql
-- Consulta para obter os nomes dos alunos e o nome do professor associado à turma
SELECT 
    aluno.nome_aluno AS NomeAluno,
    professor.nome_professor AS NomeProfessor
FROM 
    aluno_turma
JOIN aluno ON aluno_turma.id_aluno = aluno.id_aluno
JOIN turma ON aluno_turma.id_turma = turma.id_turma
JOIN disciplinas ON turma.id_turma = disciplinas.id_modulo
JOIN professor ON disciplinas.id_professor = professor.id_professor
WHERE 
    turma.id_turma = 1;
```
**Resultado**
| Nome do Aluno              | Nome do Professor         | Nome do Curso                                 |
|----------------------------|---------------------------|-----------------------------------------------|
| Ana Vitória Fogaça         | Pedro Henrique Cardoso   | Desenvolvimento Web com HTML                  |
| Maria Fernanda Rodrigues   | Pedro Henrique Cardoso   | Desenvolvimento Web com HTML                  |
| Ana Vitória Fogaça         | Raquel Costela           | Desenvolvimento Web com HTML                  |
| Maria Fernanda Rodrigues   | Raquel Costela           | Desenvolvimento Web com HTML                  |
| Bárbara Oliveira           | Bárbara Pereira           | Ciência de Dados: Análise e Visualização      |
| Sra. Alícia Nogueira       | Bárbara Pereira           | Ciência de Dados: Análise e Visualização      |
| Sophia Silveira            | Bárbara Pereira           | Ciência de Dados: Análise e Visualização      |
| João Felipe Cardoso        | Bárbara Pereira           | Ciência de Dados: Análise e Visualização      |

## 6-Selecione os cursos oferecidos em um determinado turno, considerando o nome do curso, a carga horária e os dias da semana nos quais as aulas ocorrem
```mysql
-- Consulta para obter os cursos oferecidos em um determinado turno
SELECT 
    curso.nome_curso AS NomeCurso,
    curso.carga_horaria_curso AS CargaHoraria,
    turma.dias AS DiasDaSemana
FROM 
    turno
JOIN curso ON turno.id_curso = curso.id_curso
JOIN turma ON turno.id_turma = turma.id_turma
WHERE 
    turno.id_turno = 1;
```
**Resultado**
| Nome do Curso                                       | Carga Horária | Dias da Semana                                        |
|-----------------------------------------------------|---------------|-------------------------------------------------------|
| Introdução à Inteligência Artificial                 | 192           | ['Quarta-feira', 'Sexta-feira', 'Terça-feira', 'Segunda-feira'] |
| Marketing Digital: Estratégias para o Sucesso Online | 142           | ['Quarta-feira', 'Sexta-feira', 'Terça-feira']        |
| Psicologia Positiva: Bem-estar e Felicidade          | 178           | ['Sábado', 'Quarta-feira', 'Terça-feira']             |
