import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_admob/firebase_admob.dart';

import '../components/buttons/category_button.dart';
import '../data/images_data.dart';
import '../providers/device_provider.dart';
import '../styles/customStyles.dart';
import '../ad_manager.dart';

class SelectCategory extends StatefulWidget {
  const SelectCategory({Key key}) : super(key: key);

  @override
  _SelectCategoryState createState() => _SelectCategoryState();
}

class _SelectCategoryState extends State<SelectCategory> {
  BannerAd _bannerAd;

  void _loadBannerAd() {
    _bannerAd
      ..load()
      ..show(anchorType: AnchorType.bottom);
  }

  @override
  void initState() {
    _bannerAd = BannerAd(
      adUnitId: AdManager.bannerAdUnitId,
      size: AdSize.fullBanner,
    );
    _loadBannerAd();
    super.initState();
  }

  @override
  void dispose() {
    _bannerAd?.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    DeviceProvider deviceProvider = Provider.of<DeviceProvider>(context);

    return WillPopScope(
      onWillPop: () async {
        Navigator.pop(context, true);
        return true;
      },
      child: GestureDetector(
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
                  Size.fromHeight(deviceProvider.getDeviceScreenHeight * 0.10),
              child: Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(
                        'assets/images/_categories/_categories_banner.png'),
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
                        iconSize: deviceProvider.getUseMobileLayout ? 25 : 50,
                        icon: Icon(Icons.arrow_back_ios),
                        onPressed: () {
                          deviceProvider.playSound(sound: 'fast_click.wav');
                          Navigator.pop(context, true);
                        },
                      ),
                    ),
                    Text(
                      'Categories',
                      style: CustomTextTheme(deviceProvider: deviceProvider)
                          .selectScreenTitleTextStyle(context),
                    ),
                  ],
                ),
              ),
            ),
            body: Container(
              padding: EdgeInsets.all(10),
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: deviceProvider.getGridSize,
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
      ),
    );
  }
}
