# FranciOS
# BancoDeDados.md

Versão: 1.0

Status: Documento Oficial

Projeto: FranciOS

Autor: Roberto Martins Paz

---

# Banco de Dados do FranciOS

## Visão Geral

O banco de dados do FranciOS não foi projetado apenas para armazenar informações.

Ele foi desenvolvido para registrar eventos, construir memória, gerar conhecimento e produzir inteligência.

O banco trabalha em conjunto com:

- Event Engine
- Life Engine
- Memory Engine
- Prediction Engine
- Conselho de Especialistas
- Life Mentor

O objetivo é transformar dados em conhecimento útil para apoiar melhores decisões.

---

# Filosofia

Todo dado registrado deverá contribuir para responder uma única pergunta:

> Como podemos ajudar o usuário a evoluir de forma equilibrada?

O banco nunca armazenará informações sem finalidade.

Todo registro deve gerar valor para o usuário.

---

# Princípios

- Event Driven
- Privacy by Design
- Offline First
- Knowledge First
- IA Agnóstica
- Escalabilidade Horizontal
- Criptografia por padrão
- Histórico permanente
- Dados pertencem ao usuário

---

# Arquitetura

```
Usuário

↓

Evento

↓

Event Engine

↓

Banco de Dados

↓

Memory Engine

↓

Knowledge Engine

↓

Life Engine

↓

Prediction Engine

↓

Life Mentor

↓

Dashboard
```

---

# Estrutura Geral

```
users

├── profile
├── events
├── states
├── memory
├── knowledge
├── insights
├── dashboard
├── missions
├── gamification
├── predictions
├── notifications
├── privacy
├── vault
├── devices
├── settings
└── audit
```

---

# Coleção: profile

Armazena informações permanentes.

Campos

- Nome
- Foto
- Data de nascimento
- Sexo
- Altura
- Peso inicial
- Cidade
- País
- Idioma
- Fuso horário
- Profissão
- Estado civil
- Objetivos principais
- Data de cadastro

---

# Coleção: events

O coração do banco.

Todo acontecimento gera um evento.

Tipos de eventos

- Sono
- Alimentação
- Exercício
- Trabalho
- Estudos
- Finanças
- Humor
- Estresse
- Relacionamentos
- Espiritualidade
- Saúde
- Hábitos
- Metas
- Gamificação
- IA
- Sistema

Estrutura

- id
- tipo
- categoria
- data
- horário
- origem
- payload
- localização (opcional)
- dispositivo
- versão

Exemplo

```
Tipo:
Sleep

Data:
2026-07-05

Duração:
7h40

Qualidade:
87%

Origem:
Manual
```

---

# Coleção: states

Representa o estado atual do usuário.

Exemplos

Peso Atual

Life Score

Energia Física

Energia Mental

Energia Emocional

Saldo FP

Nível

Objetivos Ativos

Esses dados são recalculados constantemente.

---

# Coleção: memory

Responsável pela memória histórica.

Armazena padrões como

- melhor horário para estudar
- melhor horário para dormir
- alimentos que aumentam energia
- horários de maior produtividade
- frequência ideal de descanso
- hábitos mais consistentes

---

# Coleção: knowledge

Conhecimento produzido automaticamente pela IA.

Exemplos

"O usuário aprende melhor entre 8h e 10h."

"A caminhada melhora sua produtividade em média 15%."

"A privação de sono reduz seu foco em aproximadamente 20%."

Cada conhecimento possui:

- confiança
- data de criação
- motor responsável
- evidências utilizadas

---

# Coleção: insights

Registra descobertas importantes.

Exemplos

- Evolução da saúde
- Evolução financeira
- Evolução emocional
- Evolução dos estudos
- Mudanças de hábitos

Os insights alimentam o Dashboard e o Life Mentor.

---

# Coleção: dashboard

Resumo atualizado continuamente.

Campos

- Life Score
- Energia Física
- Energia Mental
- Energia Emocional
- Energia Financeira
- Energia Social
- Energia Espiritual
- Índice de Recuperação
- Índice de Consistência
- Índice de Evolução
- Última atualização

---

# Coleção: missions

Missões geradas pela IA.

Tipos

- Diárias
- Semanais
- Mensais
- Especiais

Campos

- título
- objetivo
- progresso
- recompensa
- prazo
- status

---

# Coleção: gamification

Responsável por

- Franci Points
- Life XP
- Medalhas
- Conquistas
- Sequências
- Ranking Pessoal
- Ranking Global
- Clube FranciOS

---

# Coleção: predictions

Armazena previsões produzidas pelo Prediction Engine.

Exemplos

- risco de burnout
- risco financeiro
- quebra de hábitos
- baixa produtividade
- sedentarismo

Campos

- probabilidade
- impacto
- confiança
- data
- justificativa

---

# Coleção: notifications

Notificações inteligentes.

Tipos

- Bom dia
- Boa noite
- Alertas
- Missões
- Conquistas
- Recomendações
- Relatórios

---

# Coleção: privacy

Define as permissões do usuário.

Exemplos

- sincronização
- IA
- compartilhamento
- backup
- localização
- sensores
- integrações

---

# Coleção: vault

FranciVault

