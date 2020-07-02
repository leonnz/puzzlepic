import 'package:flutter/material.dart';
import '../screens/game_screen.dart';

class ImageButton extends StatelessWidget {
  const ImageButton(
      {Key key, this.assetName, this.readableName, this.categoryName})
      : super(key: key);

  final String categoryName;
  final String assetName;
  final String readableName;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => GameScreen(
            category: categoryName,
            assetName: assetName,
            readableName: readableName,
          ),
        ),
      ),
      child: Card(
        elevation: 3,
        borderOnForeground: true,
        child: Stack(
          children: [
            Image(
              image: AssetImage('assets/images/$categoryName/$assetName.png'),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                height: 50,
                width: double.infinity,
                decoration:
                    BoxDecoration(color: Color.fromRGBO(255, 255, 255, 0.90)),
                child: Center(
                  child: Text(
                    readableName,
                    style: TextStyle(
                      fontSize: 25.0,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
