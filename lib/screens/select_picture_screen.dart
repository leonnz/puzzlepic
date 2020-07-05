import 'package:flutter/material.dart';
import '../data/images_data.dart';
import '../components/image_button.dart';
import '../data/db_provider.dart';
import '../data/puzzle_record_model.dart';

class SelectPicture extends StatelessWidget {
  const SelectPicture({Key key, @required this.category}) : super(key: key);

  final String category;

  @override
  Widget build(BuildContext context) {
    // List<String> completePuzzles = [];

    DBProviderDb dbProvider = DBProviderDb();

    final tajMahal = PuzzleRecord(
      id: 0,
      puzzleName: 'tajmahal',
      puzzleCategory: 'buildings',
      complete: 'true',
      bestMoves: 0,
    );

    dbProvider.insertRecord(tajMahal);

    // dbProvider.getRecordsByCategory(category: category).then(
    //       (records) => records.forEach((puzzle) {
    //         completePuzzles.add(puzzle.puzzleName);
    //         print(completePuzzles);
    //       }),
    //     );

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
        child: FutureBuilder(
            future: dbProvider.getRecordsByCategory(category: category),
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
                            snapshot.data.contains(images[i]["assetName"]))
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
