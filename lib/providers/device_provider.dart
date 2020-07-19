import 'package:flutter/cupertino.dart';

class DeviceProvider extends ChangeNotifier {
  static bool _useMobileLayout;
  static int _gridSize;
  static double _deviceHeight;

  bool get getUseMobileLayout => _useMobileLayout;
  int get getGridSize => _gridSize;
  double get getDeviceHeight => _deviceHeight;

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

  void setDeviceHeight({double height}) {
    _deviceHeight = height;
  }
}
