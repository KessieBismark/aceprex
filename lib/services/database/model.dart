import 'dart:typed_data';

class User {
  final int? id;
  final String username;
  final Uint8List? profilePictureBytes; // Store image data as Uint8List

  User({this.id, required this.username, this.profilePictureBytes});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'username': username,
      'profilePictureBytes': profilePictureBytes,
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'],
      username: map['username'],
      profilePictureBytes: map['profilePictureBytes'],
    );
  }
}

class LocalChatMessage {
  final int? id;
  final int senderId;
  final int receiverId;
  final String? text;
  final Uint8List? attachmentBytes; // Store image data as Uint8List
  final DateTime timestamp;

  LocalChatMessage({
    this.id,
    required this.senderId,
    required this.receiverId,
    this.text,
    this.attachmentBytes,
    required this.timestamp,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'senderId': senderId,
      'receiverId': receiverId,
      'text': text ?? '',
      'attachmentBytes': attachmentBytes,
      'timestamp': timestamp.toIso8601String(),
    };
  }

  factory LocalChatMessage.fromMap(Map<String, dynamic> map) {
    return LocalChatMessage(
      id: map['id'],
      senderId: map['senderId'],
      receiverId: map['receiverId'],
      text: map['text'],
      attachmentBytes: map['attachmentBytes'],
      timestamp: DateTime.parse(map['timestamp']),
    );
  }
}
