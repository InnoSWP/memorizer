import 'package:flutter/material.dart';
import 'package:memorizer/pages/info_page.dart';
import 'package:memorizer/services/stt_service.dart';
import 'package:memorizer/services/tts_service.dart';
import 'package:memorizer/widgets/buttons.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:sizer/sizer.dart';

import '../widgets/my_app_bar.dart';

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
  late SttService sst;
  late TtsService tts;
  int chosenRepeatNumber = 0;
  int currentRepeatNumber = 0;
  bool repeatForAll = false;

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
      chosenRepeatNumber = 0;
    } else if (enteredNumber > 99) {
      chosenRepeatNumber = 99;
    } else {
      chosenRepeatNumber = enteredNumber;
    }
    currentRepeatNumber = chosenRepeatNumber;
    setState(() {});
  }

  Future continueToNextSentence() async {
    setState(() {
      if (repeatForAll) {
        currentRepeatNumber = chosenRepeatNumber;
      } else {
        currentRepeatNumber = 0;
        chosenRepeatNumber = 0;
      }
    });

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
      await stopPlaying();
      print('stopped for jumping next');
    }
    if (_currentSentenceIndex < widget.sentences.length - 1) {
      _currentSentenceIndex++;
      scrollToCurrentSentence();
    } else {
      await stopPlaying();
      _currentSentenceIndex = 0;
    }
    if (wasPlaying) {
      await playCurrentSentence();
    }
  }

  Future jumpToPreviousSentence() async {
    bool wasPlaying = tts.isPlaying;
    if (wasPlaying) {
      await stopPlaying();
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
    print(
        'playing: ${widget.sentences[_currentSentenceIndex].substring(0, 10)}');

    scrollToCurrentSentence();
    var playResult = await tts.play(widget.sentences[_currentSentenceIndex]);

    print(
        'play result for "${widget.sentences[_currentSentenceIndex].substring(0, 10)}" is ${playResult.toString()}');
    print('current repeat number is $currentRepeatNumber');
    setState(() {});
    if (currentRepeatNumber != 0) {
      currentRepeatNumber--;
      playCurrentSentence();
    } else {
      if (playResult == 1) await continueToNextSentence();
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

  void _skipNextOnPressed() async {
    await jumpToNextSentence();

    setState(() {});
  }

  void _repeatOnPressed() {
    if (chosenRepeatNumber != 0) {
      setState(() {
        chosenRepeatNumber = 0;
      });
    } else {
      setState(() {
        chosenRepeatNumber = -1;
      });
    }
    setState(() {
      currentRepeatNumber = chosenRepeatNumber;
    });
  }

  void _repeatOnLongPressed() async {
    await stopPlaying();
    showDialog(
        context: context,
        builder: (BuildContext context) {
          int? enteredNumber;
          repeatForAll = false;
          return StatefulBuilder(
            builder: (context, StateSetter setter) {
              return AlertDialog(
                title: const Text(
                    "Please specify the number of repetitions you want"),
                content: SizedBox(
                  // not sure
                  width: 15.w,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                        width: 22.w,
                        child: TextFormField(
                          onChanged: (value) {
                            enteredNumber = int.tryParse(value);
                          },
                          keyboardType: TextInputType.number,
                          style: TextStyle(
                              fontSize: 20,
                              color: Theme.of(context).primaryColor),
                        ),
                      ),
                      Row(
                        children: [
                          Text(
                            'All sentences:',
                            style: TextStyle(fontSize: 10.sp),
                          ),
                          Checkbox(
                            value: repeatForAll,
                            onChanged: (value) {
                              setter(() {
                                repeatForAll = value!;
                              });
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text('Cancel'),
                  ),
                  TextButton(
                    onPressed: () {
                      if (enteredNumber != null) {
                        setRepeatNumber(enteredNumber!);
                      }
                      Navigator.of(context).pop();
                    },
                    child: const Text('OK'),
                  ),
                ],
              );
            },
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    double kAduioPlayerButtonHeight = 6.h;
    double kAduioPlayerButtonWidth = 16.w;

    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar:
            MyAppBar(context: context, input: "AUDIO PLAYER PAGE", actions: [])
                .get(),
        body: Column(
          children: [
            Expanded(
                flex: 10,
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 14, vertical: 10),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.secondary,
                      borderRadius: BorderRadius.circular(8),
                      shape: BoxShape.rectangle,
                      border:
                          Border.all(color: Theme.of(context).selectedRowColor),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: ScrollablePositionedList.builder(
                        itemCount: widget.sentences.length,
                        itemBuilder: (context, index) => Text(
                          widget.sentences[index],
                          style: index == _currentSentenceIndex
                              ? Theme.of(context).textTheme.bodyText1
                              : Theme.of(context).textTheme.bodyText2,
                        ),
                        itemScrollController: _itemScrollController,
                        itemPositionsListener: _itemPositionsListener,
                      ),
                    ),
                  ),
                )),
            Expanded(
              flex: 2,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: RepeatButton(
                      repeatNumber: currentRepeatNumber,
                      height: kAduioPlayerButtonHeight,
                      width: kAduioPlayerButtonWidth,
                      onPressed: _repeatOnPressed,
                      onLongPress: _repeatOnLongPressed,
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
                        onPressed: () => setState(() {
                          sst.listen();
                        }),
                        child:
                            Icon(sst.isListening ? Icons.mic : Icons.mic_none),
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: FloatingActionButton.small(
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
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    // MyButton(
                    //     height: kScreenHeight / 20,
                    //     width: kScreenWidth / 6,
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
                    //     height: kScreenHeight / 20,
                    //     width: kScreenWidth / 6,
                    //     iconData: Icons.arrow_upward,
                    //     onPressed: _speedUpOnPressed),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
