import 'dart:convert';
import 'dart:io';

ServerSocket server;
List<ChatClient> clients = [];

void main() {
  ServerSocket.bind(InternetAddress.anyIPv4, 3000)
    .then((ServerSocket socket) {
       server = socket;
       server.listen((client) {
         handleConnection(client);
       });
    });
}

void handleConnection(Socket client){
  print('Connessione da'
    '${client.remoteAddress.address}:${client.remotePort}');

  clients.add(ChatClient(client));

  client.write("Benvenuti alla chatroom! "
    "Sono presenti altri -${clients.length - 1} -utenti");
}

void removeClient(ChatClient client){
  clients.remove(client);
}

void distributeMessage(ChatClient client, String message){
  for (ChatClient c in clients) {
    if (c != client){
      c.write(message+"-"+"${clients.length-1}");
    }
  }
}

class ChatClient {
  Socket _socket;
  String get _address => _socket.remoteAddress.address;
  int get _port => _socket.remotePort;
  
  ChatClient(Socket s){
    _socket = s;
    _socket.listen(messageHandler,
        onError: errorHandler,
        onDone: finishedHandler);
  }

  void messageHandler(data){
    String message =  utf8.decode(data);
    distributeMessage(this, '$message');
  }

  void errorHandler(error){
    print('${_address}:${_port} Error: $error');
    removeClient(this);
    _socket.close();
  }

  void finishedHandler() {
    print('${_address}:${_port} Disconnected');
    removeClient(this);
    print(clients);
    _socket.close();
  }

  void write(String message){
    _socket.write(message);
  }
}