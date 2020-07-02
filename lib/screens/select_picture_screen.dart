import 'dart:convert';

import 'game_screen.dart';

import 'package:flutter/material.dart';

class SelectPicture extends StatefulWidget {
  const SelectPicture({Key key, @required this.category}) : super(key: key);

  final String category;

  @override
  _SelectPictureState createState() => _SelectPictureState();
}

class _SelectPictureState extends State<SelectPicture> {
  List<String> images = [];

  void _initImages() async {
    final manifestContent =
        await DefaultAssetBundle.of(context).loadString('AssetManifest.json');

    final Map<String, dynamic> manifestMap = json.decode(manifestContent);

    final imagePaths = manifestMap.keys
        .where((String key) => key.contains('images/'))
        .where((String key) => key.contains(widget.category.toLowerCase()))
        .where((String key) => !key.contains('_'))
        .where((String key) => key.contains('.png'))
        .toList();
    setState(() {
      images = imagePaths;
    });
  }

  @override
  void initState() {
    super.initState();
    _initImages();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text('Select Picture'),
          automaticallyImplyLeading: false,
        ),
        body: GridView.builder(
          itemCount: images.length,
          gridDelegate:
              SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
          itemBuilder: (BuildContext context, int i) {
            return GestureDetector(
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => GameScreen(
                    category: widget.category,
                    image: images[i],
                  ),
                ),
              ),
              child: Container(
                margin: EdgeInsets.all(10),
                child: Image(
                  image: AssetImage(images[i]),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
