import 'package:flutter/cupertino.dart';
import 'package:audioplayers/audio_cache.dart';

class DeviceProvider extends ChangeNotifier {
  static bool _useMobileLayout;
  static int _gridSize;
  static double _deviceScreenHeight;
  static AudioCache _audioCache;

  bool get getUseMobileLayout => _useMobileLayout;
  int get getGridSize => _gridSize;
  double get getDeviceScreenHeight => _deviceScreenHeight;
  AudioCache get getAudioCache => _audioCache;

  void setUseMobileLayout({bool useMobileLayout}) {
    _useMobileLayout = useMobileLayout;
    if (useMobileLayout) {
      _gridSize = 2;
    } else {
      _gridSize = 3;
    }
  }

  void setDeviceScreenHeight({double height}) {
    _deviceScreenHeight = height;
  }

  void setAudioCache({AudioCache audioCache}) {
    _audioCache = audioCache;
    _audioCache.loadAll([
      'fast_click.wav',
      'image_piece_slide.wav',
      'play_button_click.wav',
    ]);
    _audioCache.disableLog();
  }
}
