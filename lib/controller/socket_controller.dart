import 'package:get/get.dart';
import 'package:schoosch/controller/auth_controller.dart';
import 'package:schoosch/model/person_model.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:web_socket_channel/status.dart' as status;

class SocketController {
  late WebSocketChannel _channel;
  Uri Function(String) baseUriFunc;
  String? _id;

  SocketController(this.baseUriFunc) {
    _channel = WebSocketChannel.connect(baseUriFunc('/chat'));
    _channel.ready.then((_) {
      _channel.stream.listen(_handleMessage);
    });
    Get.find<FAuth>().authStream$.listen(_hadleAuth);
  }

  void _hadleAuth(PersonModel? user) {
    if (user != null) {
      _id = user.id;
      _channel.sink.add('{"type": "login", "id": $_id}');
    } else {
      _channel.sink.add('{"type": "logout", "id": $_id}');
      _id = null;
    }
  }

  void _handleMessage(dynamic message) {
    print(message);
  }

  void send(String message) async {
    _channel.sink.add('{"type": "message", "text": $message}');
  }

  void close() async {
    _channel.sink.add('{"type": "logout", "id": $_id}');
    _channel.sink.close(status.normalClosure, _id);
  }
}
