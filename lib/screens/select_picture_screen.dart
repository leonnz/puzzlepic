import 'package:flutter/material.dart';
import '../data/images_data.dart';
import '../components/image_button.dart';
import '../data/db_provider.dart';

class SelectPicture extends StatelessWidget {
  const SelectPicture({Key key, @required this.category}) : super(key: key);

  final String category;

  @override
  Widget build(BuildContext context) {
    var records = DBProviderDb.db.getRecords();

    records.then((value) => print(value[0].puzzleName));

    List<Map<String, dynamic>> images = Images.imageList.firstWhere(
        (imageList) => imageList["categoryName"] == category)["categoryImages"];

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Select Picture',
          style: Theme.of(context).textTheme.headline1,
        ),
        backgroundColor: Color(0xff501E5D),
      ),
      body: Container(
        //
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
    );
  }
}
