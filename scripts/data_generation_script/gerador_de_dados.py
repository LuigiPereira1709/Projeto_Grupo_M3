#Import das bibliotecas utilizadas
from faker import Faker
import pandas as pd
from datetime import timedelta
import random

class Gerador:
    def __init__(self):
        # Inicializa o gerador de dados fictícios e carrega listas de cursos, formações e especialidades a partir de arquivos
        with open('./scripts/files/cursos.txt', 'r', encoding='utf-8') as arquivo:
            self.lista_cursos = [linha.strip() for linha in arquivo.readlines()]
        with open('./scripts/files/formacoes.txt', 'r', encoding='utf-8') as arquivo:
            self.lista_formacoes = [linha.strip() for linha in arquivo.readlines()]
        with open('./scripts/files/especialidades.txt', 'r', encoding='utf-8') as arquivo:
            self.lista_especialidades = [linha.strip() for linha in arquivo.readlines()]
        self.falso = Faker('pt_BR')  # Instancia o Faker para gerar dados fictícios 
        self.quantidade_loop = random.randrange  # Atalho para a função random.randrange

    def gerar_curso(self):
        # Gera dados fictícios para cursos
        dados = []
        for _ in range(self.quantidade_loop(50, 250)):
            data_inicio = self.falso.date_this_decade()
            data_termino = data_inicio + timedelta(days=self.falso.random_int(min=30, max=730))
            dados.append({
                'nome': random.choice(self.lista_cursos),
                'carga_horaria': self.falso.random_int(min=20, max=300),
                'data_inicio': data_inicio,
                'data_termino': data_termino
            })
        return pd.DataFrame(dados)

    def gerar_aluno(self):
        # Gera dados fictícios para alunos
        dados = []
        for _ in range(self.quantidade_loop(50, 250)):
            dados.append({
                'nome': self.falso.name(),
                'cpf': self.falso.cpf(),
                'nascimento': self.falso.date_of_birth(tzinfo=None, minimum_age=18, maximum_age=60),
                'email': self.falso.safe_email(),
                'telefone': self.falso.phone_number()
            })
        return pd.DataFrame(dados)

    def gerar_professor(self):
        # Gera dados fictícios para professores
        dados = []
        dados_alunos = pd.read_csv('./data/data_aluno.csv').to_dict('records')
        tamanho_alunos = random.randrange(1, len(dados_alunos) // 2 + 1) # Divide pela metade os alunos carregados

        # Preenche parte dos professores utilizando dados correspondentes a alunos existentes
        for _ in range(tamanho_alunos):
            aluno_correspondente = random.choice(dados_alunos)
            dados_alunos = [aluno for aluno in dados_alunos if aluno != aluno_correspondente]
            dados.append({
                'nome': aluno_correspondente['nome'],
                'cpf': aluno_correspondente['cpf'],
                'formacao': random.choice(self.lista_formacoes),
                'especialidade': random.choice(self.lista_especialidades),
                'email': aluno_correspondente['email'],
                'telefone': aluno_correspondente['telefone']
            })

        # Gera dados fictícios de professores sem a utilização do csv "data_aluno" 
        for _ in range(self.quantidade_loop(50, 250) - tamanho_alunos): 
            dados.append({
                'nome': self.falso.name(),
                'cpf': self.falso.cpf(),
                'formacao': random.choice(self.lista_formacoes),
                'especialidade': random.choice(self.lista_especialidades),
                'email': self.falso.email(),
                'telefone': self.falso.phone_number()
            })

        return pd.DataFrame(dados)

    def gerar_turma(self):
        # Gera dias aleatórios da semana para uma turma a cada loop
        dados = []
        dias = ['Segunda-feira', 'Terça-feira', 'Quarta-feira', 'Sexta-feira', 'Sábado']
        for _ in range(self.quantidade_loop(50, 250)):
            dias_aleatorios = random.sample(dias, k=random.randint(1, len(dias)))
            dados.append({
                'dias': dias_aleatorios
            })

        return pd.DataFrame(dados, columns=['dias'])

    def gerar_aluno_turma(self):
        # Gera dados fictícios para status e presença
        dados = []
        status = ['ativo', 'desativado', 'evasão']
        for _ in range(self.quantidade_loop(50, 250)):
            escolha_aleatoria = random.choice(status)

            # Define a porcentagem de presença com base no status escolhido
            if escolha_aleatoria == 'evasão' or escolha_aleatoria == 'desativado':
                presenca = round(random.uniform(0.0, 0.69), 2)
            else:
                presenca = round(random.uniform(0.7, 0.99), 2)

            dados.append({
                'status': escolha_aleatoria,
                'presenca': presenca
            })
        return pd.DataFrame(dados)

        # Gera senhas fictícias para usuarios. Além disso agrupa os cpf's dos alunos e professores para adicionar ao csv
    def gerar_usuario(self):
        # Obtém os CPFs dos alunos e professores
        dados_professor = pd.read_csv('./data/data_professor.csv')['cpf'].to_list()
        dados_aluno = pd.read_csv('./data/data_aluno.csv')['cpf'].to_list()

        # Combina as listas e remove duplicatas
        todos_cpfs = list(set(dados_aluno + dados_professor))

        dados = []
        for cpf in todos_cpfs:
            dados.append({
                'cpf': cpf,
                'senha': self.falso.password()
            })

        return pd.DataFrame(dados)

    def gerar_disciplinas(self):
        # Gera dados fictícios para disciplinas, incluindo carga horária e datas de início e término
        dados = []
        for _ in range(self.quantidade_loop(50, 250)):
            data_inicio = self.falso.date_this_decade()
            data_termino = data_inicio + timedelta(days=self.falso.random_int(min=30, max=120))
            dados.append({
                'carga_horaria': self.falso.random_int(min=10, max=60),
                'data_inicio': data_inicio,
                'data_termino': data_termino
            })
        return pd.DataFrame(dados)

# Instância o gerador
gerador = Gerador()

# Prefixo dos arquivos csv
prefixo = 'data'

# Gera e salva dados fictícios em arquivos CSV
curso = gerador.gerar_curso()
curso.to_csv(f'./data/{prefixo}_curso.csv', index=False)

alunos = gerador.gerar_aluno()
alunos.to_csv(f'./data/{prefixo}_aluno.csv', index=False)

professores = gerador.gerar_professor()
professores.to_csv(f'./data/{prefixo}_professor.csv', index=False)

disciplina = gerador.gerar_disciplinas()
disciplina.to_csv(f'./data/{prefixo}_disciplina.csv', index=False)

turmas = gerador.gerar_turma()
turmas.to_csv(f'./data/{prefixo}_turma.csv', index=False)

usuarios = gerador.gerar_usuario()
usuarios.to_csv(f'./data/{prefixo}_usuario.csv', index=False)

aluno_turma = gerador.gerar_aluno_turma()
aluno_turma.to_csv(f'./data/{prefixo}_aluno_turma.csv', index=False)
