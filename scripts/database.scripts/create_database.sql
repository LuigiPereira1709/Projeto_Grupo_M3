-- Criação do banco de dados chamado 'resilientes'
CREATE DATABASE resilientes;
USE resilientes;

-- Criação da tabela para cursos
CREATE TABLE curso(
    id_curso INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
    nome_curso VARCHAR(50) NOT NULL,
    carga_horaria_curso INT(11) NOT NULL,
    data_inicio_curso DATE NOT NULL,
    data_termino_curso DATE NOT NULL
);

-- Criação da tabela para alunos
CREATE TABLE aluno(
    id_aluno INT NOT NULL PRIMARY KEY auto_increment,
    nome_aluno VARCHAR(50) NOT NULL,
    cpf_aluno VARCHAR(14) NOT NULL,
    nascimento DATE NOT NULL,
    email_aluno VARCHAR(50) NOT NULL,
    telefone_aluno VARCHAR(17) NOT NULL
);

-- Criação da tabela para professores
CREATE TABLE professor(
    id_professor INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
    nome_professor VARCHAR(50) NOT NULL,
    cpf_professor VARCHAR(14) NOT NULL,
    formacao VARCHAR(2500) NOT NULL,
    especialidade VARCHAR(250) NOT NULL,
    email_professor VARCHAR(50) NOT NULL,
    telefone_professor VARCHAR(17) NOT NULL
);

-- Criação da tabela para usuários (vinculado a um aluno ou professor)
CREATE TABLE usuario(
    cpf VARCHAR(14) NOT NULL PRIMARY KEY UNIQUE,
    senha VARCHAR(20) NOT NULL,
    id_aluno INT NULL,
    id_professor INT NULL
);

-- Criação da tabela para turmas
CREATE TABLE turma(
    id_turma INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
    dias VARCHAR(250) NOT NULL
);

-- Criação da tabela para relação entre alunos e turmas
CREATE TABLE aluno_turma(
    id_aluno_turma INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
    status VARCHAR(10) NOT NULL,
    presenca FLOAT(15) NOT NULL,
    id_aluno INT NOT NULL,
    id_turma INT NOT NULL
);

-- Criação da tabela para disciplinas
CREATE TABLE disciplinas(
    id_disciplina INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
    id_professor INT NOT NULL,
    carga_horaria_disciplina VARCHAR(25) NOT NULL,
    data_inicio_disciplina DATE NOT NULL,
    data_termino_disciplina INT NOT NULL,
    id_modulo INT NOT NULL
);

-- Criação da tabela para turnos
CREATE TABLE turno(
    id_turno INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
    id_curso INT NOT NULL,
    id_turma INT NOT NULL
);

-- Criação da tabela para módulos
CREATE TABLE modulo(
    id_modulo INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
    id_curso INT NOT NULL
);

-- Criação da tabela para registros de log
CREATE TABLE log(
    id_log INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
    id_aluno INT NOT NULL,
    novo_status VARCHAR(50) NOT NULL,
    antigo_status VARCHAR(50) NOT NULL,
    data_modificacao DATETIME
);

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

-- Adição de restrições de chave estrangeira na tabela aluno_turma
ALTER TABLE aluno_turma 
ADD 
CONSTRAINT fk_aluno_aluno_turma
FOREIGN KEY (id_Aluno) 
REFERENCES aluno(id_Aluno),
ADD 
CONSTRAINT fk_turma_aluno_turma
FOREIGN KEY (id_Turma) 
REFERENCES turma(id_Turma);

-- Adição de restrições de chave estrangeira na tabela disciplinas
ALTER TABLE disciplinas
ADD
CONSTRAINT fk_professor_disciplinas
FOREIGN KEY (id_Professor) 
REFERENCES professor(id_Professor),
ADD 
CONSTRAINT fk_modulo_disciplinas
FOREIGN KEY (id_Modulo) 
REFERENCES modulo(id_Modulo);

-- Adição de restrições de chave estrangeira na tabela turno
ALTER TABLE turno 
ADD
CONSTRAINT fk_curso_turno
FOREIGN KEY (id_Curso) 
REFERENCES curso(id_Curso),
ADD
CONSTRAINT fk_turma_turno
FOREIGN KEY (id_Turma) 
REFERENCES turma(id_Turma);

-- Adição de restrições de chave estrangeira na tabela modulo
ALTER TABLE modulo 
ADD 
CONSTRAINT fk_curso_modulo
FOREIGN KEY (id_Curso) 
REFERENCES curso(id_Curso);
