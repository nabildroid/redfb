import 'dart:convert';
import 'dart:math';

import 'package:redfb/models/post.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class ILocalStore {
  Future<void> remove(String postId);
  Future<void> save(List<Post> posts);
  Future<Post?> random();
  Future<List<Post>> getPosts();
}

class LocalStore implements ILocalStore {
  @override
  Future<Post?> random() async {
    final posts = await getPosts();
    if (posts.isNotEmpty) {
      final r = Random().nextInt(posts.length);
      final post = posts[r];
      if (DateTime.now().day <= post.date.day) return post;
    }
  }

  @override
  Future<void> remove(String postId) async {
    final posts = await getPosts();

    posts.removeWhere((element) => element.id == postId);
    await save(posts);
  }

  @override
  Future<bool> save(List<Post> posts) async {
    final string = jsonEncode(posts.map((e) => e.toJson()).toList());

    final instance = await SharedPreferences.getInstance();
    return await instance.setString("posts", string);
  }

  @override
  Future<List<Post>> getPosts() async {
    final instance = await SharedPreferences.getInstance();
    final string = instance.getString("posts");
    if (string != null) {
      final items = jsonDecode(string);
      final posts =
          items.map<Post>((e) => Post.fromJson(e)).toList() as List<Post>;
      return posts;
    }
    return [];
  }
}
