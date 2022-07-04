import 'package:flutter/material.dart';
import 'package:memorizer/pages/info_page.dart';
import 'package:memorizer/services/stt_service.dart';
import 'package:memorizer/services/tts_service.dart';
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
  IconData playBtnIcon = Icons.play_arrow;
  late SttService sst;
  late TtsService tts;
  int chosenRepeatNumber = 1;
  int currentRepeatNumber = 1;
  bool repeatForAll = false;
  var playResult;

  @override
  void initState() {
    super.initState();
    tts = TtsService();
    tts.init();
    sst = SttService(
      next: _skipNextOnPressed,
      previous: _skipPreviousOnPressed,
      play: _playOnPressed,
      stop: stopPlaying,
      repeat: setRepeatNumber,
      error: incorrectCommand,
    );
  }

  void incorrectCommand() {
    setState(() {});
  }

  @override
  void dispose() {
    super.dispose();
    tts.destroy();
  }

  void setRepeatNumber(int enteredNumber, bool forAll) {
    repeatForAll = forAll;
    if (enteredNumber > 99) {
      chosenRepeatNumber = 99;
    } else {
      chosenRepeatNumber = enteredNumber;
    }
    currentRepeatNumber = chosenRepeatNumber;
    setState(() {});
  }

  void checkRepetitionsOption() {
    setState(() {
      if (repeatForAll) {
        currentRepeatNumber = chosenRepeatNumber;
      } else {
        currentRepeatNumber = 1;
        chosenRepeatNumber = 1;
      }
    });
  }

  Future continueToNextSentence() async {
    print('continuing to next');
    checkRepetitionsOption();

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

    // stop if it was playing before jumping
    if (wasPlaying) {
      var stopResult = await stopPlaying();
      print('stopped for jumping next with $stopResult');
    }

    // change index
    if (_currentSentenceIndex < widget.sentences.length - 1) {
      _currentSentenceIndex++;
    } else {
      await stopPlaying();
      _currentSentenceIndex = 0;
    }

    scrollToCurrentSentence();

    // play if it was playing before jumping
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
    } else if (_currentSentenceIndex == 0) {
      _currentSentenceIndex = widget.sentences.length - 1;
    }
    scrollToCurrentSentence();
    if (wasPlaying) {
      await playCurrentSentence();
    }
  }

  Future playCurrentSentence() async {
    // print(
    //     'playing: ${widget.sentences[_currentSentenceIndex].substring(0, 10)}');

    scrollToCurrentSentence();
    playResult = await tts.play(widget.sentences[_currentSentenceIndex]);
    while (playResult == 0) {
      playResult = await tts.play(widget.sentences[_currentSentenceIndex]);
    }

    // print(
    //     'play result for "${widget.sentences[_currentSentenceIndex].substring(0, 10)}" is ${playResult.toString()}');
    // print('current repeat number is $currentRepeatNumber');
    setState(() {});
    if (currentRepeatNumber != 1) {
      currentRepeatNumber--;
      playCurrentSentence();
    } else {
      if (playResult == 1) await continueToNextSentence();
    }
  }

  Future stopPlaying() async {
    var res = await tts.stop();
    setState(() {});
    return res;
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

  void _skipPreviousOnPressed() async {
    checkRepetitionsOption();

    await jumpToPreviousSentence();

    setState(() {});
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
    checkRepetitionsOption();

    await jumpToNextSentence();

    setState(() {});
  }

  void _repeatOnPressed() {
    if (chosenRepeatNumber != 1) {
      setState(() {
        chosenRepeatNumber = 1;
        repeatForAll = false;
      });
    } else {
      setState(() {
        chosenRepeatNumber = -1;
        repeatForAll = true;
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
              // setter(() {
              //   repeatForAll = false;
              // });
              return AlertDialog(
                title: Text(
                  "Please specify the number of repetitions",
                  style: TextStyle(fontSize: 12.sp),
                ),
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
                              // print(
                              //     'entered number on cb changed = $enteredNumber');
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
                        setRepeatNumber(enteredNumber!, repeatForAll);
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
        appBar: MyAppBar(context: context, input: "AUDIO PLAYER", actions: [])
            .get(),
        body: Column(
          children: [
            Expanded(
                flex: 10,
                child: Padding(
                  padding: EdgeInsets.all(12.sp),
                  child: Container(
                    //padding:
                    //const EdgeInsets.symmetric(horizontal: 2, vertical: 10),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.secondary,
                      borderRadius: BorderRadius.circular(8),
                      shape: BoxShape.rectangle,
                      border:
                          Border.all(color: Theme.of(context).selectedRowColor),
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(20.sp),
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
              child: Padding(
                padding: EdgeInsets.all(12.sp),
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
                          child: Icon(
                              sst.isListening ? Icons.mic : Icons.mic_none),
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
                            backgroundColor: Colors.transparent,
                            isScrollControlled: true,
                            builder: (BuildContext context) {
                              return InfoPage();
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
