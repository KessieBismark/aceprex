class TechModel {
  final int id;
  final String writer;
  final String title;
  final String slug;
  final String content;
  final String image;
  final DateTime date;

  TechModel({
    required this.id,
    required this.writer,
    required this.title,
    required this.slug,
    required this.content,
    required this.image,
    required this.date,
  });

  factory TechModel.fromJson(Map<String, dynamic> map) {
    return TechModel(
      id: map['id'],
      writer: map['writer'],
      title: map['title'],
      slug: map['slug'],
      content: map['content'],
      image: map['image'],
      date: DateTime.parse(map['created_at']),
    );
  }
}
