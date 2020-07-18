import 'package:flutter/cupertino.dart';

class DeviceProvider extends ChangeNotifier {
  static bool _useMobileLayout;
  static Orientation _orientation;

  bool get getUseMobileLayout => _useMobileLayout;
  Orientation get getOrientation => _orientation;

  void setUseMobileLayout({bool useMobileLayout}) {
    _useMobileLayout = useMobileLayout;
    notifyListeners();
  }

  void setOrientation({Orientation orientation}) {
    _orientation = orientation;
    notifyListeners();
  }
}
