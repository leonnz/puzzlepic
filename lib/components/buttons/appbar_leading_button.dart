import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/device_provider.dart';

class AppBarLeadingButton extends StatelessWidget {
  const AppBarLeadingButton({
    Key key,
    this.icon,
  }) : super(key: key);

  final IconData icon;

  @override
  Widget build(BuildContext context) {
    DeviceProvider deviceProvider = Provider.of<DeviceProvider>(context);

    return Align(
      alignment: Alignment.centerLeft,
      child: IconButton(
        iconSize: deviceProvider.getUseMobileLayout ? 25 : 50,
        icon: Icon(icon),
        onPressed: () {
          deviceProvider.playSound(sound: 'fast_click.wav');
          Navigator.pop(context, true);
        },
      ),
    );
  }
}
