import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:provider/provider.dart';
import 'package:firebase_admob/firebase_admob.dart';

import '../ad_manager.dart';
import '../components/_shared/appbar_leading_button.dart';
import '../components/select_category_screen/categories_screen_shop_button.dart';
import '../components/select_category_screen/category_button.dart';
import '../data/db_provider.dart';
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

  void _loadBannerAd() {
    _bannerAd
      ..load()
      ..show();
  }

  @override
  void initState() {
    DBProviderDb().database;

    final DBProviderDb dbProvider = DBProviderDb();

    // dbProvider.deleteDb();
    final ShopProvider shopProvider = Provider.of<ShopProvider>(context, listen: false);

    dbProvider.getPurchasedCategories().then((List<String> listOfCategories) {
      print('Purchases length ${listOfCategories.length}');

      if (listOfCategories.isNotEmpty) {
        for (final String category in listOfCategories) {
          print(category);
          if (!shopProvider.getAvailableCategories.contains(category)) {
            shopProvider.addAvailableCategory(category: category);
          }
        }
      }
    });

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
                decoration: CustomElementTheme.categoryScreenAppBarBoxDecoration(),
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
                itemCount: shopProvider.getAvailableCategories.length,
                itemBuilder: (BuildContext context, int i) {
                  return CategoryButton(
                    categoryName: shopProvider.getAvailableCategories[i],
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
