import 'package:flutter_tts/flutter_tts.dart';
import 'package:get/get.dart';

class TtsController extends GetxController {
  final FlutterTts flutterTts = FlutterTts();
  RxBool isPlaying = false.obs;
  var fontSize = 20.0.obs;
  var fontChanged = false.obs;
  var playIndex = 0.obs;
  @override
  void onInit() {
    super.onInit();
    flutterTts.setLanguage("en-AU");
    flutterTts.setSpeechRate(0.45);
    flutterTts.setPitch(1);
  }

  void setFontSize(double size) {
    fontSize.value = size;
    fontChanged.toggle();
  }

  Future<void> readAloud(int pageIndex, List<String> textList) async {
    final text = textList[pageIndex];
    playIndex.value = pageIndex;
    isPlaying.value = true;
    await flutterTts.speak(combineTextParagraphs(text).toString());
  }

  Future<void> togglePlayPause(List<String> textList) async {
    if (isPlaying.value) {
      await flutterTts.stop();
    } else {
      await readAloud(0, textList);
    }
    isPlaying.toggle();
  }

  String combineTextParagraphs(String text) {
    // Replace line breaks with spaces
    return text.replaceAll('\n', ' ');
  }

  @override
  void onClose() {
    flutterTts.stop();
    isPlaying.value = false;
    super.onClose();
  }

  stop() {
    flutterTts.pause();
    isPlaying.value = false;
  }
}
