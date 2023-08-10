class ChatList {
  final int chatID;
  final int id;
  final String name;
  final int isOnline;
  final int fromID;
  final int toID;
  final String? fromImage;
  final int lastMessageSeen;
  final String? lastMessage;
  final DateTime lastDate;
  final int unRead;

  ChatList(
      {required this.chatID,required this.id,
      required this.name,
      required this.isOnline,
      required this.fromID,
      required this.toID,
      this.fromImage,
      required this.lastMessageSeen,
      this.lastMessage,
      required this.lastDate,
      required this.unRead});

  factory ChatList.fromJson(Map<String, dynamic> map) {
    return ChatList(
      chatID: map['chatID'],
      id: map['id'],
      unRead: map['unread'],
      fromID: map['from_id'],
      toID: map['to_id'],
      name: map['name'],
      isOnline: map['is_online'],
      fromImage: map['avatar'] ?? '',
      lastMessageSeen: map['lastMessageSeen'],
      lastMessage: map['lastMessage'] ?? '',
      lastDate: DateTime.parse(map['lastDate']),
    );
  }
}

class ChatModel {
  final int id;

  final String name;
  final int isOnline;
  final String? fromImage;
  final int lastMessageSeen;
  final String? lastMessage;
  final DateTime lastDate;

  ChatModel({
    required this.id,
    required this.name,
    required this.isOnline,
    this.fromImage,
    required this.lastMessageSeen,
    this.lastMessage,
    required this.lastDate,
  });

  factory ChatModel.fromJson(Map<String, dynamic> map) {
    return ChatModel(
      id: map['id'],
      name: map['name'],
      isOnline: map['is_online'],
      fromImage: map['avatar'] ?? '',
      lastMessageSeen: map['lastMessageSeen'],
      lastMessage: map['lastMessage'] ?? '',
      lastDate: DateTime.parse(map['lastDate']),
    );
  }
}

class ChatMessage {
  final int id;
  final int from;
  final int to;
  final int seen;
  final DateTime date;
  final String? attachment;
  final String? message;

  ChatMessage(
      {required this.id,
      required this.from,
      required this.to,
      required this.seen,
      required this.date,
      this.attachment,
      required this.message});

  factory ChatMessage.fromJson(Map<String, dynamic> map) {
    return ChatMessage(
        id: map['id'],
        from: map['from_id'],
        to: map['to_id'],
        seen: map['seen'],
        date: DateTime.parse(map['created_at']),
        attachment: map['attachment'] ?? '',
        message: map['body'] ?? '');
  }
}

class PeopleModel {
  final int id;
  final String name;
  // final String? bio;
  final String? avatar;
  final int isOnline;
  final String? role;

  PeopleModel(
      {required this.id,
      required this.name,
      // this.bio,
      this.avatar,
      required this.isOnline,
      this.role});

  factory PeopleModel.fromJson(Map<String, dynamic> map) {
    return PeopleModel(
      id: map['id'],
      name: map['name'],
      avatar: map['avatar'] ?? '',
      // bio: map['bio'] ?? '',
      role: map['role'] ?? '',
      isOnline: map['is_online'],
    );
  }
}

class ChatList2 {
  final int fromID;
  final int toID;
  final int seen;
  final int toOnline;
  final int fromOnline;
  final String date;
  final String fromName;
  final String toName;
  final String message;
  final String fromAvatar;
  final String toAvatar;

  ChatList2({
    required this.fromID,
    required this.toID,
    required this.seen,
    required this.toOnline,
    required this.fromOnline,
    required this.date,
    required this.fromName,
    required this.toName,
    required this.message,
    required this.fromAvatar,
    required this.toAvatar,
  });
  factory ChatList2.fromJson(Map<String, dynamic> map) {
    return ChatList2(
        fromID: map['from_id'],
        toID: map['to_id'],
        seen: map['seen'],
        toOnline: map['toOnline'],
        fromOnline: map['fromOnline'],
        date: map['created_at'],
        fromName: map['fromName'],
        toName: map['toName'],
        message: map['body'],
        fromAvatar: map['fromAvatar'],
        toAvatar: map['toAvatar']);
  }
}
