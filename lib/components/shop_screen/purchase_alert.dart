import 'package:flutter/material.dart';

import '../../providers/device_provider.dart';
import '../../styles/text_styles.dart';

class PurchaseAlert extends StatelessWidget {
  const PurchaseAlert({
    Key key,
    @required this.title,
    @required this.message,
  }) : super(key: key);

  final String title;
  final String message;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        title,
        textAlign: TextAlign.center,
        style: kPuzzleScreenCompleteAlertTitle,
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Container(
            padding: const EdgeInsets.only(
              bottom: 40,
            ),
            width: DeviceProvider.shortestSide / 2.3,
            child: Text(
              message,
              textAlign: TextAlign.center,
              style: kPuzzleScreenCompleteAlertContent,
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              FlatButton(
                textColor: const Color(0xff501E5D),
                onPressed: () {
                  Navigator.pop(context, true);
                },
                child: Text(
                  'Close',
                  style: kPuzzleScreenCompleteAlertButtonText,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
