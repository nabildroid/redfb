import 'package:redfb/models/post.dart';

abstract class ILocalStore {
  Future<void> remove(String postId);
  Future<void> save(List<Post> posts);
  Future<Post?> random();
}

class LocalStore implements ILocalStore {
  @override
  Future<Post?> random() {
    return Future.value(
      Post(
        id: "dsdsdsd",
        date: DateTime.now(),
        source: "HelloWorld",
        content: Content(
            origin:
                "hello world this is the original text that should be translated via this app",
            generatedTranslation: "اللغة العربية هايلة مكاش خير منها "),
      ),
    );
  }

  @override
  Future<void> remove(String postId) {
    // TODO: implement remove
    throw UnimplementedError();
  }

  @override
  Future<void> save(List<Post> posts) {
    // TODO: implement save
    throw UnimplementedError();
  }
}
