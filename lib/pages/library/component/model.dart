class PDFModel {
  int? id;
  String title;
  String author;
  String description;
  String imagePath;
  String pdfPath;
  int libraryId;

  PDFModel({
    required this.imagePath,
     this.id,
    required this.libraryId,
    required this.title,
    required this.author,
    required this.description,
    required this.pdfPath,
  });
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'library_id': libraryId,
      'author': author,
      'description': description,
      'pdfPath': pdfPath,
      'imagePath': imagePath,
    };
  }

  static PDFModel fromMap(Map<String, dynamic> map) {
    return PDFModel(
      id: map['id'],
      title: map['title'],
      libraryId: map['library_id'],
      author: map['author'],
      description: map['description'],
      pdfPath: map['pdfPath'],
      imagePath: map['imagePath'],
    );
  }

  PDFModel copyWith({int? id}) {
    return PDFModel(
      id: id,
      title: title,
      libraryId: libraryId,
      author: author,
      description: description,
      pdfPath: pdfPath,
      imagePath: imagePath,
    );
  }
}




class LibraryModel {
  final int id;
  final String title;
  final String author;

  final String description;
  final String image;
  final int fileID;
  final String fileLink;

  LibraryModel(
      {required this.id,
      required this.title,
      required this.description,
      required this.image,
      required this.author,
      required this.fileID,
      required this.fileLink});

  factory LibraryModel.fromJson(Map<String, dynamic> map) {
    return LibraryModel(
        id: map['id'],
        title: map['title'],
        description: map['description'],
        image: map['image'],
        author: map['author'],
        fileID: map['attachment_id'],
        fileLink: map['attachment']);
  }
}
