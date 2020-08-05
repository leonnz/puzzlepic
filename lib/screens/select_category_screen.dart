import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:provider/provider.dart';
import 'package:firebase_admob/firebase_admob.dart';
import 'package:sqflite/sqflite.dart';

import '../ad_manager.dart';
import '../components/_shared/appbar_leading_button.dart';
import '../components/select_category_screen/categories_screen_shop_button.dart';
import '../components/select_category_screen/category_button.dart';
import '../data/db_provider.dart';
import '../data/images_data.dart';
import '../providers/device_provider.dart';
import '../providers/shop_provider.dart';
import '../styles/element_theme.dart';
import '../styles/text_theme.dart';

class SelectCategory extends StatefulWidget {
  const SelectCategory({Key key}) : super(key: key);

  @override
  _SelectCategoryState createState() => _SelectCategoryState();
}

class _SelectCategoryState extends State<SelectCategory> {
  BannerAd _bannerAd;
  List<String> availableCategories;

  void _loadBannerAd() {
    _bannerAd
      ..load()
      ..show(anchorType: AnchorType.bottom);
  }

  Future<void> dbcheck() async {
    var path = await getDatabasesPath();

    var dir = Directory(path);

    dir.list(recursive: true, followLinks: false).listen((file) {
      print(file.path);
    });
  }

  @override
  void initState() {
    // DBProviderDb().database;

    // dbProvider.getRecordsByCategory(category: 'cities').then((List<String> listOfCategories) {
    //   print(listOfCategories.length);

    //   for (final String category in listOfCategories) {
    //     print(category);
    //   }
    // });
    final DBProviderDb dbProvider = DBProviderDb();

    // dbProvider.deleteDb();
    dbcheck();

    // Testing purchase record table
    dbProvider.getPurchasedCategories().then((List<String> listOfCategories) {
      print(listOfCategories.length);

      for (final String category in listOfCategories) {
        print(category);
      }
    });

    dbProvider.getRecordsByCategory(category: 'cities').then((List<String> listOfCategories) {
      print(listOfCategories.length);

      for (final String category in listOfCategories) {
        print(category);
      }
    });

    final ShopProvider shopProvider = Provider.of<ShopProvider>(context, listen: false);

    availableCategories = shopProvider.availableCategories;
    // TODO append purchased categories from DB
    // availableCategories.addAll(shopProvider.)

    if (shopProvider.getAvailable) {
      final PurchaseDetails adPurchased = shopProvider.getPastPurchases.firstWhere(
        (PurchaseDetails purchase) => purchase.productID == shopProvider.getRemoveAdProductId,
        orElse: () => null,
      );
      if (adPurchased == null) {
        _bannerAd = BannerAd(
          adUnitId: AdManager.bannerAdUnitId,
          size: AdSize.fullBanner,
        );
        _loadBannerAd();
      }
    }

    super.initState();
  }

  @override
  void dispose() {
    _bannerAd?.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final DeviceProvider deviceProvider = Provider.of<DeviceProvider>(context);
    final ShopProvider shopProvider = Provider.of<ShopProvider>(context);

    return WillPopScope(
      onWillPop: () async {
        Navigator.pop(context, true);
        return true;
      },
      child: GestureDetector(
        onPanUpdate: (DragUpdateDetails details) {
          if (details.delta.dx > 0) {
            Navigator.pop(context, true);
          }
        },
        child: Container(
          decoration: CustomElementTheme.screenBackgroundBoxDecoration(),
          child: Scaffold(
            backgroundColor: const Color.fromRGBO(255, 255, 255, 0.7),
            appBar: PreferredSize(
              preferredSize: Size.fromHeight(deviceProvider.getDeviceScreenHeight * 0.10),
              child: Container(
                decoration: CustomElementTheme.appBarBoxDecoration(
                    image: 'assets/images/_categories/_categories_banner.png'),
                child: Stack(
                  alignment: Alignment.center,
                  children: <Widget>[
                    const AppBarLeadingButton(icon: Icons.arrow_back_ios),
                    Text(
                      'Categories',
                      style: CustomTextTheme.selectScreenTitleTextStyle(context),
                    ),
                    const CategoryShopButton(),
                  ],
                ),
              ),
            ),
            body: Container(
              padding: const EdgeInsets.all(10),
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: deviceProvider.getGridSize,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                ),
                itemCount: availableCategories.length,
                itemBuilder: (BuildContext context, int i) {
                  return CategoryButton(
                    categoryName: availableCategories[i],
                    // TODO Maybe move this logic into Category button
                    categoryReadableName: Images.imageList
                        .firstWhere((Map<String, dynamic> category) =>
                            category['categoryName'] ==
                            availableCategories[i])['categoryReadableName']
                        .toString(),
                  );
                },
                // itemCount: Images.imageList.length,
                // itemBuilder: (BuildContext context, int i) {
                //   return CategoryButton(
                //     categoryName: Images.imageList[i]['categoryName'].toString(),
                //     categoryReadableName: Images.imageList[i]['categoryReadableName'].toString(),
                //   );
                // },
              ),
            ),
          ),
        ),
      ),
    );
  }
}
