class CatModel {
  final int id;
  final String name;

  CatModel({required this.id, required this.name});

  factory CatModel.fromJson(Map<String, dynamic> map) {
    return CatModel(id: map['id'], name: map['name']);
  }
}

class ArticleModel {
  final int id;
  final String writer;
  final String category;
  final String title;
  final String slug;
  final String content;
  final String image;
  final String tag;
  final DateTime date;
  final int views;
  final String? source;

  ArticleModel(
      {required this.id,
      required this.writer,
      required this.category,
      required this.title,
      required this.slug,
      required this.content,
      required this.image,
      required this.tag,
      required this.date,
      this.source,
      required this.views});

  factory ArticleModel.fromJson(Map<String, dynamic> map) {
    return ArticleModel(
        id: map['id'],
        writer: map['writer'],
        category: map['category'],
        title: map['title'],
        slug: map['slug'],
        content: map['content'],
        image: map['image'],
        tag: map['tag'],
        source: map['source'] ?? '',
        date: DateTime.parse(map['created_at']),
        views: map['views']);
  }
}
