import 'dart:async';
import 'dart:typed_data';
import 'package:aceprex/services/constants/constant.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import '../../pages/library/component/model.dart';
import 'model.dart';
import 'online_db.dart';
import 'package:image/image.dart' as img;
import 'package:http/http.dart' as http;

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._();
  static Database? _database;

  DatabaseHelper._();

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final documentsDirectory = await getApplicationDocumentsDirectory();
    final path = join(documentsDirectory.path, 'localDB.db');

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future<void> _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE pdfs(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            library_id INTEGER,
            title TEXT,
            author TEXT,
            description TEXT,
            pdfPath TEXT,
            imagePath TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE users(
        id INTEGER PRIMARY KEY,
        username TEXT,
        profilePictureBytes BLOB 
      )
    ''');

    await db.execute('''
      CREATE TABLE chat_messages(
        id INTEGER PRIMARY KEY,
        senderId INTEGER,
        receiverId INTEGER,
        text TEXT NULL,
        attachment BLOB NULL,
        timestamp TEXT,
        sync TINYINT DEFAULT 0
      )
    ''');
  }

  Future<int> insertPDF(PDFModel pdf) async {
    final db = await database;
    return await db.insert('pdfs', pdf.toMap());
  }

  Future<void> insertOrUpdateUser(User user) async {
    final db = await database;

    // Check if the user ID exists in the table.
    final userExists = await isUserIdExists(user.id!);

    // If the user ID does not exist, insert the user.
    if (!userExists) {
      Uint8List compressedProfilePicture =
          await downloadAndCompressImage(user.picture!);

      await db.insert(
        'users',
        {
          'id': user.id,
          'username': user.username,
          'profilePictureBytes': compressedProfilePicture,
        },
      );
    }
  }

  Future<bool> isUserIdExists(int userId) async {
    final db = await database;
    final result =
        await db.rawQuery('SELECT 1 FROM users WHERE id = ?', [userId]);
    return result.isNotEmpty;
  }

  Future<Uint8List> downloadAndCompressImage(String imageUrl) async {
    final response = await http.get(Uri.parse(fileUrl + imageUrl));

    if (response.statusCode == 200) {
      final Uint8List imageData = response.bodyBytes;

      // Use the 'image' package to compress the image (adjust quality as needed).
      final img.Image image = img.decodeImage(imageData)!;
      final Uint8List compressedImage =
          img.encodeJpg(image, quality: 80); // Adjust quality as needed.

      return compressedImage;
    } else {
      throw Exception('Failed to download the image: ${response.statusCode}');
    }
  }

  Future<List<PDFModel>> getPDFs() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('pdfs');
    return List.generate(maps.length, (i) => PDFModel.fromMap(maps[i]));
  }

  Future<int> deletePDF(int id) async {
    final db = await database;
    return await db.delete('pdfs', where: 'id = ?', whereArgs: [id]);
  }

  Future<bool> isLibraryIdExists(int libraryId) async {
    final db = await database;
    final result = await db.rawQuery(
        'SELECT EXISTS(SELECT 1 FROM pdfs WHERE library_id = ? LIMIT 1)',
        [libraryId]);
    return Sqflite.firstIntValue(result) == 1;
  }

  // Users CRUD operations

  Future<int> insertUser(User user) async {
    final db = await database;
    return await db.insert(
      'users',
      {
        'username': user.username,
        'profilePictureBytes': user.profilePictureBytes,
      },
    );
  }

  Future<List<User>> getUsers() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('users');
    return List.generate(maps.length, (i) => User.fromMap(maps[i]));
  }

  Future<int> updateUser(User user) async {
    final db = await database;
    Uint8List? profilePictureBytes = user.profilePictureBytes;

    return await db.update(
      'users',
      {
        'username': user.username,
        'profilePicture': profilePictureBytes,
      },
      where: 'id = ?',
      whereArgs: [user.id],
    );
  }

  Future<int> deleteUser(int id) async {
    final db = await database;
    return await db.delete('users', where: 'id = ?', whereArgs: [id]);
  }

  // Chat Messages CRUD operations

  Future<int> insertChatMessage(LocalChatMessage message) async {
    final db = await database;
    if (message.attachmentBytes != null) {
      // If an attachment is present, insert it into the database
      return await db.insert('chat_messages', {
        'senderId': message.senderId,
        'receiverId': message.receiverId,
        'attachmentBytes': message.attachmentBytes,
        'timestamp': message.timestamp.toIso8601String(),
      });
    } else {
      // If there's no attachment, insert the text into the database
      return await db.insert('chat_messages', {
        'senderId': message.senderId,
        'receiverId': message.receiverId,
        'text': message.text,
        'timestamp': message.timestamp.toIso8601String(),
      });
    }
  }

  Future<List<LocalChatMessage>> getChatMessages() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('chat_messages');
    return List.generate(maps.length, (i) => LocalChatMessage.fromMap(maps[i]));
  }

  Future<int> updateChatMessage(LocalChatMessage message) async {
    final db = await database;
    final Map<String, dynamic> messageData = {
      'senderId': message.senderId,
      'receiverId': message.receiverId,
      'text': message.text,
      'timestamp': message.timestamp.toIso8601String(),
    };

    if (message.attachmentBytes != null) {
      messageData['attachmentBytes'] = message.attachmentBytes;
    }

    return await db.update(
      'chat_messages',
      messageData,
      where: 'id = ?',
      whereArgs: [message.id],
    );
  }

  Future<int> deleteChatMessage(int id) async {
    final db = await database;
    return await db.delete('chat_messages', where: 'id = ?', whereArgs: [id]);
  }

  // Define a method to synchronize chat messages from the local database to the online one.
  Future<void> synchronizeChatMessages() async {
    // Fetch unsynchronized chat messages from the local database (where sync = 0).
    final List<LocalChatMessage> unsynchronizedMessages =
        await getUnsynchronizedChatMessages();

    // Assuming you have an API service for interacting with the online database.
    final OnlineDatabaseService onlineService = OnlineDatabaseService();
    // Iterate through unsynchronized messages and push them to the online database.
    for (final chatMessage in unsynchronizedMessages) {
      try {
        // Push the message to the online database.
        await onlineService.pushChatMessage(
          from: chatMessage.senderId.toString(),
          to: chatMessage.receiverId.toString(),
          message: chatMessage.text!,
        );

        // Update the 'sync' status in the local database to 1 to mark it as synchronized.
        await markMessageAsSynchronized(chatMessage);
      } catch (e) {
        // Handle errors, e.g., network issues, conflicts, etc.
        print('Error while synchronizing: $e');
      }
    }
  }

// Fetch unsynchronized chat messages from the local database.
  Future<List<LocalChatMessage>> getUnsynchronizedChatMessages() async {
    final db = await DatabaseHelper.instance.database;
    final List<Map<String, dynamic>> maps =
        await db.query('chat_messages', where: 'sync = 0');
    return List.generate(maps.length, (i) => LocalChatMessage.fromMap(maps[i]));
  }

// Mark a chat message as synchronized in the local database (update the 'sync' column to 1).
  Future<void> markMessageAsSynchronized(LocalChatMessage message) async {
    final db = await DatabaseHelper.instance.database;
    await db.update(
      'chat_messages',
      {'sync': 1},
      where: 'id = ?',
      whereArgs: [message.id],
    );
  }
}
