import 'dart:typed_data';
import 'package:convert/convert.dart';

/// Ho preso spunto da https://github.com/modulovalue/flutter_audio_wav_demo
/// Questo progetto usa la libreria [bird] che non è più presente su GitHub
/// quindi ho dovuto scaricare l'ultima versione da pub.dev
class WavUtils {
  static const int _channels = 1;
  static const int _bytesPerSample = 2;

  /// 16-bit PCM
  static List<int> getBytes(List<num> samples, int frequency) {
    final maxValue = samples.map((e) => e.toInt()).reduce((value, element) =>
        element.abs() > value.abs() ? element.abs() : value.abs());

    /// amplify all samplas to max value 32767
    /// use signed 2's complement [toUnsigned(16)] https://qr.ae/pGVZeM
    final converted = samples
        .map((e) => (e / maxValue * 32767).toInt().toUnsigned(16))
        .toList();

    return _getBytes(converted, frequency);
  }

  static Uint16List _getBytes(List<int> data, int frequency) {
    final _data = StringBuffer();
    // PCM Data
    // --------------------------------------------
    // Field           | Bytes | Content
    // --------------------------------------------
    // ckID            |     4 | "fmt "
    // cksize          |     4 | 0x0000010 (16)
    // wFormatTag      |     2 | 0x0001 (PCM)
    // nChannels       |     2 | NCH
    // nSamplesPerSec  |     4 | SPS
    // nAvgBytesPerSec |     4 | NCH * BPS * SPS
    // nBlockAlign     |     2 | NCH * BPS * NCH
    // wBitsPerSample  |     2 | BPS * 8
    //
    // data_size = DUR * NCH * SPS * BPS
    // file_size = 44 (Header) + data_size
    const headerSize = 44;
    final dataSize = (data.length * _channels * _bytesPerSample).floor();
    final fileSize = dataSize + headerSize;
    _data.write("RIFF" + _put(fileSize.floor(), 4) + "WAVEfmt " + _put(16, 4));
    _data.write(_put(1, 2)); // wFormatTag (pcm)
    _data.write(_put(_channels, 2)); // nChannels
    _data.write(_put(frequency, 4)); // nSamplesPerSec
    _data.write(
        _put(_channels * _bytesPerSample * frequency, 4)); // nAvgBytesPerSec
    _data.write(_put(_channels * _bytesPerSample, 2)); // nBlockAlign
    _data.write(_put(_bytesPerSample * 8, 2)); // wBitsPerSample
    _data.write("data" + _put(dataSize.floor(), 4));

    for (var val in data) {
      _data.write(_put(val, _bytesPerSample));
    }

    return Uint16List.fromList(_data.toString().codeUnits);
  }

  static String _put(int n, int l) {
    final _n = n.toRadixString(16);
    final __n = List<String>.filled(l * 2 - _n.length, "0").join() + _n;
    return String.fromCharCodes(hex.decode(__n).reversed.toList());
  }
}
