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
    if (orientation == Orientation.portrait && getUseMobileLayout) {
      columns = 2;
    } else if (orientation == Orientation.portrait && !getUseMobileLayout) {
      columns = 3;
    } else {
      columns = 4;
    }

    _gridSize = columns;
  }
}
