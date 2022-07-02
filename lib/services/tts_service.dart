import 'package:flutter/foundation.dart';
import 'package:flutter_tts/flutter_tts.dart';

enum TtsState { playing, stopped }

class TtsService {
  late FlutterTts _flutterTts;
  TtsState state = TtsState.stopped;

  bool get isPlaying => state == TtsState.playing;
  bool get isStopped => state == TtsState.stopped;

  Future init() async {
    _flutterTts = FlutterTts();
    await _flutterTts.awaitSpeakCompletion(true);
    await _flutterTts.setLanguage('en-US');
    // Android only
    await _flutterTts.setQueueMode(0);
    _flutterTts.setStartHandler(() {state = TtsState.playing; print('START');});
    _flutterTts.setCancelHandler(() {state = TtsState.stopped; print('STOP');});
    _flutterTts.setCompletionHandler(() {state = TtsState.stopped; print('COMPLETE');});
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
    await _flutterTts.speak(sentence);
    if (kDebugMode) {
      print('finished speaking');
    }
  }

  Future stop() async {
    state = TtsState.stopped;
    await _flutterTts.stop();
  }

  Future destroy() async {
    await _flutterTts.stop();
  }
}
