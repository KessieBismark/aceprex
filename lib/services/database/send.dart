import 'dart:io';
import 'dart:typed_data';
import 'package:aceprex/services/database/local_db.dart';
import 'package:aceprex/services/database/model.dart';
import 'package:aceprex/services/database/online_db.dart';
import 'package:aceprex/services/utils/helpers.dart';
import 'package:sqflite/sqflite.dart';
import 'package:image/image.dart' as img;

class SendChat {
  final dbb = DatabaseHelper.instance;

  Future<int> insertChatMessage(LocalChatMessage message) async {
    final db = await dbb.database;

    return db.transaction((txn) async {
      // Check if a record with the same ID already exists.
      final existingRecord = await txn
          .rawQuery('SELECT 1 FROM chat_messages WHERE id = ?', [message.id]);

      if (existingRecord.isNotEmpty) {
        // A record with the same ID already exists. Handle it as needed.
        return 0; // Return 0 to indicate that the record was not inserted.
      }

      final values = {
        'id': message.id,
        'senderId': message.senderId,
        'receiverId': message.receiverId,
        'timestamp': message.timestamp.toIso8601String(),
        'userID': message.userID,
        'seen': message.seen,
        'sync': message.sync,
      };

      if (message.attachment != null) {
        // Save the attachment to the local directory.
        // final attachmentDirectory = await dbb.getAttachmentDirectory();
        // final attachmentPath =
        //     join(attachmentDirectory.path, '${message.id}.jpg');
        // await File(attachmentPath).writeAsString(message.attachment!);
        values['attachment'] = message.attachment;
      } else {
        values['attachment'] = "";
      }

      values['text'] = message.text ?? '';

      return await txn.insert('chat_messages', values);
    });
  }

  Future<List<LocalChatMessage>> getUnsynchronizedChatMessages() async {
    final db = await DatabaseHelper.instance.database;
    final List<Map<String, dynamic>> maps =
        await db.query('chat_messages', where: 'sync = 0');
    return List.generate(maps.length, (i) => LocalChatMessage.fromMap(maps[i]));
  }

  Future<void> onLineStatus(int status, int id) async {
    final db = await DatabaseHelper.instance.database;
    await db.update(
      'users',
      {'online': status},
      where: 'id = ?',
      whereArgs: [id],
    );
  }

// Mark a chat message as synchronized in the local database (update the 'sync' column to 1).
  Future<void> markMessageAsSynchronized(int id) async {
    final db = await DatabaseHelper.instance.database;
    await db.update(
      'chat_messages',
      {'sync': 1},
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // Mark a chat message as synchronized in the local database (update the 'sync' column to 1).
  Future<void> markSeenMessage(int id) async {
    final db = await DatabaseHelper.instance.database;
    await db.update(
      'chat_messages',
      {'seen': 1},
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<void> markAllSeenMessage(int userID, int receiver) async {
    final db = await DatabaseHelper.instance.database;
    await db.update(
      'chat_messages',
      {'seen': 1},
      where: 'userID = ? AND receiverId = ?',
      whereArgs: [userID, receiver],
    );
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
            cid: chatMessage.id!,
            attachment: await fileToUint8List(chatMessage.attachment!),
            date: chatMessage.timestamp);

        // Update the 'sync' status in the local database to 1 to mark it as synchronized.
      } catch (e) {
        // Handle errors, e.g., network issues, conflicts, etc.
        print.call('Error while synchronizing: $e');
      }
    }
  }

  Future<Uint8List> fileToUint8List(String? filePath) async {
    try {
      final File file = File(filePath!);
      if (await file.exists()) {
        final Uint8List uint8list = await file.readAsBytes();
        return uint8list;
      }
    } catch (e) {
      print('Error converting file to Uint8List: $e');
    }
    return Uint8List(0); // Return an empty Uint8List if there was an error.
  }

  Future<List<int>> compressImage(List<int> imageBytes) async {
    try {
      // Load the image using the image package
      final pic = img.decodeImage(Uint8List.fromList(imageBytes));

      // Resize the image (adjust the dimensions as needed)
      final resizedImage = img.copyResize(pic!, width: 800);

      // Encode the image to JPEG format with a specific quality (adjust as needed)
      final compressedImageData = img.encodeJpg(resizedImage, quality: 70);

      return compressedImageData;
    } catch (e) {
      print("Image compression error: $e");
      // If compression fails, return the original image bytes
      return imageBytes;
    }
  }

  // Future<int> getLastId() async {
  //   final db = await dbb.database;
  //   final result = await db.rawQuery('''
  //   SELECT MAX(id) AS max_id
  //   FROM chat_messages WHERE seen = 1 AND senderId= ""
  // ''');

  //   final maxId = Sqflite.firstIntValue(result);
  //   return maxId ?? 0;
  // }
  Future<int> getLastId() async {
    final db = await dbb.database;

    final result = await db.rawQuery(
        '''
    SELECT MAX(id) AS max_id
    FROM chat_messages
    WHERE seen = ? AND senderId = ?
  ''',
        ['1', Utils.userID]);

    final maxId = Sqflite.firstIntValue(result);
    return maxId ?? 0;
  }
}
