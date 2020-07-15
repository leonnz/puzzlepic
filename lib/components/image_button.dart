import 'package:flutter/material.dart';

class ImageButton extends StatelessWidget {
  const ImageButton({
    Key key,
    this.assetName,
    this.readableName,
    this.categoryName,
    this.complete,
    this.imgNumber,
  }) : super(key: key);

  final int imgNumber;
  final String categoryName;
  final String assetName;
  final String readableName;
  final bool complete;

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
          side: BorderSide(width: 2, color: Colors.white)),
      elevation: 5,
      child: Stack(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Image(
              image: AssetImage(
                  'assets/images/$categoryName/${assetName}_full.jpg'),
            ),
          ),
          Align(
            alignment: Alignment.topRight,
            child: complete
                ? Icon(
                    Icons.check,
                    color: Colors.lightGreenAccent[400],
                    size: 40,
                  )
                : null,
          ),
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
    );
  }
}
