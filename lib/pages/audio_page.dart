import 'package:flutter/material.dart';
import 'package:memorizer/services/stt_service.dart';
import 'package:memorizer/services/tts_service.dart';
import 'package:memorizer/settings/constants.dart' as clr;
import 'package:memorizer/widgets/buttons.dart';
import 'package:memorizer/widgets/my_app_bar.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:sizer/sizer.dart';

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
  int _numberOfReps = 1;

  @override
  void initState() {
    super.initState();
    tts = TtsService();
    tts.init();
    sst = SttService(
      next: jumpToNextSentence,
      previous: jumpToPreviousSentence,
      play: playAllSentencesFromCurrent,
      stop: stopPlaying,
      repeat: repeat,
    );
  }

  @override
  void dispose() {
    super.dispose();
    tts.destroy();
  }
  bool flag = false;
  Future playAllSentencesFromCurrent() async {
    while (_currentSentenceIndex < widget.sentences.length) {
      await playCurrentSentence();
      //if (flag) {
      //  flag = false;
      //  return;
      //}
      next();
    }
  }

  Future repeat(int times) async {
    _numberOfReps = times;
    await stopPlaying();
    await playAllSentencesFromCurrent();
    setState(() {});
  }

  void next() {
    if (_currentSentenceIndex < widget.sentences.length - 1) {
      _currentSentenceIndex++;
      //scrollToCurrentSentence();
    }
  }

  void prev() {
    if (_currentSentenceIndex > 0) {
      _currentSentenceIndex--;
      //scrollToCurrentSentence();
    }
  }

  Future jumpToNextSentence() async {
    bool wasPlaying = tts.isPlaying;
    if (wasPlaying) {
      await stopPlaying();
    }
    if (_currentSentenceIndex < widget.sentences.length - 1) {
      _currentSentenceIndex++;
      //scrollToCurrentSentence();
    } else {
      await stopPlaying();
      //_currentSentenceIndex = 0;
    }
    if (wasPlaying) {
      //await playCurrentSentence();
      await playAllSentencesFromCurrent();
    }
    setState(() {});
    print(_currentSentenceIndex);
  }

  Future jumpToPreviousSentence() async {
    bool wasPlaying = tts.isPlaying;
    if (wasPlaying) {
      await stopPlaying();
    }
    if (_currentSentenceIndex > 0) {
      _currentSentenceIndex--;
      //scrollToCurrentSentence();

    }
    if (wasPlaying) {
      //await playCurrentSentence();
      await playAllSentencesFromCurrent();
    }
    setState(() {});
    print(_currentSentenceIndex);
  }

  Future playCurrentSentence() async {
    scrollToCurrentSentence();
    await tts.play(widget.sentences[_currentSentenceIndex]);
    //setState(() {});
    //_isLooping ? playCurrentSentence() : continueToNextSentence();
  }

  Future stopPlaying() async {
    if (tts.isPlaying) {
      await tts.stop();
    }
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

  void _skipPreviousOnPressed() async {
    await jumpToPreviousSentence();

    setState(() {
    });
  }

  void _playOnPressed() async {
    if (tts.isStopped) {
      await playAllSentencesFromCurrent();
    } else {
      await stopPlaying();
    }
    setState(() {

    });
  }

  void _skipNextOnPressed() async {
    await jumpToNextSentence();
    setState(() {

    });
  }

  void _speedUpOnPressed() {}

  void _triggerLoop() {
    setState(() {
      _isLooping = !_isLooping;
    });
  }

  @override
  Widget build(BuildContext context) {
    // double kScreenHeight = MediaQuery.of(context).size.height;
    // double kScreenWidth = MediaQuery.of(context).size.width;
    double kAduioPlayerButtonHeight = 6.h;
    double kAduioPlayerButtonWidth = 16.w;

    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        // appBar: MyAppBar(input: "AUDIO PLAYER PAGE", actions: [
        //   FloatingActionButton.small(
        //     backgroundColor: clr.kAppBarBackClr,
        //     foregroundColor: Colors.white,
        //     splashColor: clr.kOrangeAccent,
        //     onPressed: () {},
        //     child: const Icon(
        //       Icons.info_outline,
        //       size: 20,
        //     ),
        //   )
        // ]).get(),
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
                        width: 2,
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
                          height: kAduioPlayerButtonHeight,
                          width: kAduioPlayerButtonWidth,
                          onPressed: () => repeat(3),
                          iconData: Icons.repeat,
                          iconColor: _isLooping ? Colors.white : Colors.grey,
                        ),
                      ),
                      Align(
                        alignment: Alignment.center,
                        child: SizedBox(
                          height: 7.h,
                          width: 25.w,
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
                        // MyButton(
                        //     height: kAduioPlayerButtonHeight,
                        //     width: kAduioPlayerButtonWidth,
                        //     iconData: Icons.arrow_downward,
                        //     onPressed: _speedDownOnPressed),
                        MyButton(
                            height: kAduioPlayerButtonHeight,
                            width: kAduioPlayerButtonWidth,
                            iconData: Icons.skip_previous,
                            onPressed: () async {
                              prev();
                              //flag = true;
                              //await stopPlaying();
                              //if (tts.isStopped) {
                                playAllSentencesFromCurrent();
                              //}
                              print(_currentSentenceIndex);
                              setState((){});
                            }
                        ),
                        MyButton(
                            height: kAduioPlayerButtonHeight,
                            width: kAduioPlayerButtonWidth,
                            iconData:
                                tts.isStopped ? Icons.play_arrow : Icons.pause,
                            onPressed: () async {
                              if (tts.isStopped) {
                                playAllSentencesFromCurrent();
                              } else {
                                stopPlaying();
                                print('stopped');
                              }
                              setState((){});
                            }
                        ),
                        MyButton(
                            height: kAduioPlayerButtonHeight,
                            width: kAduioPlayerButtonWidth,
                            iconData: Icons.skip_next,
                            onPressed: () async {
                              next();
                              //flag = true;
                              //await stopPlaying();
                              //if (tts.isStopped) {
                                playAllSentencesFromCurrent();
                              //}
                              print(_currentSentenceIndex);
                              setState((){});
                            }
                            ),
                        // MyButton(
                        //     height: kAduioPlayerButtonHeight,
                        //     width: kAduioPlayerButtonWidth,
                        //     iconData: Icons.arrow_upward,
                        //     onPressed: _speedUpOnPressed),
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
