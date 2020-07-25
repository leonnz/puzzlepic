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
  }

  void setGridSize({bool useMobile}) {
    int columns;

    if (useMobile) {
      columns = 2;
    } else {
      columns = 3;
    }

    _gridSize = columns;
  }

  void setDeviceScreenHeight({double height}) {
    _deviceScreenHeight = height;
  }
}
