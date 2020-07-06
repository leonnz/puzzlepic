import 'package:flutter/material.dart';
import 'package:picturepuzzle/providers/game_state_provider.dart';
import 'package:provider/provider.dart';
import '../data/images_data.dart';
import '../components/image_button.dart';
import '../data/db_provider.dart';

class SelectPicture extends StatelessWidget {
  const SelectPicture({Key key, @required this.category}) : super(key: key);

  final String category;

  @override
  Widget build(BuildContext context) {
    DBProviderDb dbProvider = DBProviderDb();

    // dbProvider.deleteTable();

    List<Map<String, dynamic>> images = Images.imageList.firstWhere(
        (imageList) => imageList["categoryName"] == category)["categoryImages"];

    final state = Provider.of<GameStateProvider>(context);

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
            future: state.getCompletedPuzzles,
            builder:
                (BuildContext context, AsyncSnapshot<List<String>> snapshot) {
              return GridView.builder(
                itemCount: images.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2),
                itemBuilder: (BuildContext context, int i) {
                  return ImageButton(
                    categoryName: category,
                    assetName: images[i]["assetName"],
                    readableName: images[i]["readableName"],
                    complete: (snapshot.hasData &&
                            snapshot.data.contains(images[i]["readableName"]))
                        ? true
                        : false,
                  );
                },
              );
            }),
      ),
    );
  }
}
