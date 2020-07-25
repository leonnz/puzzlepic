import 'package:flutter/cupertino.dart';

class DeviceProvider extends ChangeNotifier {
  static bool _useMobileLayout;
  static int _gridSize;
  static double _deviceScreenHeight;

  bool get getUseMobileLayout => _useMobileLayout;
  int get getGridSize => _gridSize;
  double get getDeviceScreenHeight => _deviceScreenHeight;

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
}
