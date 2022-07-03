import 'package:flutter/foundation.dart';
import 'package:flutter_tts/flutter_tts.dart';

enum TtsState { playing, stopped }

class TtsService {
  late FlutterTts _flutterTts;
  TtsState state = TtsState.stopped;

  bool get isPlaying => state == TtsState.playing;
  bool get isStopped => state == TtsState.stopped;

  void init() async {
    _flutterTts = FlutterTts();
    await _flutterTts.awaitSpeakCompletion(true);
    await _flutterTts.setLanguage('en-US');
  }

  void decreaseVolume() async {
    print('decreasing volume');
    await _flutterTts.setVolume(0.0);
  }

  void increaseVolume() async {
    print('increasing volume');
    await _flutterTts.setVolume(1.0);
  }

  Future play(String sentence) async {
    state = TtsState.playing;
    return await _flutterTts.speak(sentence);
    if (kDebugMode) {
      print('finished speaking');
    }
  }

  Future stop() async {
    state = TtsState.stopped;
    return await _flutterTts.stop();
  }

  void destroy() {
    _flutterTts.stop();
  }
}
