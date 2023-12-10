USE resilientes;

-- Seleciona a quantidade total de alunos cadastrados no banco de dados
SELECT 'Total de Alunos' AS Categoria, COUNT(id_aluno) AS Valor
FROM aluno;

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

SELECT * FROM evasao_turma;

-- Consulta para verificar quais dias na semana são as aulas dos cursos
SELECT
    curso.nome_curso AS Categoria,
    curso.carga_horaria_curso AS Valor,
    turma.dias
FROM 
    curso
JOIN 
    turno ON curso.id_curso = turno.id_curso
JOIN 
    turma ON turno.id_turma = turma.id_turma;