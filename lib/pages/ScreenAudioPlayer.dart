import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AudioPlayerOur extends StatefulWidget {
  const AudioPlayerOur({Key? key}) : super(key: key);

  @override
  State<AudioPlayerOur> createState() => _AudioPlayerOurState();
}

class _AudioPlayerOurState extends State<AudioPlayerOur> {
  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      child: Text("Audio Player page."),
    );
  }
}
