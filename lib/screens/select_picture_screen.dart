import 'package:flutter/material.dart';

import '../data/images_data.dart';
import '../components/image_button.dart';
import '../data/db_provider.dart';
import '../screens/puzzle_screen.dart';

class SelectPicture extends StatefulWidget {
  const SelectPicture({Key key, @required this.category}) : super(key: key);

  final String category;

  @override
  _SelectPictureState createState() => _SelectPictureState();
}

class _SelectPictureState extends State<SelectPicture> {
  @override
  Widget build(BuildContext context) {
    DBProviderDb dbProvider = DBProviderDb();

    // dbProvider.deleteTable();

    List<Map<String, dynamic>> images = Images.imageList.firstWhere(
        (imageList) =>
            imageList["categoryName"] == widget.category)["categoryImages"];

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
        padding: EdgeInsets.all(10),
        child: FutureBuilder(
          future: dbProvider.getRecordsByCategory(category: widget.category),
          builder:
              (BuildContext context, AsyncSnapshot<List<String>> snapshot) {
            Widget grid;
            if (snapshot.connectionState == ConnectionState.done) {
              if (snapshot.hasData) {
                grid = GridView.builder(
                  itemCount: images.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2),
                  itemBuilder: (BuildContext context, int i) {
                    return GestureDetector(
                      onTap: () async {
                        final result = await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => PuzzleScreen(
                              category: widget.category,
                              assetName: images[i]["assetName"],
                              readableName: images[i]["readableName"],
                            ),
                          ),
                        );
                        if (result) {
                          setState(() {});
                        }
                      },
                      child: ImageButton(
                        categoryName: widget.category,
                        assetName: images[i]["assetName"],
                        readableName: images[i]["readableName"],
                        complete:
                            (snapshot.data.contains(images[i]["readableName"]))
                                ? true
                                : false,
                      ),
                    );
                  },
                );
              }
            } else {
              grid = Container();
            }
            return grid;
          },
        ),
      ),
    );
  }
}
