import 'package:audioplayers/audioplayers.dart';

import 'audio_player_stub.dart'
    if (dart.library.io) 'audio_player_mobile.dart'
    if (dart.library.js) 'audio_player_web.dart';

class AudioPlayerUtils {
  static Future<void> playBytes(AudioPlayer player, List<int> bytes) =>
      play(player, bytes);
}
