import 'dart:convert';

import 'package:http/http.dart' as Http;
import 'package:redfb/models/post.dart';

abstract class IServer {
  Future<void> move(String id, String translation);

  Future<List<Post>> getQueue();
}

class Server implements IServer {
  static const baseURL = "https://reffb.herokuapp.com";

  Uri _api(String endpoint) {
    return Uri.parse(Server.baseURL + "/" + endpoint);
  }

  @override
  Future<List<Post>> getQueue() async {
    final response = await Http.get(_api("queue"));
    final data = response.body;
    final items = jsonDecode(data);
    final posts =
        items.map<Post>((e) => Post.fromJson(e)).toList() as List<Post>;

    return posts;
  }

  @override
  Future<void> move(String id, String translation) async {
    final body = jsonEncode({"id": id, "translation": translation});

    await Http.post(_api("move"),
        body: body, headers: {"content-type": "application/json"});
  }
}
