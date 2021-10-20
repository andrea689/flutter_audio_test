// ignore_for_file: avoid_print

import 'dart:io';
import 'dart:math';
import 'package:audio_test/wav_utils.dart';
import 'package:collection/collection.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  Function eq = const ListEquality().equals;
  const path = './test/wav';
  //final id = 'burst_2303_20210928_190313'; // 15002 - 30044
  const id = 'burst_2394_20211006_130618'; // 15002 - 30044

  test('test asd', () async {
    print('CIao');

    //await convert(0);
    //await convert(2000);
    //await convert(3166);
    //await convert(3489);
    //await convert(3581);
    //await convert(3583);
  });

  test('Convert filtered data 44100 to wav', () async {
    final data = await readData('$path/${id}_filtered_44100.txt', ',');
    print(data.length);
    print(data.sublist(100, 110));
    //await writeWav('$path/${id}_out.wav', data);

    final maxValue = data.reduce((value, element) =>
        element.abs() > value.abs() ? element.abs() : value.abs());
    print(maxValue);
    //final scaled = data.map((e) => (e / maxValue * 32767).toInt()).toList();
    // 16-bit PCM             -32768       +32767       int16
    //final scaled =
    //    data.map((e) => ((e / maxValue * 128) + 128).toInt()).toList();

    //final scaled = data.map((e) => ((e / maxValue * 32767)).toInt()).toList();
    //print(scaled.length);
    //print(scaled.sublist(100, 110));
    await writeWav('$path/${id}_scaled_44100.wav', data, 44100, stereo: false);

    final wavIn2 = File('$path/${id}_scaled_44100.wav');
    final wavInBytes2 = await wavIn2.readAsBytes();
    print(wavInBytes2.length);
    print(wavInBytes2.sublist(100, 110));

    final wavIn = File('$path/${id}_lambda_44100.wav');
    final wavInBytes = await wavIn.readAsBytes();
    print(wavInBytes.length);
    print(wavInBytes.sublist(100, 110));

    print(eq(wavInBytes, wavInBytes2));
  });

  test('Convert filtered data 2850 to wav', () async {
    final data2 = await readData('$path/${id}_raw.txt', '\n');
    print(data2.length);
    print(data2.sublist(100, 110));

    final data = await readData('$path/${id}_filtered.txt', '\n');
    print(data.length);
    print(data.sublist(100, 110));
    //await writeWav('$path/${id}_out.wav', data);

    // 16-bit PCM             -32768       +32767       int16
    //final scaled =
    //    data.map((e) => ((e / maxValue * 128) + 128).toInt()).toList();
    //final scaled = data.map((e) => ((e / maxValue * 32767)).toInt()).toList();
    //print(scaled.length);
    //print(scaled.sublist(100, 110));

    await writeWav('$path/${id}_scaled.wav', data, 2850, stereo: false);

    final wavIn2 = File('$path/${id}_scaled.wav');
    final wavInBytes2 = await wavIn2.readAsBytes();
    print(wavInBytes2.length);
    print(wavInBytes2.sublist(100, 110));

    final wavIn = File('$path/${id}_lambda.wav');
    final wavInBytes = await wavIn.readAsBytes();
    print(wavInBytes.length);
    print(wavInBytes.sublist(100, 110));

    print(eq(wavInBytes, wavInBytes2));
  });

  test('Others', () async {
    //print('Ciaone!');
    //final wavIn = File('./test/wav/Burst_2303_20210928_190313_lambda.wav');
    //final wavInBytes = await wavIn.readAsBytes();
    //print(wavInBytes.length);
  });

  test('Test if lambda audio is Mono or Stereo', () async {
    print('Read original wav file');
    final wavIn = File('$path/${id}_lambda.wav');
    final wavInBytes = await wavIn.readAsBytes();

    print('Write stereo version');
    await writeWav('$path/${id}_test_stereo.wav', wavInBytes, 2850,
        stereo: true);

    print('Write mono version');
    await writeWav('$path/${id}_test_mono.wav', wavInBytes, 2850,
        stereo: false);

    print('Test if stereo version is equals to original version');
    final wavInStereo = File('$path/${id}_test_stereo.wav');
    final wavInBytesStereo = await wavInStereo.readAsBytes();
    print('Stereo - equals: ${eq(wavInBytes, wavInBytesStereo)}');

    print('Test if mono version is equals to original version');
    final wavInMono = File('$path/${id}_test_mono.wav');
    final wavInBytesMono = await wavInMono.readAsBytes();
    print('Mono - equals: ${eq(wavInBytes, wavInBytesMono)}');
  });
}

Future<List<int>> readData(String filename, String separator) async {
  final fileIn = File(filename);
  final contents = await fileIn.readAsString();

  final data = contents
      .split(separator)
      .map((e) => double.tryParse(e) ?? 0)
      .map((e) => e.round())
      .toList();

  return data;
}

Future<void> writeWav(String filename, List<num> data, int frequency,
    {bool? stereo = false}) async {
  final fileOut = File(filename);
  await fileOut.create();

  final bytes = WavUtils.getBytes(data, frequency);

  await fileOut.writeAsBytes(bytes);
}

Future<void> convert(int spectrumId) async {
  final sampleSize = pow(2, 16) - 1;
  final byteSize = pow(2, 8) - 1;
  print('sampleSize $sampleSize');
  print('byteSize $byteSize');

  final fileIn = File('./t_in_$spectrumId.txt');
  final contents = await fileIn.readAsString();
  final arr = contents.split(',').map((e) => double.tryParse(e) ?? 0).toList();
  final maxValue = maxBy(arr, (a) => a) ?? 1;
  print(maxValue);
  //final maxDestinationValue = 255; //32767;
  final scaled = arr.map((e) => (e / maxValue * 32767).round()).toList();
  //final scaled = arr.map((e) => (e / sampleSize * byteSize).round()).toList();
  //final scaled = arr.map((e) => (e).round()).toList();
  final maxValue2 = maxBy(scaled, (a) => a) ?? 1;
  print(maxValue2);

  final wavInBytes = await fileIn.readAsBytes();
  print(wavInBytes);

  //final wavIn = File('./test_in_8k.wav');
  //final wavInBytes = await wavIn.readAsBytes();
  final maxValue3 = maxBy(wavInBytes, (a) => a) ?? 1;
  print(maxValue3);

  await writeWav('./t_out_$spectrumId.wav', scaled, 2850);
}
