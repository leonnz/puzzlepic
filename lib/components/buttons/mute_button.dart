import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/device_provider.dart';

class MuteButton extends StatelessWidget {
  const MuteButton({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    DeviceProvider deviceProvider = Provider.of<DeviceProvider>(context);

    return GestureDetector(
      onTap: () {
        deviceProvider.setMuteSounds();
      },
      child: Padding(
        padding: const EdgeInsets.only(top: 20, right: 20),
        child: Align(
          alignment: Alignment.topRight,
          child: Container(
            padding: EdgeInsets.all(5),
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(100),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black45,
                    blurRadius: 4,
                    offset: Offset(1, 1),
                  )
                ]),
            child: Icon(
              deviceProvider.getMuteSounds
                  ? Icons.volume_off
                  : Icons.volume_mute,
              size: 50,
              color: Colors.black45,
            ),
          ),
        ),
      ),
    );
  }
}
