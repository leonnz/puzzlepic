import 'package:flutter/material.dart';

class PuzzleCompleteAlert extends StatelessWidget {
  const PuzzleCompleteAlert({Key key, this.readableName}) : super(key: key);

  final String readableName;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Center(child: Text('Congratulations!')),
      content: Container(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text('You completed $readableName.'),
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
