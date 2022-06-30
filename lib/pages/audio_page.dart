import 'package:flutter/material.dart';
import 'package:memorizer/services/stt_service.dart';
import 'package:memorizer/services/tts_service.dart';
import 'package:memorizer/settings/constants.dart' as clr;
import 'package:memorizer/widgets/buttons.dart';
import 'package:memorizer/widgets/my_app_bar.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

class AudioPage extends StatefulWidget {
  final List<String> sentences;

  const AudioPage({required this.sentences, Key? key}) : super(key: key);

  @override
  State<AudioPage> createState() => _AudioPageState();
}

class _AudioPageState extends State<AudioPage> {
  final ItemScrollController _itemScrollController = ItemScrollController();
  final ItemPositionsListener _itemPositionsListener =
      ItemPositionsListener.create();
  int _currentSentenceIndex = 0;

  // Audio player vars
  bool _isLooping = false;
  IconData playBtnIcon = Icons.play_arrow;
  late SttService sst;
  late TtsService tts;

  @override
  void initState() {
    super.initState();
    tts = TtsService();
    tts.init();
    sst = SttService(
      next: jumpToNextSentence,
      previous: jumpToPreviousSentence,
      play: playCurrentSentence,
      stop: stopPlaying,
      repeat: _triggerLoop,
    );
  }

  @override
  void dispose() {
    super.dispose();
    tts.destroy();
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
    setState(() {});
    _isLooping ? playCurrentSentence() : continueToNextSentence();
  }

  Future stopPlaying() async {
    await tts.stop();
    setState(() {});
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

  void _speedDownOnPressed() {}

  void _skipPreviousOnPressed() {
    setState(() {
      jumpToPreviousSentence();
    });
  }

  void _playOnPressed() {
    setState(() {
      if (tts.isStopped) {
        playCurrentSentence();
      } else {
        stopPlaying();
      }
    });
  }

  void _skipNextOnPressed() {
    setState(() {
      jumpToNextSentence();
    });
  }

  void _speedUpOnPressed() {}

  void _triggerLoop() {
    setState(() {
      _isLooping = !_isLooping;
    });
    ;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: MyAppBar(input: "AUDIO PLAYER PAGE", actions: [
          FloatingActionButton.small(
            heroTag: 'info',
            backgroundColor: clr.kAppBarBackClr,
            foregroundColor: Colors.white,
            splashColor: clr.kOrangeAccent,
            onPressed: () {},
            child: const Icon(
              Icons.info_outline,
              size: 20,
            ),
          )
        ]).get(),
        body: Container(
          color: Colors.black,
          child: Padding(
            padding:
                const EdgeInsets.only(left: 12, right: 12, top: 12, bottom: 24),
            child: Column(
              children: [
                Expanded(
                  flex: 10,
                  child: Container(
                    //color: kGrey,
                    decoration: BoxDecoration(
                      color: clr.blackThemeClr,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.fromBorderSide(BorderSide(
                        color: Colors.grey.shade700,
                        width: 5,
                      )),
                      // gradient: kDarkGradientBackground,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: ScrollablePositionedList.builder(
                        itemCount: widget.sentences.length,
                        itemBuilder: (context, index) => Text(
                          widget.sentences[index],
                          style: index == _currentSentenceIndex
                              ? clr.kTextStyleSelected
                              : clr.kTextStyleMain,
                        ),
                        itemScrollController: _itemScrollController,
                        itemPositionsListener: _itemPositionsListener,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Align(
                        alignment: Alignment.centerLeft,
                        child: MyButton(
                          onPressed: _triggerLoop,
                          iconData: Icons.repeat,
                          iconColor: _isLooping ? Colors.white : Colors.grey,
                        ),
                      ),
                      Align(
                        alignment: Alignment.center,
                        child: FloatingActionButton(
                          heroTag: 'micro',
                          mini: false,
                          splashColor: clr.kOrangeAccent,
                          shape: const CircleBorder(
                            side: BorderSide(
                              color: clr.kOrangeAccent,
                              width: 2,
                            ),
                          ),
                          backgroundColor: Colors.black,
                          foregroundColor: clr.kOrangeAccent,
                          onPressed: () => setState(() {
                            sst.listen();
                          }),
                          child: Icon(
                              sst.isListening ? Icons.mic : Icons.mic_none),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Container(
                    alignment: Alignment.topCenter,
                    decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(8),

                      // gradient: kDarkGradientBackground,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Expanded(
                          child: MyButton(
                              iconData: Icons.arrow_downward,
                              onPressed: _speedDownOnPressed),
                        ),
                        Expanded(
                          child: MyButton(
                              iconData: Icons.skip_previous,
                              onPressed: _skipPreviousOnPressed),
                        ),
                        Expanded(
                          child: MyButton(
                              iconData: tts.isStopped
                                  ? Icons.play_arrow
                                  : Icons.pause,
                              onPressed: _playOnPressed),
                        ),
                        Expanded(
                          child: MyButton(
                              iconData: Icons.skip_next,
                              onPressed: _skipNextOnPressed),
                        ),
                        Expanded(
                          child: MyButton(
                              iconData: Icons.arrow_upward,
                              onPressed: _speedUpOnPressed),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
