import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../providers/device_provider.dart';
import '../../styles/box_decoration_styes.dart';

class MuteButton extends StatefulWidget {
  const MuteButton({Key key}) : super(key: key);

  @override
  _MuteButtonState createState() => _MuteButtonState();
}

class _MuteButtonState extends State<MuteButton> {
  Future<void> setMutePref({@required bool mute}) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('mute', mute);
  }

  Future<void> getMutePref() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final DeviceProvider deviceProvider = Provider.of<DeviceProvider>(context, listen: false);

    if (prefs.getBool('mute')) {
      deviceProvider.setMuteSounds();
    }
  }

  @override
  void initState() {
    getMutePref();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final DeviceProvider deviceProvider = Provider.of<DeviceProvider>(context);

    return GestureDetector(
      onTap: () {
        deviceProvider.setMuteSounds();
        setMutePref(mute: deviceProvider.getMuteSounds);
      },
      child: Padding(
        padding: const EdgeInsets.only(top: 20, right: 20),
        child: Align(
          alignment: Alignment.topRight,
          child: Container(
            padding: const EdgeInsets.all(5),
            decoration: kMuteButtonBoxDecoration,
            child: Icon(
              deviceProvider.getMuteSounds ? Icons.volume_off : Icons.volume_mute,
              size: DeviceProvider.shortestSide / 12,
              color: Colors.purple[200],
            ),
          ),
        ),
      ),
    );
  }
}
