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

  void setGridSize({bool useMobile, Orientation orientation}) {
    int columns;

    if (useMobile) {
      if (orientation == Orientation.portrait) {
        columns = 2;
      } else {
        columns = 3;
      }
    } else {
      if (orientation == Orientation.portrait) {
        columns = 3;
      } else {
        columns = 4;
      }
    }

    _gridSize = columns;
  }

  void setDeviceHeight({double height}) {
    _deviceHeight = height;
  }
}
