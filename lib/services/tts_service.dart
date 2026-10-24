import 'package:flutter/foundation.dart';
import 'package:flutter_tts/flutter_tts.dart';

class TtsService {
  final FlutterTts _tts = FlutterTts();

  Future<void> speak(String text, String locale) async {
    try {
      await _tts.stop();
      await _tts.setLanguage(locale);
      await _tts.setSpeechRate(0.42);
      await _tts.setPitch(1.0);
      await _tts.speak(text);
    } catch (e) {
      debugPrint('TTS error: $e');
    }
  }

  Future<void> stop() async {
    try {
      await _tts.stop();
    } catch (_) {}
  }
}