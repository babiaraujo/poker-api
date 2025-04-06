class CableTestController < ApplicationController
  def index
    render html: <<-HTML.html_safe
      <!DOCTYPE html>
      <html>
        <head>
          <title>WebSocket Inline</title>
          <meta charset="UTF-8">
        </head>
        <body>
          <h1>WebSocket conectado?</h1>
          <p id="status">tentando conectar...</p>
          <div id="messages" style="margin-top: 20px; font-family: sans-serif;"></div>

          <script>
            document.addEventListener("DOMContentLoaded", function () {
              const statusEl = document.getElementById("status");
              const messagesEl = document.getElementById("messages");

              const socket = new WebSocket("ws://localhost:3000/cable");

              socket.onopen = function () {
                statusEl.textContent = "websocket aberto";
                socket.send(JSON.stringify({
                  command: "subscribe",
                  identifier: JSON.stringify({ channel: "RoomChannel", room_id: 1 })
                }));
              };

              socket.onmessage = function (event) {
                const raw = event.data;
                const parsed = JSON.parse(raw);
                console.log("raw recebido:", raw);
                console.log("parsed:", parsed);

                if (parsed.type) return;

                const content = parsed.message?.message || JSON.stringify(parsed.message);
                const p = document.createElement("p");
                p.textContent = "msg:" + content;
                messagesEl.appendChild(p);
              };

              socket.onerror = function () {
                statusEl.textContent = "erro ao conectar.";
              };

              socket.onclose = function () {
                statusEl.textContent = "conexão fechada.";
              };
            });
          </script>
        </body>
      </html>
    HTML
  end
end
