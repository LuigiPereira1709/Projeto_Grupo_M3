-- Carregamento de dados da tabela curso a partir de um arquivo CSV
LOAD DATA INFILE 'data_curso.csv'
INTO TABLE curso
CHARACTER SET utf8
FIELDS TERMINATED BY ',' 
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(nome_curso, carga_horaria_curso, data_inicio_curso, data_termino_curso);

-- Carregamento de dados da tabela aluno a partir de um arquivo CSV
LOAD DATA INFILE 'data_aluno.csv'
INTO TABLE aluno
CHARACTER SET utf8
FIELDS TERMINATED BY ','
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(nome_aluno, cpf_aluno, nascimento, email_aluno, telefone_aluno);

-- Carregamento de dados da tabela professor a partir de um arquivo CSV
LOAD DATA INFILE 'data_professor.csv'
INTO TABLE professor
CHARACTER SET utf8
FIELDS TERMINATED BY ','
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(nome_professor, cpf_professor, formacao, especialidade, email_professor, telefone_professor);

-- Carregamento de dados da tabela turma a partir de um arquivo CSV
LOAD DATA INFILE 'data_turma.csv'
INTO TABLE turma
CHARACTER SET utf8
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(dias);

-- Carregamento de dados da tabela aluno_turma a partir de um arquivo CSV
LOAD DATA INFILE 'data_aluno_turma.csv'
INTO TABLE aluno_turma
CHARACTER SET utf8
FIELDS TERMINATED BY ','
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(status, presenca)
SET id_aluno = (SELECT id_aluno FROM aluno ORDER BY RAND() LIMIT 1),
    id_turma = (SELECT id_turma FROM turma ORDER BY RAND() LIMIT 1);

-- Inserção de dados na tabela modulo para cursos
INSERT INTO modulo(id_curso)
SELECT id_curso FROM curso ORDER BY RAND() LIMIT 50;

-- Carregamento de dados da tabela disciplinas a partir de um arquivo CSV
LOAD DATA INFILE 'data_disciplina.csv'
INTO TABLE disciplinas
CHARACTER SET utf8
FIELDS TERMINATED BY ','
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(carga_horaria_disciplina, data_inicio_disciplina, data_termino_disciplina)
SET id_professor = (SELECT id_professor FROM professor ORDER BY RAND() LIMIT 1),
    id_modulo = (SELECT id_modulo FROM modulo ORDER BY RAND() LIMIT 1);

-- Inserção de dados na tabela turno para cursos e turmas
INSERT INTO turno(id_curso, id_turma)
SELECT 
    (SELECT id_curso FROM curso ORDER BY RAND() LIMIT 1) AS id_curso,
    id_turma
FROM turma
ORDER BY RAND()
LIMIT 50;

-- Carregamento de dados da tabela usuario a partir de um arquivo CSV
LOAD DATA INFILE 'data_usuario.csv'
INTO TABLE usuario
CHARACTER SET utf8
FIELDS TERMINATED BY ','
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(cpf, senha);

-- Atualização da tabela usuario com os IDs de aluno e professor correspondentes
UPDATE usuario
SET id_aluno = (SELECT id_aluno FROM aluno WHERE aluno.cpf_aluno = usuario.cpf),
    id_professor = (SELECT id_professor FROM professor WHERE professor.cpf_professor = usuario.cpf);

-- Adição de restrições de chave estrangeira na tabela usuario
ALTER TABLE usuario
ADD CONSTRAINT fk_aluno_usuario
FOREIGN KEY (id_aluno) REFERENCES aluno(id_aluno),
ADD CONSTRAINT fk_professor_usuario
FOREIGN KEY (id_professor) REFERENCES professor(id_professor);
