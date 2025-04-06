# ♠️ Poker API - Backend em Ruby on Rails

Este é o backend de uma aplicação de Poker, a API é responsável por gerenciar salas, jogadores, ações, fases do jogo e avaliar as mãos para determinar o vencedor da partida.

---

## Tecnologias

- **Ruby 3.2.2**
- **Rails 8.0.2**
- **PostgreSQL**
- **ActiveRecord**
- **ActionCable (WebSocket)**
- **Minitest**

---

## Instalação

1. **Clone o repositório:**

   ```bash
   git clone https://github.com/seu-usuario/poker_api.git
   cd poker_api
   ```

2. **Instale as dependências:**

   ```bash
   bundle install
   ```

3. **Configure o banco de dados:**

   ```bash
   rails db:create db:migrate
   ```

4. **Execute o servidor:**

   ```bash
   bin/rails s
   ```

---

## WebSockets (ActionCable)

A aplicação utiliza ActionCable para notificar clientes em tempo real sobre:

- Mudança de turnos
- Ações dos jogadores
- Atualização das cartas comunitárias

**Endpoint WebSocket:**  
```
ws://localhost:3000/cable
```

**Canal:** `RoomChannel`  
**Parâmetros de inscrição:**
```json
{ "channel": "RoomChannel", "room_id": 1 }
```

---

## Funcionalidades

### Salas

- Criar, listar, acessar uma sala
- Jogadores podem entrar e sair

### Jogadores

- Criar jogador com nome e quantidade de fichas
- Ações possíveis: `call`, `raise`, `fold`

### Jogo

- Inicia ao chamar o `POST /rooms/:id/start`
- Possui fases (`pre_flop`, `flop`, `turn`, `river`)
- A cada fase, as cartas comunitárias são reveladas
- Jogadores realizam ações (via `POST /games/:id/action`)
- Jogo é finalizado com a avaliação das mãos

---

## Regras implementadas

- Jogador não pode agir se não estiver na sala
- Fases devem ocorrer em ordem
- Jogadores só podem agir se tiverem fichas suficientes
- Avaliação completa das mãos (high card até royal flush)

---

## 🧪 Testes Automatizados

### Controllers

Arquivo: `test/controllers/games_controller_test.rb`

- Testa ações válidas e inválidas
- Validações de chips, fases e autorização
- Simulação completa de jogo e veredito final

### Serviços

Arquivo: `test/services/hand_evaluator_test.rb`

- 10 testes cobrindo todos os tipos de mãos possíveis

### Como rodar:

```bash
bin/rails test
```

---

## Organização

```
app/
├── controllers/
│   └── games_controller.rb
├── channels/
│   └── room_channel.rb
├── models/
│   ├── player.rb
│   ├── room.rb
│   └── game.rb
├── services/
│   └── hand_evaluator.rb
test/
├── controllers/games_controller_test.rb
├── services/hand_evaluator_test.rb
```