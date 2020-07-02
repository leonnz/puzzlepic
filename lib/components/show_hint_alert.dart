import 'package:flutter/material.dart';

class HintAlert extends StatelessWidget {
  const HintAlert({
    Key key,
    this.category,
    this.assetName,
  }) : super(key: key);

  final String category;
  final String assetName;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Container(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Image(
              image: AssetImage('assets/images/$category/$assetName.png'),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  margin: EdgeInsets.all(20.0),
                  child: RaisedButton(
                    color: Colors.red,
                    child: Text("Close"),
                    onPressed: () => Navigator.pop(context),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
