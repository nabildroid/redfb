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

  factory Post.fromJson(Map<String, dynamic> e) {
    return Post(
      date: DateTime.parse(e["date"]),
      id: e["id"],
      source: e["source"],
      content: Content(
        origin: e["content"]["origin"],
        generatedTranslation: e["content"]["generatedTranslation"],
        image: e["content"]?["image"],
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "source": source,
      "date": date.toString(),
      "content": {
        "origin": content.origin,
        "generatedTranslation": content.generatedTranslation,
        "image": content.image
      }
    };
  }
}
