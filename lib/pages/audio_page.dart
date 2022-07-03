import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:memorizer/pages/info_page.dart';
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
  int repeatNumber = 0;

  @override
  void initState() {
    super.initState();
    tts = TtsService();
    tts.init();
    sst = SttService(
      next: jumpToNextSentence,
      previous: jumpToPreviousSentence,
      play: _playOnPressed,
      stop: stopPlaying,
      repeat: setRepeatNumber,
    );
  }

  @override
  void dispose() {
    super.dispose();
    tts.destroy();
  }

  void setRepeatNumber(int enteredNumber) {
    if (enteredNumber < 0) {
      repeatNumber = 0;
    } else if (enteredNumber > 99) {
      repeatNumber = 99;
    } else {
      repeatNumber = enteredNumber;
    }
    setState(() {});
  }

  Future continueToNextSentence() async {
    if (_currentSentenceIndex < widget.sentences.length - 1) {
      _currentSentenceIndex++;
      scrollToCurrentSentence();
      if (tts.isPlaying) {
        await playCurrentSentence(repeatNumber);
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
      await playCurrentSentence(repeatNumber);
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
      await playCurrentSentence(repeatNumber);
    }
  }

  Future playCurrentSentence(int times) async {
    scrollToCurrentSentence();
    await tts.play(widget.sentences[_currentSentenceIndex]);
    times--;
    setState(() {});
    //_isLooping ? playCurrentSentence() : continueToNextSentence();
    if (times > 0) {
      playCurrentSentence(times);
    } else {
      continueToNextSentence();
    }
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
        playCurrentSentence(repeatNumber);
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

  void _repeatOnPressed() {
    if (repeatNumber != 0) {
      setState(() {
        repeatNumber = 0;
      });
    } else {
      setState(() {
        repeatNumber = -1;
      });
    }
  }

  void _repeatOnLongPressed() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        int? enteredNumber;
        return AlertDialog(
          title:
              const Text("Please specify the number of repetitions you want"),
          content: SizedBox(
            width: 15.w,
            child: TextField(
              onChanged: (value) {
                enteredNumber = int.parse(value);
              },
              keyboardType: TextInputType.number,
              cursorColor: clr.kBnbSelectedItemClr,
              decoration: InputDecoration(
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                    color: clr.kBnbSelectedItemClr,
                  ),
                ),
              ),
            ),
          ),
          actions: [
            TextButton(
              style: ButtonStyle(
                  foregroundColor: MaterialStateProperty.all(Colors.grey)),
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              style: ButtonStyle(
                  foregroundColor:
                      MaterialStateProperty.all(clr.kOrangeAccent)),
              onPressed: () {
                if (enteredNumber != null) {
                  if (enteredNumber! < 0) {
                    enteredNumber = 0;
                  } else if (enteredNumber! > 99) {
                    enteredNumber = 99;
                  }
                  setState(() {
                    repeatNumber = enteredNumber!;
                  });
                }
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
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
                        child: RepeatButton(
                          repeatNumber: repeatNumber,
                          // height: kAduioPlayerButtonHeight,
                          // width: kAduioPlayerButtonWidth,
                          onPressed: _repeatOnPressed,
                          onLongPress: _repeatOnLongPressed,
                          // iconData: Icons.repeat,
                          // iconColor: _isLooping ? Colors.white : Colors.grey,
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
                      Align(
                        alignment: Alignment.centerRight,
                        child: FloatingActionButton.small(
                          backgroundColor: Colors.black,
                          foregroundColor: clr.kOrangeAccent,
                          splashColor: clr.kOrangeAccent,
                          onPressed: () {
                            // Navigator.of(context).push(_createInfoRoute());
                            showModalBottomSheet(
                              context: context,
                              builder: (BuildContext context) {
                                return const InfoPage();
                              },
                            );
                          },
                          child: const Icon(
                            Icons.info_outline,
                            size: 20,
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
                            onPressed: _skipPreviousOnPressed),
                        MyButton(
                            height: kAduioPlayerButtonHeight,
                            width: kAduioPlayerButtonWidth,
                            iconData:
                                tts.isStopped ? Icons.play_arrow : Icons.pause,
                            onPressed: _playOnPressed),
                        MyButton(
                            height: kAduioPlayerButtonHeight,
                            width: kAduioPlayerButtonWidth,
                            iconData: Icons.skip_next,
                            onPressed: _skipNextOnPressed),
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

// Route _createInfoRoute() {
//   return PageRouteBuilder(
//     pageBuilder: (context, animation, secondaryAnimation) => const InfoPage(),
//     transitionsBuilder: (context, animation, secondaryAnimation, child) {
//       const begin = Offset(0.0, 1.0);
//       const end = Offset.zero;
//       const curve = Curves.ease;

//       var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

//       return SlideTransition(
//         position: animation.drive(tween),
//         child: child,
//       );
//     },
//   );
// }
