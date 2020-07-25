import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../data/images_data.dart';
import '../data/db_provider.dart';
import '../components/image_button.dart';
import '../providers/device_provider.dart';
import '../styles/customStyles.dart';

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
    DeviceProvider deviceState = Provider.of<DeviceProvider>(context);

    DBProviderDb dbProvider = DBProviderDb();

    // dbProvider.deleteTable();

    List<Map<String, dynamic>> images = Images.imageList.firstWhere(
        (imageList) =>
            imageList["categoryName"] == widget.category)["categoryImages"];

    void refreshScreen() {
      setState(() {});
    }

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
            preferredSize:
                Size.fromHeight(deviceState.getDeviceScreenHeight * 0.10),
            child: Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(
                      'assets/images/_categories/${widget.category}_banner.png'),
                  fit: BoxFit.cover,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black45,
                    blurRadius: 5.0,
                    offset: Offset(0.0, 3.0),
                  ),
                ],
              ),
              child: Stack(
                alignment: Alignment.center,
                children: <Widget>[
                  Align(
                    alignment: Alignment.centerLeft,
                    child: IconButton(
                      iconSize: deviceState.getUseMobileLayout ? 25 : 50,
                      icon: Icon(Icons.arrow_back_ios),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ),
                  Text(
                    widget.categoryReadableName,
                    style: CustomTextTheme(deviceProvider: deviceState)
                        .selectScreenTitleTextStyle(context),
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: FutureBuilder(
                      future: dbProvider.getRecordsByCategory(
                          category: widget.category),
                      builder: (BuildContext context,
                          AsyncSnapshot<List<String>> snapshot) {
                        Widget grid;
                        if (snapshot.hasData) {
                          grid = Padding(
                            padding: EdgeInsets.only(
                                bottom: deviceState.getUseMobileLayout ? 4 : 8),
                            child: Text(
                              'Completed ${snapshot.data.length} / ${images.length}',
                              textAlign: TextAlign.center,
                              style:
                                  CustomTextTheme(deviceProvider: deviceState)
                                      .selectPictureScreenCompletedTextStyle(),
                            ),
                          );
                        } else {
                          grid = Container();
                        }
                        return grid;
                      },
                    ),
                  ),
                ],
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
                          padding: const EdgeInsets.all(10),
                          child: GridView.builder(
                            shrinkWrap: true,
                            itemCount: images.length,
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: deviceState.getGridSize,
                              childAspectRatio: 1,
                              crossAxisSpacing: 5,
                              mainAxisSpacing: 5,
                            ),
                            itemBuilder: (BuildContext context, int i) {
                              return ImageButton(
                                imgNumber: i,
                                categoryName: widget.category,
                                assetName: images[i]["assetName"],
                                readableName: images[i]["readableName"],
                                readableFullName: images[i]["readableFullname"],
                                title: images[i]["title"],
                                complete: (snapshot.data
                                        .contains(images[i]["readableName"]))
                                    ? true
                                    : false,
                                refreshPictureSelectScreen: refreshScreen,
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
