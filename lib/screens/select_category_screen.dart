import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../components/_shared/appbar_leading_button.dart';
import '../components/select_category_screen/categories_screen_shop_button.dart';
import '../components/select_category_screen/category_button.dart';
import '../data/db_provider.dart';
import '../providers/device_provider.dart';
import '../providers/shop_provider.dart';
import '../styles/element_theme.dart';
import '../styles/text_theme.dart';

class SelectCategoryScreen extends StatefulWidget {
  const SelectCategoryScreen({Key key}) : super(key: key);

  @override
  _SelectCategoryScreenState createState() => _SelectCategoryScreenState();
}

class _SelectCategoryScreenState extends State<SelectCategoryScreen> {
  @override
  void initState() {
    final DBProviderDb dbProvider = DBProviderDb();

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

    super.initState();
  }

  @override
  void dispose() {
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
                  crossAxisSpacing: deviceProvider.getUseMobileLayout ? 5 : 10,
                  mainAxisSpacing: deviceProvider.getUseMobileLayout ? 5 : 10,
                ),
                itemCount: shopProvider.getAvailableCategories.length,
                itemBuilder: (BuildContext context, int i) {
                  return CategoryButton(
                    categoryName: shopProvider.getAvailableCategories[i],
                  );
                },
              ),
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
