import 'package:flutter/cupertino.dart';
import 'package:audioplayers/audio_cache.dart';
import 'package:audioplayers/audioplayers.dart';

class DeviceProvider extends ChangeNotifier {
  static bool _useMobileLayout;
  static bool _muteSounds = false;
  static int _gridSize;
  static double _deviceScreenHeight;
  static AudioCache _audioCache;

  bool get getUseMobileLayout => _useMobileLayout;
  bool get getMuteSounds => _muteSounds;
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

  void setMuteSounds() {
    _muteSounds = !_muteSounds;
    if (!_muteSounds) {
      playSound(sound: 'fast_click.wav');
    }
    notifyListeners();
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

  void playSound({String sound}) {
    if (!getMuteSounds) {
      _audioCache.play(
        sound,
        mode: PlayerMode.LOW_LATENCY,
      );
    }
  }
}
