import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../components/_shared/appbar_leading_button.dart';
import '../components/select_category_screen/categories_screen_shop_button.dart';
import '../components/select_category_screen/category_button.dart';
import '../data/db_provider.dart';
import '../providers/device_provider.dart';
import '../providers/shop_provider.dart';
import '../styles/box_decoration_styes.dart';
import '../styles/text_styles.dart';

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
      if (listOfCategories.isNotEmpty) {
        for (final String category in listOfCategories) {
          if (!shopProvider.getAvailableCategories.contains(category) &&
              category != shopProvider.getRemoveAdProductId) {
            shopProvider.addAvailableCategory(category: category);
          }
        }
      }
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final DeviceProvider deviceProvider = Provider.of<DeviceProvider>(context, listen: false);
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
          decoration: kScreenBackgroundBoxDecoration,
          child: SafeArea(
            child: Scaffold(
              backgroundColor: const Color.fromRGBO(255, 255, 255, 0.7),
              appBar: PreferredSize(
                preferredSize: Size.fromHeight(deviceProvider.getDeviceScreenHeight * 0.10),
                child: Container(
                  decoration: kCategoryScreenAppBarBoxDecoration,
                  child: Stack(
                    alignment: Alignment.center,
                    children: <Widget>[
                      const AppBarLeadingButton(icon: Icons.arrow_back_ios),
                      Text(
                        'Categories',
                        style: kSelectScreenTitleTextStyle,
                      ),
                      const CategoryShopButton(),
                    ],
                  ),
                ),
              ),
              body: GridView.builder(
                padding: const EdgeInsets.all(10),
                key: const PageStorageKey<String>('selectCategoryScreenGridView'),
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
              bottomNavigationBar: shopProvider.getBannerAdLoaded
                  ? Container(
                      height:60,
                      color: Colors.white,
                    )
                  : null,
            ),
          ),
        ),
      ),
    );
  }
}
