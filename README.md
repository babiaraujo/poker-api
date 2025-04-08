# Poker API - Backend em Ruby on Rails

Este é o backend de uma aplicação de Poker. A API gerencia salas, jogadores, fases do jogo, ações, e define o vencedor ao final da partida. Tudo isso com persistência em PostgreSQL e comunicação em tempo real via WebSockets (ActionCable).

---

## Tecnologias Utilizadas

- **Ruby 3.2.2**
- **Rails 8.0.2**
- **PostgreSQL**
- **ActiveRecord**
- **ActionCable (WebSocket)**
- **Minitest**
- **Docker & Docker Compose** (opcional para execução isolada)

---

## Execução Local

### Pré-requisitos

- Ruby 3.2.2
- PostgreSQL
- Bundler

### Passos:

```bash
git clone https://github.com/babiaraujo/poker-api.git
cd poker_api

bundle install
rails db:create db:migrate
bin/rails s
```

---

## Execução com Docker

### Pré-requisitos

- Docker
- Docker Compose

### Comandos:

```bash
docker-compose up --build
```

> O Rails ficará disponível em `http://localhost:3000`

---

## WebSockets (ActionCable)

Usado para atualizar em tempo real:

- Ações dos jogadores
- Mudanças nas fases do jogo
- Atualização das cartas comunitárias

**Endpoint WebSocket:**  
```
ws://localhost:3000/cable
```

**Canal:** `RoomChannel`  
**Inscrição:**
```json
{ "channel": "RoomChannel", "room_id": 1 }
```

---

## MER
![image](https://github.com/user-attachments/assets/58c6b64a-920b-4072-a927-9e3f74aa89bf)

## Funcionalidades

### Salas

- Criar, listar, acessar e iniciar jogos (`/rooms`)
- Jogadores podem entrar e sair (`/rooms/:id/join`, `/leave`)

### Jogadores

- Criar jogador com nome e fichas
- Ações: `call`, `raise`, `fold`

### Jogo

- Fases: `pre_flop` → `flop` → `turn` → `river`
- Cartas comunitárias são reveladas a cada fase
- Ações dos jogadores afetam pot e fichas
- Finalização do jogo com avaliação das mãos

---

## Regras Implementadas

- Ações só permitidas para jogadores da sala
- Validação do fluxo de fases
- Verificação de fichas suficientes
- Avaliação das mãos (high card → royal flush)

---

## Testes Automatizados

### Controllers

- `test/controllers/games_controller_test.rb`
  - Testa ações válidas e inválidas
  - Validações de chips, fases e participantes
  - Simulação de partida completa

### Serviços

- `test/services/hand_evaluator_test.rb`
  - Cobre todas as combinações possíveis de mãos

### Rodar testes:

```bash
bin/rails test
```

---

## Estrutura

```
app/
├── controllers/
├── channels/
├── models/
├── services/
test/
├── controllers/
├── services/
```

---

## Observações Finais

- Projeto pronto para testes locais e com Docker
- Código documentado, modular e testado
