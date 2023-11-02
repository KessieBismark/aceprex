import 'dart:convert';
import 'dart:typed_data';
import 'package:aceprex/services/constants/server.dart';
import 'package:aceprex/services/database/send.dart';
import 'package:http/http.dart' as http;

class OnlineDatabaseService {
  Future<void> pushChatMessage(
      {required String from,
      required String to,
      String? message,
      required int cid,
      required DateTime date,
      Uint8List? attachment}) async {
    try {
      if (attachment!.isEmpty) {
        final response = await http.post(Uri.parse(Api.url), body: {
          "action": "send_chat_message",
          "cid": cid.toString(),
          "from": from,
          "to": to,
          'date': date.toString(),
          "message": message!.replaceAll('\n', ' '),
        });
        if (response.statusCode == 200) {
          // Successfully pushed the message to the online database.
          await SendChat().markMessageAsSynchronized(cid);
        } else {
          throw Exception('Failed to push the message: ${response.statusCode}');
        }
      } else {
        var request = http.MultipartRequest("POST", Uri.parse(Api.url));
        request.fields['from'] = from;
        request.fields['to'] = to;
        request.fields['action'] = "send_image";
        List<int> fileBytes = await SendChat().compressImage(attachment);
        request.files.add(
          http.MultipartFile.fromBytes(
            'image',
            fileBytes,
            filename: "$from$to${DateTime.now().second.toString()}",
          ),
        );
        var response = await request.send();
        var reponseData = await response.stream.toBytes();
        var result = String.fromCharCodes(reponseData);
        if (jsonDecode(result) == 'true') {
          await SendChat().markMessageAsSynchronized(cid);
          // Successfully pushed the message to the online database.
        } else {
          throw Exception('Failed to push the message: ${response.statusCode}');
        }
      }
    } catch (e) {
      throw Exception('Failed to push the message: $e');
    }
  }
}
