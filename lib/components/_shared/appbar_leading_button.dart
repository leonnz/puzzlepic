import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/device_provider.dart';

class AppBarLeadingButton extends StatelessWidget {
  const AppBarLeadingButton({
    Key key,
    @required this.icon,
    this.customOperation,
  }) : super(key: key);

  final IconData icon;
  final Function customOperation;

  @override
  Widget build(BuildContext context) {
    final DeviceProvider deviceProvider = Provider.of<DeviceProvider>(context, listen: false);

    return Align(
      alignment: Alignment.centerLeft,
      child: IconButton(
        padding: EdgeInsets.all(DeviceProvider.shortestSide / 45),
        iconSize: DeviceProvider.shortestSide / 15,
        icon: Icon(icon),
        onPressed: () {
          deviceProvider.playSound(sound: 'fast_click.wav');
          Navigator.pop(context, true);
          if (customOperation != null) {
            customOperation();
          }
        },
      ),
    );
  }
}
