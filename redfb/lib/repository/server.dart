import 'package:http/http.dart';
import 'package:redfb/models/post.dart';

abstract class IServer {
  Future<void> move(String id, String translation);

  Future<List<Post>> getQueue();
}

class Server implements IServer {
  @override
  Future<List<Post>> getQueue() {
    // TODO: implement getQueue
    throw UnimplementedError();
  }

  @override
  Future<void> move(String id, String translation) {
    // TODO: implement move
    throw UnimplementedError();
  }
}
