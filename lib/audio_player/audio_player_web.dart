// ignore_for_file: avoid_web_libraries_in_flutter

import 'dart:js' as js;
import 'dart:typed_data';

import 'package:audioplayers/audioplayers.dart';

Future<void> play(AudioPlayer player, List<int> bytes) async {
  js.context.callMethod("playByteArray", <dynamic>[Uint8List.fromList(bytes)]);
}
