import 'package:flutter/material.dart';
import '../screens/puzzle_screen.dart';

class ImageButton extends StatelessWidget {
  const ImageButton({
    Key key,
    this.assetName,
    this.readableName,
    this.categoryName,
    this.complete,
  }) : super(key: key);

  final String categoryName;
  final String assetName;
  final String readableName;
  final bool complete;

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
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        elevation: 3,
        borderOnForeground: true,
        child: Stack(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image(
                image: AssetImage('assets/images/$categoryName/$assetName.png'),
              ),
            ),
            complete ? Icon(Icons.check) : Icon(Icons.golf_course),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                height: 50,
                width: double.infinity,
                decoration: BoxDecoration(
                    color: Color.fromRGBO(255, 255, 255, 0.80),
                    borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(10),
                        bottomRight: Radius.circular(10))),
                child: Center(
                  child: Text(
                    readableName,
                    style: Theme.of(context).textTheme.headline2,
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
