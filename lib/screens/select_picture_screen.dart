import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../data/images_data.dart';
import '../components/image_button.dart';
import '../data/db_provider.dart';
import '../screens/puzzle_screen.dart';

class SelectPicture extends StatefulWidget {
  const SelectPicture(
      {Key key, @required this.category, this.categoryReadableName})
      : super(key: key);

  final String category;
  final String categoryReadableName;

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

    return GestureDetector(
      onPanUpdate: (details) {
        if (details.delta.dx > 0) {
          Navigator.pop(context);
        }
      },
      child: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            fit: BoxFit.cover,
            image: AssetImage('assets/images/background.png'),
          ),
        ),
        child: Scaffold(
          backgroundColor: Color.fromRGBO(255, 255, 255, 0.7),
          appBar: PreferredSize(
            preferredSize: Size.fromHeight(90),
            child: AppBar(
              flexibleSpace: Opacity(
                opacity: 0.8,
                child: Image(
                  image: AssetImage(
                      'assets/images/categories/${widget.category}_banner.png'),
                  fit: BoxFit.cover,
                ),
              ),
              title: Text(
                widget.categoryReadableName,
                style: Theme.of(context).textTheme.headline1,
              ),
              backgroundColor: Color(0xffffffff),
              iconTheme: IconThemeData(
                color: Colors.black,
              ),
              leading: IconButton(
                icon: Icon(Icons.arrow_back_ios),
                onPressed: () => Navigator.pop(context),
              ),
              elevation: 4,
              centerTitle: true,
              bottom: PreferredSize(
                child: FutureBuilder(
                  future: dbProvider.getRecordsByCategory(
                      category: widget.category),
                  builder: (BuildContext context,
                      AsyncSnapshot<List<String>> snapshot) {
                    Widget grid;
                    if (snapshot.hasData) {
                      grid = Padding(
                        padding: const EdgeInsets.only(bottom: 15.0),
                        child: Text(
                          'Completed ${snapshot.data.length} / ${images.length}',
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.headline4,
                        ),
                      );
                    } else {
                      grid = Container();
                    }
                    return grid;
                  },
                ),
                preferredSize: Size.zero,
              ),
            ),
          ),
          body: FutureBuilder(
            future: dbProvider.getRecordsByCategory(category: widget.category),
            builder:
                (BuildContext context, AsyncSnapshot<List<String>> snapshot) {
              Widget grid;
              if (snapshot.connectionState == ConnectionState.done) {
                if (snapshot.hasData) {
                  grid = Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                          child: GridView.builder(
                            shrinkWrap: true,
                            itemCount: images.length,
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              // crossAxisSpacing: 10,
                              // mainAxisSpacing: 10,
                            ),
                            itemBuilder: (BuildContext context, int i) {
                              return Padding(
                                padding: EdgeInsets.all(10),
                                child: GestureDetector(
                                  onTap: () async {
                                    final result = await Navigator.push(
                                      context,
                                      CupertinoPageRoute(
                                        builder: (context) => PuzzleScreen(
                                          category: widget.category,
                                          assetName: images[i]["assetName"],
                                          readableName: images[i]
                                              ["readableName"],
                                        ),
                                      ),
                                    );
                                    // Refreshes the pictures to show complete ticks from database
                                    if (result) setState(() {});
                                  },
                                  child: ImageButton(
                                    imgNumber: i,
                                    categoryName: widget.category,
                                    assetName: images[i]["assetName"],
                                    readableName: images[i]["readableName"],
                                    complete: (snapshot.data.contains(
                                            images[i]["readableName"]))
                                        ? true
                                        : false,
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    ],
                  );
                }
              } else {
                grid = Container();
              }
              return grid;
            },
          ),
        ),
      ),
    );
  }
}
