class Content {
  final String origin;
  final String generatedTranslation;
  final String? image;

  Content({
    required this.origin,
    required this.generatedTranslation,
    this.image,
  });
}

class Post {
  final String id;
  final DateTime date;
  final String source;
  final Content content;

  Post({
    required this.id,
    required this.date,
    required this.source,
    required this.content,
  });
}
