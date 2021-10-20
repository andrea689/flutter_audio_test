import 'dart:io';

import 'package:audioplayers/audioplayers.dart';
import 'package:path_provider/path_provider.dart';

Future<void> play(AudioPlayer player, List<int> bytes) async {
  final dir = (await getTemporaryDirectory()).path;
  final filePath = '$dir/TEST.wav';

  await (File(filePath)).writeAsBytes(bytes, flush: true);

  player.play(filePath);
}
