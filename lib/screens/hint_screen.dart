import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/device_provider.dart';

class HintScreen extends StatelessWidget {
  const HintScreen({
    Key key,
    @required this.category,
    @required this.imageAssetname,
  }) : super(key: key);

  final String category;
  final String imageAssetname;

  @override
  Widget build(BuildContext context) {
    final DeviceProvider deviceProvider = Provider.of<DeviceProvider>(context, listen: false);

    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.black,
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image(
              image: AssetImage('assets/images/$category/${imageAssetname}_full.jpg'),
            ),
            IconButton(
              icon: Icon(
                Icons.cancel,
                color: Colors.white,
                size: DeviceProvider.shortestSide / 11.5,
              ),
              onPressed: () {
                deviceProvider.playSound(sound: 'fast_click.wav');
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }
}
