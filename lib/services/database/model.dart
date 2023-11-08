class User {
  final int? id;
  final String username;
  final String? profilePicture;
  final int online;
  final String? lastMessage;
  User({
    this.id,
    this.lastMessage,
    this.profilePicture,
    required this.online,
    required this.username,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'username': username,
      'profilePicture': profilePicture ?? '',
      'online': online,
      // 'lastMessage': lastMessage
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
        id: map['id'],
        online: map['online'],
        username: map['username'],
        profilePicture: map['profilePicture'] ?? '');
    // lastMessage: map['lastMessage'] ?? '');
  }
}

class LocalChatMessage {
  final int? id;
  final int senderId;
  final int receiverId;
  // final String name;
  final String? text;
  final String? attachment; // Store image data as Uint8List
  final DateTime timestamp;
  final int seen;
  final int userID;
  final int? sync;

  LocalChatMessage({
    this.id,
    // required this.name,
    required this.senderId,
    required this.receiverId,
    this.text,
    this.attachment,
    this.sync,
    required this.seen,
    required this.timestamp,
    required this.userID,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'senderId': senderId,
      //  'name': name,
      'receiverId': receiverId,
      'text': text ?? '',
      'attachment': attachment ?? '',
      'timestamp': timestamp.toIso8601String(),
      'seen': seen,
      'sync': sync,
      'userID': userID
    };
  }

  factory LocalChatMessage.fromMap(Map<String, dynamic> map) {
    return LocalChatMessage(
      id: map['id'],
      senderId: map['senderId'],
      receiverId: map['receiverId'],
      text: map['text'] ?? '',
      attachment: map['attachment'] ?? '',
      timestamp: DateTime.parse(map['timestamp']),
      seen: map['seen'] ?? 0,
      sync: map['sync'] ?? 0,
      userID: map['userID'],
      //  name: map['name']
    );
  }
}

class OpenedPdf {
  int? id;
  int pdfInfoId;
  int lastPageRead;

  OpenedPdf({
    this.id,
    required this.pdfInfoId,
    required this.lastPageRead,
  });

  Map<String, dynamic> toMap() {
    return {
      'pdfInfoId': pdfInfoId,
      'lastPageRead': lastPageRead,
    };
  }
}

class ChatHead {
  final int id;
  final String name;
  final String profile;
  final int isOnline;
  final int? from;
  final int? to;
  final String? lastMessage;
  final String? attachment;
  final DateTime timeStamp;
  final int seen;
  final int? unSeenCount;
  const ChatHead(
      {required this.id,
      required this.name,
      required this.profile,
      required this.isOnline,
      required this.from,
      required this.to,
      this.lastMessage,
      this.attachment,
      required this.timeStamp,
      this.unSeenCount,
      required this.seen});

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "name": name,
      "profile": profile,
      "is_online": isOnline,
      "from": from ?? 0,
      "to": to ?? 0,
      "last_message": lastMessage ?? '',
      "time_stamp": timeStamp.toString(),
      'unseen': unSeenCount,
      'attachment': attachment ?? "",
      'seen': seen,
    };
  }

  factory ChatHead.fromMap(Map<String, dynamic> map) {
    return ChatHead(
      id: map["id"],
      name: map["name"],
      profile: map["profile"],
      isOnline: map["is_online"],
      from: map["from"] ?? 0,
      to: map["to"] ?? 0,
      lastMessage: map['last_message'] ?? '',
      timeStamp: DateTime.parse(map['time_stamp'] ?? DateTime.now()),
      unSeenCount: map['unseen'],
      attachment: map['attachment'] ?? '',
      seen: map['seen'],
    );
  }
}
