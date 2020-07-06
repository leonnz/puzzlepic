import 'package:flutter/material.dart';

class HintScreen extends StatelessWidget {
  const HintScreen({Key key, this.category, this.imageAssetname})
      : super(key: key);

  final String category;
  final String imageAssetname;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Image(
            image: AssetImage(
                'assets/images/$category/${imageAssetname}_full.png'),
          ),
          IconButton(
            icon: Icon(
              Icons.cancel,
              color: Colors.white,
              size: 40,
            ),
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
    );
  }
}
