import 'dart:convert';
import 'dart:typed_data';

import 'package:audio_test/audio_player/audio_player_utils.dart';
import 'package:audio_test/wav_2850.dart';
import 'package:audio_test/wav_44100.dart';
import 'package:audio_test/wav_utils.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({Key? key}) : super(key: key);

  final client = http.Client();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ElevatedButton(
                onPressed: () async {
                  AudioPlayer audioPlayer = AudioPlayer();
                  await audioPlayer.play(
                      'https://github.com/andrea689/flutter_audio_test/blob/main/burst_2394_20211006_130618_lambda.wav?raw=true');
                },
                child: const Text('Play Net 2850'),
              ),
              ElevatedButton(
                onPressed: () async {
                  AudioPlayer audioPlayer = AudioPlayer();
                  await audioPlayer.play(
                      'https://github.com/andrea689/flutter_audio_test/blob/main/burst_2394_20211006_130618_lambda_44100.wav?raw=true');
                },
                child: const Text('Play Net 44100'),
              ),
              ElevatedButton(
                onPressed: () async {
                  AudioPlayer player = AudioPlayer();

                  final bytes = WavUtils.getBytes(filteredData, 2850);

                  AudioPlayerUtils.playBytes(player, bytes);
                },
                child: const Text('Play Lib1 2850'),
              ),
              ElevatedButton(
                onPressed: () async {
                  AudioPlayer player = AudioPlayer();

                  final bytes = WavUtils.getBytes(filteredData44100, 44100);

                  AudioPlayerUtils.playBytes(player, bytes);
                },
                child: const Text('Play Lib1 44100'),
              ),
              ElevatedButton(
                onPressed: () async {
                  AudioPlayer player = AudioPlayer();

                  final res =
                      await client.get(Uri.parse('http://192.168.1.17:8080/'));
                  final obj = jsonDecode(res.body);
                  final bytes = List<int>.from(obj['wav_bytes']);

                  AudioPlayerUtils.playBytes(player, bytes);
                },
                child: const Text('Play Lib1 44100 Local Webserver'),
              ),
              const TestSound(),
              const TestSound2(),
              const TestSound3(),
            ],
          ),
        ),
      ),
    );
  }
}

class TestSound extends StatefulWidget {
  const TestSound({
    Key? key,
  }) : super(key: key);

  @override
  State<TestSound> createState() => _TestSoundState();
}

class _TestSoundState extends State<TestSound> {
  final FlutterSoundPlayer _myPlayer = FlutterSoundPlayer();
  bool _mPlayerIsInited = false;

  @override
  void initState() {
    super.initState();
    // Be careful : openAudioSession return a Future.
    // Do not access your FlutterSoundPlayer or FlutterSoundRecorder before the completion of the Future
    _myPlayer.openAudioSession().then((value) {
      setState(() {
        _mPlayerIsInited = true;
      });
    });
  }

  @override
  void dispose() {
    // Be careful : you must `close` the audio session when you have finished with it.
    _myPlayer.closeAudioSession();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () async {
        if (!_mPlayerIsInited) {
          return;
        }

        final bytes = WavUtils.getBytes(filteredData, 2850);

        _myPlayer.startPlayer(
          fromDataBuffer: Uint8List.fromList(bytes),
        );
      },
      child: const Text('Play Lib2 2850'),
    );
  }
}

class TestSound2 extends StatefulWidget {
  const TestSound2({
    Key? key,
  }) : super(key: key);

  @override
  State<TestSound2> createState() => _TestSound2State();
}

class _TestSound2State extends State<TestSound2> {
  final FlutterSoundPlayer _myPlayer = FlutterSoundPlayer();
  bool _mPlayerIsInited = false;

  @override
  void initState() {
    super.initState();
    // Be careful : openAudioSession return a Future.
    // Do not access your FlutterSoundPlayer or FlutterSoundRecorder before the completion of the Future
    _myPlayer.openAudioSession().then((value) {
      setState(() {
        _mPlayerIsInited = true;
      });
    });
  }

  @override
  void dispose() {
    // Be careful : you must `close` the audio session when you have finished with it.
    _myPlayer.closeAudioSession();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () async {
        if (!_mPlayerIsInited) {
          return;
        }

        final bytes = WavUtils.getBytes(filteredData44100, 44100);

        _myPlayer.startPlayer(
          fromDataBuffer: Uint8List.fromList(bytes),
        );
      },
      child: const Text('Play Lib2 44100'),
    );
  }
}

class TestSound3 extends StatefulWidget {
  const TestSound3({
    Key? key,
  }) : super(key: key);

  @override
  State<TestSound3> createState() => _TestSound3State();
}

class _TestSound3State extends State<TestSound3> {
  final FlutterSoundPlayer _myPlayer = FlutterSoundPlayer();
  bool _mPlayerIsInited = false;
  final client = http.Client();

  @override
  void initState() {
    super.initState();
    // Be careful : openAudioSession return a Future.
    // Do not access your FlutterSoundPlayer or FlutterSoundRecorder before the completion of the Future
    _myPlayer.openAudioSession().then((value) {
      setState(() {
        _mPlayerIsInited = true;
      });
    });
  }

  @override
  void dispose() {
    // Be careful : you must `close` the audio session when you have finished with it.
    _myPlayer.closeAudioSession();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () async {
        if (!_mPlayerIsInited) {
          return;
        }

        final res = await client.get(Uri.parse('http://192.168.1.17:8080/'));
        final obj = jsonDecode(res.body);
        final bytes = List<int>.from(obj['wav_bytes']);

        _myPlayer.startPlayer(
          fromDataBuffer: Uint8List.fromList(bytes),
        );
      },
      child: const Text('Play Lib2 44100 Local Webserver'),
    );
  }
}
