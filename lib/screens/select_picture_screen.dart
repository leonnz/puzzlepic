import 'package:flutter/material.dart';
import '../data/images_data.dart';
import '../components/image_button.dart';

class SelectPicture extends StatelessWidget {
  const SelectPicture({Key key, @required this.category}) : super(key: key);

  final String category;

  @override
  Widget build(BuildContext context) {
    List<Map<String, dynamic>> images = Images.imageList.firstWhere(
        (imageList) => imageList["categoryName"] == category)["categoryImages"];

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text('Select Picture'),
          backgroundColor: Color(0xff000000),
        ),
        body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color(0xff501E5D),
                Color(0xff9E2950),
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          padding: EdgeInsets.all(10),
          child: GridView.builder(
            itemCount: images.length,
            gridDelegate:
                SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
            itemBuilder: (BuildContext context, int i) {
              return ImageButton(
                categoryName: category,
                assetName: images[i]["assetName"],
                readableName: images[i]["readableName"],
              );
            },
          ),
        ),
      ),
    );
  }
}
