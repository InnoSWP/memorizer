import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:memorizer/settings/appColors.dart';

class AudioPlayerOur extends StatefulWidget {
  const AudioPlayerOur({Key? key}) : super(key: key);

  @override
  State<AudioPlayerOur> createState() => _AudioPlayerOurState();
}

class _AudioPlayerOurState extends State<AudioPlayerOur> {
  List<String> s = [
    'aba',
    'aboba',
    'weerwr',
    'dfgrhtg',
    'drftghftyju',
    'drgtdrthftyh',
  ];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          Expanded(
            flex: 10,
            child: Container(
              decoration: BoxDecoration(
                gradient: kDarkGradientBackground,
              ),
              child: ListView(
                children: s
                    .map((e) => Text(
                          e,
                          style: kTextStyleMain,
                        ))
                    .toList(),
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextButton(
                  onPressed: () {},
                  child: Icon(Icons.mic),
                ),
                TextButton(
                  onPressed: () {},
                  child: Icon(Icons.info_outlined),
                ),
              ],
            ),
          ),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                gradient: kDarkGradientBackground,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  TextButton(
                    onPressed: () {},
                    child: Icon(Icons.repeat),
                  ),
                  TextButton(
                    onPressed: () {},
                    child: Icon(Icons.skip_previous),
                  ),
                  TextButton(
                    onPressed: () {},
                    child: Icon(Icons.play_arrow_outlined),
                  ),
                  TextButton(
                    onPressed: () {},
                    child: Icon(Icons.skip_next),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
