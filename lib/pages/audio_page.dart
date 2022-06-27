import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:memorizer/modules/tts_service.dart';
import 'package:memorizer/settings/constants.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import '../modules/stt_service.dart';


class AudioPage extends StatefulWidget {
  final List<String> sentences;

  AudioPage({required this.sentences, Key? key}) : super(key: key);

  @override
  State<AudioPage> createState() => _AudioPageState();
}

class _AudioPageState extends State<AudioPage> {
  final ItemScrollController _itemScrollController = ItemScrollController();
  final ItemPositionsListener _itemPositionsListener =
      ItemPositionsListener.create();
  int _currentSentenceIndex = 0;

  // Audio player vars
  bool isLoop = false;
  IconData playBtnIcon = Icons.play_arrow;
  late SttService sst;
  late TtsService tts;

  @override
  void initState() {
    super.initState();
    tts = TtsService();
    tts.init();
    sst = SttService(next: jumpToNextSentence,
        previous: jumpToPreviousSentence,
        play: playCurrentSentence, stop: stopPlaying);
  }

  Future continueToNextSentence() async {
    if (_currentSentenceIndex < widget.sentences.length - 1) {
      _currentSentenceIndex++;
      scrollToCurrentSentence();
      if (tts.isPlaying) {
        await playCurrentSentence();
      }
    } else {
      stopPlaying();
      _currentSentenceIndex = 0;
    }
  }

  Future jumpToNextSentence() async {
    bool wasPlaying = tts.isPlaying;
    if (wasPlaying) {
      sst.stop();
    }
    if (_currentSentenceIndex < widget.sentences.length - 1) {
      _currentSentenceIndex++;
      scrollToCurrentSentence();
    } else {
      stopPlaying();
      _currentSentenceIndex = 0;
    }
    if (wasPlaying) {
      await playCurrentSentence();
    }
  }

  Future jumpToPreviousSentence() async {
    bool wasPlaying = tts.isPlaying;
    if (wasPlaying) {
      stopPlaying();
    }
    if (_currentSentenceIndex > 0) {
      _currentSentenceIndex--;
      scrollToCurrentSentence();
    }
    if (wasPlaying) {
      await playCurrentSentence();
    }
  }

  Future playCurrentSentence() async {
    scrollToCurrentSentence();
    await tts.play(widget.sentences[_currentSentenceIndex]);
    setState((){});
    continueToNextSentence();
  }

  Future stopPlaying() async {
    setState(() => tts.stop());
  }

  void scrollToCurrentSentence() {
    setState(() {
      _itemScrollController.scrollTo(
        index: _currentSentenceIndex,
        duration: const Duration(
          // TODO - might be a good idea to make the animation duration a constant
          milliseconds: 500,
        ),
        curve: Curves.easeInOutCubic,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: kAppBarBackClr,
        title: Text(
          'AUDIO PLAYER PAGE',
          style: TextStyle(color: kAppBarTextClr),
        ),
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
                    onPressed: () => setState((){sst.listen();}),
                    child: Icon(sst.isListening ? Icons.mic : Icons.mic_none),
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
                      onPressed: () {
                        // TODO: set functionality for loop
                      },
                      child: const Icon(Icons.repeat),
                    ),
                    TextButton(
                      child: const Icon(Icons.skip_previous),
                      onPressed: () {
                        setState(() {
                          jumpToPreviousSentence();
                        });
                      },
                    ),
                    TextButton(
                      child: Icon(tts.isStopped
                          ? Icons.play_arrow
                          : Icons.pause),
                      onPressed: () {
                        setState(() {
                          if (tts.isStopped) {
                            playCurrentSentence();
                          } else {
                            stopPlaying();
                          }
                        });
                      },
                    ),
                    TextButton(
                      child: const Icon(Icons.skip_next),
                      onPressed: () {
                        setState(() {
                          jumpToNextSentence();
                        });
                      },
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



  @override
  void dispose() {
    super.dispose();
    tts.destroy();
  }
}
