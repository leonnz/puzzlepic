import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/device_provider.dart';
import '../../styles/custom_styles.dart';

class PurchaseAlert extends StatelessWidget {
  const PurchaseAlert({
    Key key,
    this.title,
    this.message,
  }) : super(key: key);

  final String title;
  final String message;

  @override
  Widget build(BuildContext context) {
    final DeviceProvider deviceProvider = Provider.of<DeviceProvider>(context);

    return AlertDialog(
      title: Text(
        title,
        textAlign: TextAlign.center,
        style: CustomTextTheme.puzzleScreenCompleteAlertTitle(),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Container(
            padding: const EdgeInsets.only(
              bottom: 40,
            ),
            width: deviceProvider.getUseMobileLayout ? null : 300,
            child: Text(
              message,
              textAlign: TextAlign.center,
              style: CustomTextTheme.puzzleScreenCompleteAlertContent(),
            ),
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              FlatButton(
                textColor: const Color(0xff501E5D),
                onPressed: () {
                  Navigator.pop(context, true);
                },
                child: Text(
                  'Close',
                  style: CustomTextTheme.puzzleScreenCompleteAlertButtonText(),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
