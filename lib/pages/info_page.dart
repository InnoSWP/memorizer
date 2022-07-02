import 'package:flutter/material.dart';
import 'package:memorizer/settings/constants.dart' as clr;
import 'package:memorizer/widgets/buttons.dart';
import 'package:sizer/sizer.dart';

class InfoPage extends StatelessWidget {
  const InfoPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double kAduioPlayerButtonHeight = 6.h;
    double kAduioPlayerButtonWidth = 16.w;
    return SafeArea(
      child: Container(
        padding: EdgeInsets.only(bottom: 150),
        child: Scaffold(
          body: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Row(
                children: [
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 10),
                    child: FloatingActionButton(
                      heroTag: 'micro info',
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
                      onPressed: () {},
                      child: Icon(Icons.mic),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      'Tap microphone to start a voice command',
                      style: clr.kTextStyleDefault,
                    ),
                  ),
                ],
              ),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 10),
                child: Align(
                  alignment: Alignment.topLeft,
                  child: Text(
                      'Current voice commands:\n\u2022 Play!\n\u2022 Stop!\n\u2022 Repeat!\n\u2022 Next!\n\u2022 Previous!',
                      style: clr.kTextStyleDefault),
                ),
              ),
              Row(
                children: [
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 10),
                    child: MyButton(
                        height: kAduioPlayerButtonHeight,
                        width: kAduioPlayerButtonWidth,
                        iconData: Icons.skip_previous,
                        onPressed: () {}),
                  ),
                  Expanded(
                    child: Text('Tap to go to the previous sentence',
                        style: clr.kTextStyleDefault),
                  ),
                ],
              ),
              Row(
                children: [
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 10),
                    child: MyButton(
                        height: kAduioPlayerButtonHeight,
                        width: kAduioPlayerButtonWidth,
                        iconData: Icons.play_arrow,
                        onPressed: () {}),
                  ),
                  Expanded(
                    child: Text('Tap to start memorizing, tap once more to stop',
                        style: clr.kTextStyleDefault),
                  ),
                ],
              ),
              Row(
                children: [
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 10),
                    child: MyButton(
                        height: kAduioPlayerButtonHeight,
                        width: kAduioPlayerButtonWidth,
                        iconData: Icons.skip_next,
                        onPressed: () {}),
                  ),
                  Expanded(
                    child: Text('Tap to go to the next sentence',
                        style: clr.kTextStyleDefault),
                  ),
                ],
              ),
              Row(
                children: [
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 10),
                    child: MyButton(
                      height: kAduioPlayerButtonHeight,
                      width: kAduioPlayerButtonWidth,
                      onPressed: () {},
                      iconData: Icons.repeat,
                      iconColor: Colors.white,
                    ),
                  ),
                  Expanded(
                    child: Text('Tap to repeat the current sentence',
                        style: clr.kTextStyleDefault),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
