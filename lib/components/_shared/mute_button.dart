import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/device_provider.dart';
import '../../styles/box_decoration_styes.dart';

class MuteButton extends StatelessWidget {
  const MuteButton({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final DeviceProvider deviceProvider = Provider.of<DeviceProvider>(context);

    return GestureDetector(
      onTap: () {
        deviceProvider.setMuteSounds();
      },
      child: Padding(
        padding: const EdgeInsets.only(top: 20, right: 20),
        child: Align(
          alignment: Alignment.topRight,
          child: Container(
            padding: const EdgeInsets.all(5),
            // decoration: CustomElementTheme.muteButtonBoxDecoration(),
            decoration: kMuteButtonBoxDecoration,
            child: Icon(
              deviceProvider.getMuteSounds ? Icons.volume_off : Icons.volume_mute,
              size: deviceProvider.getUseMobileLayout ? 35 : 50,
              color: Colors.purple[200],
            ),
          ),
        ),
      ),
    );
  }
}
