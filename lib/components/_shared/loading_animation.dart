import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';

import '../../providers/device_provider.dart';

class LoadingAnimation extends StatelessWidget {
  const LoadingAnimation({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final DeviceProvider deviceProvider = Provider.of<DeviceProvider>(context, listen: false);

    return Container(
      color: Colors.white,
      child: Center(
        child: SpinKitFadingFour(
          color: Colors.purple,
          size: deviceProvider.getUseMobileLayout ? 50 : 80,
        ),
      ),
    );
  }
}
