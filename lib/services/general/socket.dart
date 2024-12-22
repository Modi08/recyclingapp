// ignore_for_file: avoid_print

import 'dart:convert';
import 'package:web_socket_channel/web_socket_channel.dart';

class Cords {
  final double lat;
  final double lon;

  Cords(this.lat, this.lon);
}

WebSocketChannel connectToWebsocket(String paramsApiUrl) {
  print("Connected to WebSocket");
  final socket = WebSocketChannel.connect(Uri.parse(paramsApiUrl));
  return socket;
}

void listendMsg(WebSocketChannel socket, Function refreshPage) {
  socket.stream.listen(
    (data) {
      try {
        final parsedData = jsonDecode(data);
        print("Message received: $parsedData");

        if (parsedData.containsKey("data")) {
          final res = parsedData["data"];

          if (res.containsKey("statusCode")) {
            processMsg(res["statusCode"], res, socket, refreshPage);
          } else if (res.containsKey("users")) {
            print("Received users: ${res['users']}");
            refreshPage(res["users"]);
          } else {
            print("Unhandled data structure: $res");
          }
        } else {
          print("Message does not contain 'data': $parsedData");
        }
      } catch (e) {
        print("Error parsing WebSocket message: $e");
      }
    },
    onError: (error) {
      print("WebSocket error: $error");
    },
    onDone: () {
      print("WebSocket connection closed");
    },
  );
}

void processMsg(int statusCode, Map<String, dynamic> data,
    WebSocketChannel socket, Function refreshPage) {
  print("Processing WebSocket message with statusCode: $statusCode");
  switch (statusCode) {
    case 100:
      print("Message is empty");
      break;
    case 200:
      print("Success: ${data["message"]}");
      refreshPage(); // Trigger UI refresh
      break;
    default:
      print("Unhandled statusCode: $statusCode with data: $data");
      break;
  }
}
