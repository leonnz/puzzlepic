import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../components/category_button.dart';
import '../data/images_data.dart';
import '../providers/device_provider.dart';
import 'package:provider/provider.dart';
import '../styles/customStyles.dart';
import 'dart:convert';

class SelectCategory extends StatefulWidget {
  const SelectCategory({Key key}) : super(key: key);

  @override
  _SelectCategoryState createState() => _SelectCategoryState();
}

class _SelectCategoryState extends State<SelectCategory> {
  void precacheImages() async {
    final manifestContent =
        await DefaultAssetBundle.of(context).loadString('AssetManifest.json');
    final Map<String, dynamic> manifestMap = json.decode(manifestContent);
    final imagePaths =
        manifestMap.keys.where((String key) => key.contains('full')).toList();
    final bannerImagePaths =
        manifestMap.keys.where((String key) => key.contains('banner')).toList();

    imagePaths.forEach((image) {
      precacheImage(AssetImage(image), context);
    });

    bannerImagePaths.forEach((image) {
      precacheImage(AssetImage(image), context);
    });
  }

  @override
  void initState() {
    precacheImages();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    DeviceProvider deviceState = Provider.of<DeviceProvider>(context);
    deviceState.setGridSize(useMobile: deviceState.getUseMobileLayout);

    return GestureDetector(
      onPanUpdate: (details) {
        if (details.delta.dx > 0) {
          Navigator.pop(context, true);
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
                  Size.fromHeight(deviceState.getDeviceHeight * 0.10),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
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
                        onPressed: () => Navigator.pop(context, true),
                      ),
                    ),
                    Text(
                      'Categories',
                      style: CustomTextTheme(deviceProvider: deviceState)
                          .selectScreenTitleTextStyle(context),
                    ),
                  ],
                ),
              )),
          body: Container(
            padding: EdgeInsets.all(10),
            child: GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: deviceState.getGridSize,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
              ),
              itemCount: Images.imageList.length,
              itemBuilder: (BuildContext context, int i) {
                return CategoryButton(
                  categoryName: Images.imageList[i]["categoryName"],
                  categoryReadableName: Images.imageList[i]
                      ["categoryReadableName"],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