Armazena

- documentos
- certificados
- exames
- contratos
- senhas
- chaves
- arquivos pessoais

Tudo protegido por criptografia.

---

# Coleção: devices

Lista todos os dispositivos autorizados.

Campos

- id
- nome
- plataforma
- último acesso
- status

---

# Coleção: settings

Preferências do usuário.

- tema
- idioma
- notificações
- acessibilidade
- backup
- sincronização
- modo soberano

---

# Coleção: audit

Registro completo do sistema.

Toda operação gera auditoria.

Campos

- data
- usuário
- dispositivo
- ação
- módulo
- resultado

---

# Relacionamento entre os Motores

Event Engine

↓

Memory Engine

↓

Knowledge Engine

↓

Life Engine

↓

Prediction Engine

↓

Conselho de Especialistas

↓

Life Mentor

↓

Dashboard

---

# Segurança

Todos os dados seguem os princípios:

- AES-256
- TLS 1.3
- Criptografia ponta a ponta
- UID por usuário
- Backup criptografado
- Auditoria completa
- Controle granular de permissões

Nenhum dado é compartilhado sem autorização.

---

# Sincronização

O banco utiliza sincronização híbrida.

- Banco Local
- Banco em Nuvem
- Sincronização Incremental
- Resolução automática de conflitos
- Offline First

---

# Escalabilidade

Projetado para:

- Milhões de usuários
- IA Local
- IA em Nuvem
- Wearables
- Open Finance
- Google Fit
- Apple Health
- Samsung Health
- Web3 (opcional)

---

# Conformidade

O FranciOS foi projetado para atender:

- LGPD
- GDPR
- Privacy by Design
- Security by Design

---

# Princípio Supremo

O Banco de Dados do FranciOS não existe apenas para armazenar informações.

Ele existe para registrar a história da evolução do usuário, transformando eventos em memória, memória em conhecimento, conhecimento em previsões e previsões em decisões inteligentes.

Todo dado deve gerar valor.

Todo conhecimento deve beneficiar o usuário.

Os dados pertencem sempre ao usuário.

---

Documento Oficial

Banco de Dados do FranciOS

Versão 1.0


---

# Anexo Tecnico: Implementacao Atual (MVP)

Versao: 1.0

Este anexo documenta o mapeamento entre o modelo conceitual descrito
acima e o esquema real ja implementado no Firestore (ver
backend/functions/src/ e firebase/firestore.rules). A medida que os
motores evoluirem, novas colecoes serao promovidas do modelo
conceitual para este anexo.

## Documento: users/{uid}

Criado automaticamente pelo trigger onUserCreated
(backend/functions/src/index.ts) quando uma nova conta e criada.

Campos:

- uid: identificador do usuario (string)
- email: e-mail da conta (string | null)
- nome: nome de exibicao (string | null)
- criadoEm: timestamp do cadastro
- lifeScore: Life Score atual, 0 a 100 (number)
- energias: mapa com as seis energias (fisica, mental, emocional,
  financeira, social, espiritual)
- indices: mapa com evolucao, recuperacao e consistencia
- lifeScoreAtualizadoEm: timestamp do ultimo recalculo
- nivel: nivel do usuario (string, ex: "Explorador")
- franciPoints: pontos de gamificacao (number)

## Subcolecao: users/{uid}/events

Alimentada pelo Event Engine (Cloud Function registerLifeEvent).
Cada documento representa um evento de vida registrado pelo usuario.

Campos:

- tipo: categoria do evento (ex: sono, exercicio, alimentacao,
  trabalho, estudo, financas, humor, estresse, relacionamento,
  habito, espiritualidade)
- valor: intensidade/quantidade opcional (number | null)
- observacao: nota livre opcional (string | null)
- criadoEm: timestamp do registro

Permissoes: leitura e escrita apenas pelo dono (isOwner).

## Subcolecao: users/{uid}/lifeScoreHistory

Serie historica derivada, gravada pelo Life Engine
(backend/functions/src/engines/lifeEngine.ts) a cada recalculo do
Life Score. Alimenta o grafico de evolucao no Dashboard.

Campos:

- lifeScore: Life Score calculado naquele instante (number)
- energias: mapa das seis energias no instante do calculo
- criadoEm: timestamp do snapshot

Permissoes: leitura apenas pelo dono; escrita restrita ao backend
(Cloud Functions via Admin SDK). O cliente NAO pode gravar nesta
subcolecao, para impedir a falsificacao da evolucao do proprio
Life Score. Por isso as regras nao usam um wildcard generico de
subcolecao (ver firebase/firestore.rules).

## Modelo de permissoes (firebase/firestore.rules)

- users/{uid}: leitura e escrita pelo dono.
- users/{uid}/lifeScoreHistory/{id}: leitura pelo dono; escrita
  somente pelo backend.
- users/{uid}/events/{id}: leitura e escrita pelo dono.
- users/{uid}/modules/{id}: leitura e escrita pelo dono.
- memory, predictions: leitura pelo dono; escrita somente pelo backend.
- rankingGlobal: leitura por usuarios autenticados; escrita somente
  pelo backend.
- Qualquer caminho nao listado e negado por padrao.
