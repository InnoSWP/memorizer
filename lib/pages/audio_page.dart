import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:memorizer/settings/constants.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

class AudioPlayerOur extends StatefulWidget {

  final List<String> sentences;

  AudioPlayerOur({required this.sentences, Key? key}) : super(key: key);

  @override
  State<AudioPlayerOur> createState() => _AudioPlayerOurState();
}

class _AudioPlayerOurState extends State<AudioPlayerOur> {

  final ItemScrollController _itemScrollController = ItemScrollController();
  final ItemPositionsListener _itemPositionsListener =
      ItemPositionsListener.create();
  int _currentSentenceIndex = 0;

  @override
  void initState() {
    super.initState();
    _speechToText = stt.SpeechToText();
}
  bool _isPlayingAudio = false;
  bool _isLoop = false;
  IconData playBtnIcon = Icons.play_arrow;

  @override
  void dispose() {
    super.dispose();
  }

  late stt.SpeechToText _speechToText;
  bool _isListening = false;

  List<String> _command = ['Say', 'a', 'command'];

  void nextSentence() {
    if (_currentSentenceIndex != widget.sentences.length - 1) {
      _currentSentenceIndex++;
    }
    playCurrentSentence();
  }

  void previousSentence() {
    if (_currentSentenceIndex != 0) _currentSentenceIndex--;

    playCurrentSentence();
  }


  void playCurrentSentence() {
    _itemScrollController.scrollTo(
      index: _currentSentenceIndex,
      duration: const Duration(
        milliseconds: 500,
      ),
      curve: Curves.easeInOutCubic,
    );
  }


  void loopButtonPressed() {
    setState(() {
      if (_isLoop == false) {
        _isLoop = true;
      } else {
        _isLoop = false;
      }
    });
  }

  void prevButtonPressed() {
    setState(() {
      previousSentence();
    });
  }

  void playButtonPressed() {
    setState(() {
      if (_isPlayingAudio) {
        _isPlayingAudio = false;
        playBtnIcon = Icons.play_arrow;
      } else {
        _isPlayingAudio = true;
        playBtnIcon = Icons.pause;
      }
      playCurrentSentence();
    });
  }

  void nextButtonPressed() {
    setState(() {
      nextSentence();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: kAppBarBackClr,
        title:
            Text("AUDIO PLAYER PAGE", style: TextStyle(color: kAppBarTextClr)),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              flex: 10,
              child: Container(
                decoration: const BoxDecoration(
                  gradient: kDarkGradientBackground,
                ),
                child: ScrollablePositionedList.builder(
                  itemCount: widget.sentences.length,
                  itemBuilder: (context, index) => Text(
                    widget.sentences[index],
                    style: index == _currentSentenceIndex
                        ? kTextStyleSelected
                        : kTextStyleMain,
                  ),
                  itemScrollController: _itemScrollController,
                  itemPositionsListener: _itemPositionsListener,
                ),
              ),
            ),
            Expanded(
              flex: 2,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  FloatingActionButton(
                    onPressed: _listen,
                    child: Icon(_isListening ? Icons.mic : Icons.mic_none),
                  ),
                  TextButton(
                    onPressed: () {},
                    child: const Icon(Icons.info_outlined),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Container(
                decoration: const BoxDecoration(
                  gradient: kDarkGradientBackground,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    TextButton(
                      onPressed: loopButtonPressed,
                      child: const Icon(Icons.repeat),
                    ),
                    TextButton(
                      onPressed: prevButtonPressed,
                      child: const Icon(Icons.skip_previous),
                    ),
                    TextButton(
                      onPressed: playButtonPressed,
                      child: Icon(playBtnIcon),
                    ),
                    TextButton(
                      onPressed: nextButtonPressed,
                      child: const Icon(Icons.skip_next),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _listen() async {
    if (!_isListening) {
      bool available = await _speechToText.initialize(
        onStatus: (val) {
          if (kDebugMode) {
            print('onStatus: $val');
          }
          if (val == 'done') {
            _stopListening();
          }
        },
        onError: (val) => print('onError: $val'),
      );
      if (available) {
        setState(() => _isListening = true);
        _speechToText.listen(
            onResult: (val) => setState(() {
                  _command = val.recognizedWords.split(' ');
                }));
      }
    } else {
      _stopListening();
    }
  }

  void _stopListening() {
    setState(() {
      _isListening = false;
      if (_command.isNotEmpty) {
        if (_command.contains('next')) {
          nextSentence();
        }
        else if (_command.contains('previous')) {
          previousSentence();
        }
        else if (_command.contains('play')) {
          playCurrentSentence();
        }
        else if (_command.contains('pause')) {
          // TODO - stop spelling sentences.
          // If user calls 'play' command again,
          // it should continue from the current sentence
        }
        else if (_command.contains('stop')) {
          // TODO - stop spelling sentences and set currentSentence to 0.
        }
        else if (_command.contains('repeat')) {
          // TODO - add repeat functionality
        }
        else {
          // TODO - correctly handle a wrong voice command
          print('$_command is not supported, please, try again...');
        }
      }
    });
    _command = [];
    _speechToText.stop();
  }
}
