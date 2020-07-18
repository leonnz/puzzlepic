import 'package:flutter/cupertino.dart';

class DeviceProvider extends ChangeNotifier {
  static bool _useMobileLayout;
  static int _gridSize;

  bool get getUseMobileLayout => _useMobileLayout;
  int get getGridSize => _gridSize;

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
}
