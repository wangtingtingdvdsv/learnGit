const express = require('express');
const WebSocket = require('ws');
const http = require('http');

const app = express();

app.get('/', function (req, res) {
  res.sendfile('./index.html');
});

const server = http.createServer(app);
const wss = new WebSocket.Server({ server });

wss.on('connection', function connection(ws, req) {
  ws.on('message', function incoming(message) {
    ws.send('received: ' + message + '(From Server)');
  });

  ws.send('Hello Client');
});

server.listen(8080, function listening() {
  console.log('Listening on %d', server.address().port);
});