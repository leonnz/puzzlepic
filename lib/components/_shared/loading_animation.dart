import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import '../../providers/device_provider.dart';

class LoadingAnimation extends StatelessWidget {
  const LoadingAnimation({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Center(
        child: SpinKitFadingFour(
          color: Colors.purple,
          size: DeviceProvider.shortestSide / 7,
        ),
      ),
    );
  }
}
