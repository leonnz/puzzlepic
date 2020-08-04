import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../components/_shared/appbar_leading_button.dart';
import '../components/select_picture_screen/image_button.dart';
import '../data/db_provider.dart';
import '../data/images_data.dart';
import '../providers/device_provider.dart';
import '../styles/text_theme.dart';

class SelectPicture extends StatefulWidget {
  const SelectPicture({Key key, @required this.category, this.categoryReadableName})
      : super(key: key);

  final String category;
  final String categoryReadableName;

  @override
  _SelectPictureState createState() => _SelectPictureState();
}

class _SelectPictureState extends State<SelectPicture> {
  @override
  Widget build(BuildContext context) {
    final DeviceProvider deviceProvider = Provider.of<DeviceProvider>(context);

    final DBProviderDb dbProvider = DBProviderDb();

    // dbProvider.deleteTable();

    final List<Map<String, dynamic>> images = Images.imageList.firstWhere(
            (Map<String, dynamic> imageList) =>
                imageList['categoryName'] == widget.category)['categoryImages']
        as List<Map<String, dynamic>>;

    void refreshScreen() {
      setState(() {});
    }

    return GestureDetector(
      onPanUpdate: (DragUpdateDetails details) {
        if (details.delta.dx > 0) {
          Navigator.pop(context);
        }
      },
      child: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            fit: BoxFit.cover,
            image: AssetImage('assets/images/background.png'),
          ),
        ),
        child: Scaffold(
          backgroundColor: const Color.fromRGBO(255, 255, 255, 0.7),
          appBar: PreferredSize(
            preferredSize: Size.fromHeight(deviceProvider.getDeviceScreenHeight * 0.10),
            child: Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/_categories/${widget.category}_banner.png'),
                  fit: BoxFit.cover,
                ),
                boxShadow: const <BoxShadow>[
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
                  AppBarLeadingButton(icon: Icons.arrow_back_ios),
                  Text(
                    widget.categoryReadableName,
                    style: CustomTextTheme.selectScreenTitleTextStyle(context),
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: FutureBuilder<List<String>>(
                      future: dbProvider.getRecordsByCategory(category: widget.category),
                      builder: (BuildContext context, AsyncSnapshot<List<String>> snapshot) {
                        Widget grid;
                        if (snapshot.hasData) {
                          grid = Padding(
                            padding:
                                EdgeInsets.only(bottom: deviceProvider.getUseMobileLayout ? 4 : 8),
                            child: Text(
                              'Completed ${snapshot.data.length} / ${images.length}',
                              textAlign: TextAlign.center,
                              style: CustomTextTheme.selectPictureScreenCompletedTextStyle(),
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
          body: FutureBuilder<List<String>>(
            future: dbProvider.getRecordsByCategory(category: widget.category),
            builder: (BuildContext context, AsyncSnapshot<List<String>> snapshot) {
              Widget grid;
              if (snapshot.connectionState == ConnectionState.done) {
                if (snapshot.hasData) {
                  grid = Container(
                    padding: const EdgeInsets.all(10),
                    child: GridView.builder(
                      shrinkWrap: true,
                      itemCount: images.length,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: deviceProvider.getGridSize,
                        crossAxisSpacing: 5,
                        mainAxisSpacing: 5,
                      ),
                      itemBuilder: (BuildContext context, int i) {
                        return ImageButton(
                          categoryName: widget.category,
                          assetName: images[i]['assetName'].toString(),
                          readableName: images[i]['readableName'].toString(),
                          readableFullName: images[i]['readableFullname'].toString(),
                          title: images[i]['title'].toString(),
                          complete: snapshot.data.contains(images[i]['readableName']),
                          refreshPictureSelectScreen: refreshScreen,
                        );
                      },
                    ),
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
