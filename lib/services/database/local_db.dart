import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'package:aceprex/services/constants/constant.dart';
import 'package:dio/dio.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import '../../pages/library/component/model.dart';
import '../utils/helpers.dart';
import 'model.dart';
import 'package:image/image.dart' as img;
import 'package:http/http.dart' as http;

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._();
  static Database? _database;

  static Directory? profileDirectory;
  static Directory? attachmentDirectory;

  DatabaseHelper._();

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDatabase();
    return _database!;
  }

// directory link
  Future<Directory> getProfileDirectory() async {
    profileDirectory ??= await _initProfileDirectory();
    return profileDirectory!;
  }

  Future<Directory> getAttachmentDirectory() async {
    attachmentDirectory ??= await _initAttachmentDirectory();
    return attachmentDirectory!;
  }

  Future<Directory> _initProfileDirectory() async {
    final documentsDirectory = await getApplicationDocumentsDirectory();
    return Directory(join(documentsDirectory.path, 'profiles'));
  }

  Future<Directory> _initAttachmentDirectory() async {
    final documentsDirectory = await getApplicationDocumentsDirectory();
    return Directory(join(documentsDirectory.path, 'attachments'));
  }
  //---------------------------------------------------

  Future<Database> _initDatabase() async {
    final documentsDirectory = await getApplicationDocumentsDirectory();
    final databasePath = join(documentsDirectory.path, 'aceprex.db');

    final profileDirectory = DatabaseHelper.profileDirectory ??
        Directory(join(documentsDirectory.path, 'profiles'));
    final attachmentDirectory = DatabaseHelper.attachmentDirectory ??
        Directory(join(documentsDirectory.path, 'attachments'));
    if (!profileDirectory.existsSync()) {
      profileDirectory.createSync(recursive: true);
    }
    if (!attachmentDirectory.existsSync()) {
      attachmentDirectory.createSync(recursive: true);
    }

    return await openDatabase(databasePath, version: 1, onCreate: _createDB);
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
      CREATE TABLE saved_pdfs(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            online_id INTEGER,   
            pdfPath TEXT
      )
    ''');
    // Create opened PDFs table
    await db.execute('''
          CREATE TABLE opened_pdfs(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            pdfInfoId INTEGER,
            lastPageRead INTEGER
          )
        ''');
    // Create opened PDFs table
    await db.execute('''
          CREATE TABLE online_pdfs(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            pdfInfoId INTEGER,
            lastPageRead INTEGER
          )
        ''');

    await db.execute('''
      CREATE TABLE users(
        id INTEGER PRIMARY KEY,
        username TEXT,
        profilePicture TEXT,
        online INTEGER DEFAULT 0
      )
    ''');

    await db.execute('''
      CREATE TABLE chat_messages(
        id INTEGER PRIMARY KEY,
        senderId INTEGER,
        receiverId INTEGER,
        text TEXT NULL,
        attachment TEXT NULL,
        timestamp TEXT,
        sync INTEGER DEFAULT 0,
        seen INTEGER DEFAULT 0,
        userID INTEGER
      )
    ''');
  }

  Future<int> insertPDF(PDFModel pdf) async {
    final db = await database;
    return await db.insert('pdfs', pdf.toMap());
  }

  Future<bool> isUserIdExists(int userId) async {
    final db = await database;
    // final result =
    //     await db.rawQuery('SELECT count(*) FROM users WHERE id = ?', [userId]);
    // return result.isNotEmpty;
    final result = await db.rawQuery(
        'SELECT EXISTS(SELECT 1 FROM users WHERE id = ? LIMIT 1)', [userId]);
    return Sqflite.firstIntValue(result) == 1;
  }

  Future<String?> getGroupConcatForUserId() async {
    final db = await database;
    final result = await db.rawQuery('SELECT GROUP_CONCAT(id) FROM users');
    final groupConcat = (result.first['GROUP_CONCAT(id)'] as String?) ??
        ''; // Use ?? to provide a default value

    return groupConcat;
  }

  Future<Uint8List> downloadAndCompressImage(String imageUrl) async {
    // final response = await http.get(Uri.parse(imageUrl));
    final response =
        await http.get(Uri.parse("$fileUrl/users-avatar/$imageUrl"));

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

  Future<void> insertOrUpdateOpenedPdf(OpenedPdf openedPdf) async {
    final db = await database;

    // Check if the id exists in the 'opened_pdfs' table.
    final count = Sqflite.firstIntValue(await db.rawQuery(
      'SELECT COUNT(*) FROM opened_pdfs WHERE id = ?',
      [openedPdf.id],
    ));

    if (count == 0) {
      // If the id doesn't exist, insert the record.
      await db.insert('opened_pdfs', openedPdf.toMap());
    } else {
      // If the id exists, update the record.
      await db.update(
        'opened_pdfs',
        openedPdf.toMap(),
        where: 'id = ?',
        whereArgs: [openedPdf.id],
      );
    }
  }

  Future<void> insertOrUpdateOnlinePdf(OpenedPdf openedPdf) async {
    final db = await database;

    // Check if the id exists in the 'opened_pdfs' table.
    final count = Sqflite.firstIntValue(await db.rawQuery(
      'SELECT COUNT(*) FROM online_pdfs WHERE id = ?',
      [openedPdf.id],
    ));

    if (count == 0) {
      // If the id doesn't exist, insert the record.
      await db.insert('online_pdfs', openedPdf.toMap());
    } else {
      // If the id exists, update the record.
      await db.update(
        'online_pdfs',
        openedPdf.toMap(),
        where: 'id = ?',
        whereArgs: [openedPdf.id],
      );
    }
  }

  Future<int> getLastPageLibrary(int id) async {
    final db = await database;

    // Query the 'opened_pdfs' table to get the lastPageRead for the specified id.
    final result = await db.rawQuery('''
    SELECT lastPageRead
    FROM opened_pdfs
    WHERE id = ?
  ''', [id]);

    if (result.isNotEmpty) {
      return result.first['lastPageRead'] as int;
    } else {
      // Handle the case where the id is not found or no records exist.
      // You might return a default value or throw an exception depending on your use case.
      return 1; // Default value (adjust as needed)
    }
  }

  Future<int> getLastPageOnline(int id) async {
    final db = await database;

    // Query the 'opened_pdfs' table to get the lastPageRead for the specified id.
    final result = await db.rawQuery('''
    SELECT lastPageRead
    FROM online_pdfs
    WHERE id = ?
  ''', [id]);

    if (result.isNotEmpty) {
      return result.first['lastPageRead'] as int;
    } else {
      // Handle the case where the id is not found or no records exist.
      // You might return a default value or throw an exception depending on your use case.
      return 1; // Default value (adjust as needed)
    }
  }

  Future<String> downloadAndSavePdf(int onlineId, String url) async {
    // Check if the online_id already exists in the database
    final db = await database;
    final result = await db.query('saved_pdfs',
        columns: ['pdfPath'], where: 'online_id = ?', whereArgs: [onlineId]);

    if (result.isNotEmpty) {
      // If the online_id exists, return the pdfPath associated with it
      return result.first['pdfPath'] as String;
    }

    // If the online_id does not exist, download and save the PDF
    final dir = await getApplicationDocumentsDirectory();
    final pdfPath = '${dir.path}/pdf_$onlineId.pdf';

    try {
      final response = await Dio().download(url, pdfPath);
      if (response.statusCode == 200) {
        // PDF downloaded successfully, save the record in the database
        await db.insert('saved_pdfs', {
          'online_id': onlineId,
          'pdfPath': pdfPath,
        });
        return pdfPath;
      } else {
        // Handle any errors when downloading the PDF
        return "";
      }
    } catch (e) {
      // Handle exceptions such as network errors
      return "";
    }
  }

  // Users CRUD operations

  Future<void> insertOrUpdateUser(User user) async {
    final db = await database;

    // Check if the user ID exists in the table.
    final userExists = await isUserIdExists(user.id!);
    // // If the user ID does not exist, insert the user.
    if (!userExists) {
      // final profileDirectory = await getProfileDirectory();
      // final profilePicturePath = join(profileDirectory.path, '${user.id}.jpg');
      // Uint8List compressedProfilePicture =
      //     await downloadAndCompressImage(user.profilePicture!);
      // await File(profilePicturePath).writeAsBytes(compressedProfilePicture);
      await db.insert(
        'users',
        {
          'id': user.id,
          'username': user.username,
          'profilePicture': user.profilePicture,
          'online': user.online,
        },
      );
      //   }
      // });
    }
  }

  Future<int> insertUser(User user) async {
    final db = await database;
    return await db.insert(
      'users',
      {
        'username': user.username,
        'profilePicture': user.profilePicture,
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
    String? profilePicture = user.profilePicture;

    return await db.update(
      'users',
      {
        'username': user.username,
        'profilePicture': profilePicture,
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
  Future<LocalChatMessage?> getMostRecentChatMessage(int userID) async {
    final db = await database;
    final result = await db.rawQuery('''
    SELECT *
    FROM chat_messages
    WHERE userID = ?
    AND id = (SELECT MAX(id) FROM chat_messages WHERE userID = ?)
  ''', [userID, userID]);

    if (result.isNotEmpty) {
      final message = result.first;
      return LocalChatMessage.fromMap(message);
    } else {
      return null; // No messages found for the user.
    }
  }

  Future<int> countUnseenMessages(int userID) async {
    final db = await database;
    final result = await db.rawQuery('''
    SELECT COUNT(*)
    FROM chat_messages
    WHERE userID = ? AND receiverId = ? AND seen = 0
  ''', [userID, Utils.userID]);

    return Sqflite.firstIntValue(result) ?? 0;
  }

  Future<List<LocalChatMessage>> getChatMessages(int userID) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'chat_messages',
      where: 'userID = ?',
      whereArgs: [userID],
    );
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

    if (message.attachment != null) {
      messageData['attachment'] = message.attachment;
    }

    return await db.update(
      'chat_messages',
      messageData,
      where: 'id = ?',
      whereArgs: [message.id],
    );
  }

  Future<int> getMaxId() async {
    final db = await database;
    final result = await db.rawQuery('''
    SELECT MAX(id) AS max_id
    FROM chat_messages
  ''');

    final maxId = Sqflite.firstIntValue(result);
    return maxId ?? 0;
  }

  Future<int> deleteChatMessage(int id) async {
    final db = await database;
    return await db.delete('chat_messages', where: 'id = ?', whereArgs: [id]);
  }
}
