class UnsubscribedHood {
  final int id;
  final String title;
  final String image;
  final String author;
  final String rate;
  final int principal;
  final DateTime date;
  final int? comment;
  final String description;

  UnsubscribedHood(
      {required this.id,
      required this.title,
      required this.date,
      required this.rate,
      required this.principal,
      this.comment,
      required this.image,
      required this.author,
      required this.description});

  factory UnsubscribedHood.fromJson(Map<String, dynamic> map) {
    return UnsubscribedHood(
        id: map['id'],
        date: DateTime.parse(map['created_at']),
        rate: map['rate'],
        principal: map['principal'],
        comment: map['comment'],
        title: map['title'],
        image: map['image'],
        author: map['author'],
        description: map['description']);
  }
}

class HoodModel {
  final int id;
  final int authorID;
  final String author;
  final String name;
  final String description;
  final String image;
  final DateTime date;

  HoodModel(
      {required this.id,
      required this.authorID,
      required this.author,
      required this.name,
      required this.description,
      required this.image,
      required this.date});

  factory HoodModel.fromJson(Map<String, dynamic> map) {
    return HoodModel(
        id: map['id'],
        authorID: map['principal'],
        author: map['author'],
        name: map['title'],
        description: map['description'],
        image: map['image'],
        date: DateTime.parse(map['date']));
  }
}

class SubscribedHood {
  final int id;
  final String title;
  final String author;
  final int likes;
  final int disLike;
  final int comment;
  final int principal;
  final String describtion;
  final String image;
  final DateTime date;
  final int fileID;
  final String fileLink;

  SubscribedHood(
      {required this.id,
      required this.title,
      required this.describtion,
      required this.likes,
      required this.disLike,
      required this.comment,
      required this.principal,
      required this.image,
      required this.author,
      required this.date,
      required this.fileID,
      required this.fileLink});

  factory SubscribedHood.fromJson(Map<String, dynamic> map) {
    return SubscribedHood(
        id: map['id'],
        title: map['title'],
        disLike: map['dislikes'],
        likes: map['likes'],
        principal: map['principal'],
        comment: map['comment'],
        describtion: map['description'],
        image: map['image'],
        author: map['author'],
        date: DateTime.parse( map['date']),
        fileID: map['attachment_id'],
        fileLink: map['fileLink']);
  }
}

class Comment {
  final String username;
  final String comment;
  final String avatar;
  final DateTime date;
  final int id;

  Comment(
      {required this.avatar,
      required this.date,
      required this.id,
      required this.username,
      required this.comment});

  factory Comment.fromJson(Map<String, dynamic> map) {
    return Comment(
        avatar: map['avatar'],
        id: map['id'],
        date: DateTime.parse(map['created_at']),
        username: map['username'],
        comment: map['message']);
  }
}

class CommentList {
  final int id;
  final String username;
  final String comment;
  final String avatar;
  final DateTime date;
  final List<Comment>? subComment;

  CommentList(
      {required this.id,
      required this.avatar,
      required this.date,
      this.subComment,
      required this.username,
      required this.comment});
}
