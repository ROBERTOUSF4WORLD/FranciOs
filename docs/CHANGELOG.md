# FranciOS

# CHANGELOG.md

Todos os lançamentos importantes deste projeto serão documentados neste arquivo.

Este documento segue os princípios do **Keep a Changelog** e do **Semantic Versioning (SemVer)**.

---

# Versionamento

Formato utilizado.

```
MAJOR.MINOR.PATCH

Exemplo.

1.0.0
1.1.0
1.2.3
2.0.0
```

Onde.

- **MAJOR** → mudanças incompatíveis.
- **MINOR** → novas funcionalidades compatíveis.
- **PATCH** → correções e melhorias.

---

# Tipos de Alterações

As mudanças são organizadas nas seguintes categorias.

- Added
- Changed
- Deprecated
- Removed
- Fixed
- Security

---

# [1.1.0] - Em Desenvolvimento

## Added

### Aplicativo Flutter

- Fluxo de autenticacao: telas de Login e Cadastro (Firebase Auth).
- Dashboard inicial com Life Score e energias lidos em tempo real do Firestore.
- Tela de Perfil com edicao do nome de exibicao.
- Tela de registro de evento de vida (Event Engine UI).
- Tela de historico de eventos.
- Grafico de evolucao do Life Score no Dashboard (fl_chart).

### Backend (Cloud Functions)

- Trigger onUserCreated: cria o documento inicial do usuario.
- Funcao registerLifeEvent: registra eventos e aciona o Life Engine.
- Life Engine deterministico: calcula Life Score, seis energias e tres indices.
- Snapshot da serie historica em users/{uid}/lifeScoreHistory a cada recalculo.

### Testes

- Testes unitarios do Life Engine (Jest).
- Teste unitario do contrato de tipos de evento (Flutter).

### Documentacao

- Anexo tecnico em BancoDeDados.md com o esquema real do Firestore.

## Changed

- firebase/firestore.rules: subcolecoes do usuario passam a ser listadas
  explicitamente (events, modules, lifeScoreHistory) em vez de um wildcard.

## Security

- users/{uid}/lifeScoreHistory: escrita restrita ao backend (Admin SDK),
  impedindo que o cliente falsifique a evolucao do proprio Life Score.

# [1.0.0] - Em Desenvolvimento

## Added

### Fundação do Projeto

- Estrutura inicial do repositório.
- Organização da documentação.
- Arquitetura modular.
- Definição dos Engines.

---

### Documentação

Criados os documentos oficiais.

- README.md
- Visao.md
- Manifesto.md
- Arquitetura.md
- BancoDeDados.md
- API.md
- IA.md
- Roadmap.md
- UX.md
- RegrasDeNegocio.md
- PrivacyArchitecture.md
- SecurityArchitecture.md
- ADR.md
- DigitalTwin.md
- EventEngine.md
- MemoryEngine.md
- PredictionEngine.md
- Gamification.md

---

### Arquitetura Cognitiva

Definida a arquitetura baseada em Engines.

- Governance Engine
- Event Engine
- Memory Engine
- Knowledge Engine
- Reasoning Engine
- Life Engine
- Prediction Engine
- Decision Engine
- Cognitive Engine
- Wisdom Engine
- Trust Engine
- Evolution Engine
- AI Orchestration Engine

---

### Inteligência Artificial

- Arquitetura Multi-Model.
- Suporte para IA Local.
- Suporte para IA em Nuvem.
- AI Gateway.
- Conselho de Especialistas.
- Life Mentor.

---

### Digital Twin

Implementada a especificação oficial.

- Simulações.
- Cenários.
- Comparações.
- Planejamento.

---

### Gamificação

Especificado o sistema.

- Life XP.
- Franci Points.
- Missões.
- Medalhas.
- Ranking.
- Evolução pessoal.

---

### Segurança

Definidas arquiteturas de.

- Privacy by Design.
- Security by Design.
- Zero Trust.
- Criptografia.
- Auditoria.

---

### Banco de Dados

Arquitetura oficial definida.

- PostgreSQL.
- Redis.
- Banco Vetorial.
- Firebase.
- Storage.

---

### APIs

Arquitetura oficial criada.

- REST.
- GraphQL.
- WebSocket.
- API Gateway.

---

### UX

Criada arquitetura oficial de experiência.

- Dashboard.
- Life Mentor.
- Navegação.
- Acessibilidade.
- Personalização.

---

## Changed

Nenhuma alteração registrada.

---

## Deprecated

Nenhuma funcionalidade descontinuada.

---

## Removed

Nenhuma funcionalidade removida.

---

## Fixed

Nenhuma correção registrada.

---

## Security

Implementados os princípios.

- Privacy by Design.
- Security by Design.
- Zero Trust.
- Least Privilege.
- Auditoria.
- Criptografia.

---

# Próximas Versões

## 1.1.0

Planejado.

- Flutter App.
- Backend.
- Firebase.
- Login.
- Cadastro.
- Dashboard inicial.

---

## 1.2.0

Planejado.

- Event Engine.
- Memory Engine.
- Knowledge Engine.

---

## 1.3.0

Planejado.

- Life Engine.
- Prediction Engine.
- Dashboard Evolutivo.

---

## 1.4.0

Planejado.

- Life Mentor.
- Chat IA.
- Missões Inteligentes.

---

## 1.5.0

Planejado.

- Digital Twin.
- Simulações.
- Cenários.

---

## 2.0.0

Planejado.

- Marketplace.
- Plugins.
- APIs Públicas.
- SDK Oficial.

---

# Convenções

Todo lançamento deverá atualizar este arquivo.

As alterações deverão ser registradas antes da publicação da nova versão.

Nenhuma mudança relevante deverá ocorrer sem atualização do CHANGELOG.

---

# Histórico

Este documento representa o histórico oficial da evolução do FranciOS.

Seu objetivo é manter transparência, rastreabilidade e facilitar o acompanhamento da evolução da plataforma por desenvolvedores, colaboradores e usuários.

---

## Declaração Final

> **"Cada versão representa um passo na evolução do FranciOS. O histórico preserva não apenas o que mudou, mas também a jornada de construção da plataforma."**

---

**Documento:** CHANGELOG.md

**Versão:** 1.0

**Projeto:** FranciOS

**Autor:** Roberto Martins Paz

**Status:** Documento Oficial
