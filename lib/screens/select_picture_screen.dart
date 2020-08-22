import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../components/_shared/appbar_leading_button.dart';
import '../components/select_picture_screen/image_button.dart';
import '../data/db_provider.dart';
import '../data/images_data.dart';
import '../providers/device_provider.dart';
import '../providers/game_provider.dart';
import '../providers/shop_provider.dart';
import '../styles/element_theme.dart';
import '../styles/text_theme.dart';

class SelectPictureScreen extends StatefulWidget {
  const SelectPictureScreen({
    Key key,
    @required this.category,
  }) : super(key: key);

  final String category;

  @override
  _SelectPictureScreenState createState() => _SelectPictureScreenState();
}

class _SelectPictureScreenState extends State<SelectPictureScreen> {
  @override
  Widget build(BuildContext context) {
    final DeviceProvider deviceProvider = Provider.of<DeviceProvider>(context);
    final GameProvider gameProvider = Provider.of<GameProvider>(context);
    final ShopProvider shopProvider = Provider.of<ShopProvider>(context);

    final DBProviderDb dbProvider = DBProviderDb();

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
        decoration: CustomElementTheme.screenBackgroundBoxDecoration(),
        child: SafeArea(
          child: Scaffold(
            backgroundColor: const Color.fromRGBO(255, 255, 255, 0.7),
            appBar: PreferredSize(
              preferredSize: Size.fromHeight(deviceProvider.getDeviceScreenHeight * 0.10),
              child: Container(
                decoration: CustomElementTheme.imageScreenAppBarBoxDecoration(
                    image: 'assets/images/_categories/${widget.category}_banner.png'),
                child: Stack(
                  alignment: Alignment.center,
                  children: <Widget>[
                    const AppBarLeadingButton(icon: Icons.arrow_back_ios),
                    Text(
                      gameProvider.getImageCategoryReadableName,
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
                              padding: EdgeInsets.only(
                                  bottom: deviceProvider.getUseMobileLayout ? 4 : 8),
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
                        key: const PageStorageKey<String>('selectPictureScreenGridView'),
                        shrinkWrap: true,
                        itemCount: images.length,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: deviceProvider.getGridSize,
                          crossAxisSpacing: deviceProvider.getUseMobileLayout ? 5 : 10,
                          mainAxisSpacing: deviceProvider.getUseMobileLayout ? 5 : 10,
                        ),
                        itemBuilder: (BuildContext context, int i) {
                          return ImageButton(
                            imageAssetName: images[i]['assetName'].toString(),
                            imageReadableName: images[i]['readableName'].toString(),
                            imageReadableFullName: images[i]['readableFullname'].toString(),
                            imageTitle: images[i]['title'].toString(),
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
            bottomNavigationBar: shopProvider.getBannerAdLoaded
                ? Container(
                    height: deviceProvider.getUseMobileLayout ? 60.0 : 90.0,
                    color: Colors.white,
                  )
                : null,
          ),
        ),
      ),
    );
  }
}
