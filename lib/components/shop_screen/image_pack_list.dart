import 'package:flutter/material.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:provider/provider.dart';

import '../../providers/shop_provider.dart';
import 'image_pack_shop_tile.dart';

class ImagePackList extends StatelessWidget {
  const ImagePackList({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<ShopProvider>(
      builder: (BuildContext context, ShopProvider shop, Widget child) {
        Widget imagePackProductList;

        if (shop.getImagePackProducts.isNotEmpty) {
          final List<ProductDetails> sortedProductList = <ProductDetails>[];

          final ProductDetails removeAds =
              shop.getImagePackProducts.firstWhere((element) => element.id == 'removeads');
          sortedProductList.add(removeAds);

          for (final ProductDetails item in shop.getImagePackProducts) {
            if (item.id != 'removeads') {
              sortedProductList.add(item);
            }
          }

          imagePackProductList = Expanded(
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: sortedProductList.length,
              itemBuilder: (BuildContext context, int index) {
                return ImagePackShopTile(
                  imagePackProduct: sortedProductList[index],
                );
              },
            ),
          );
        } else {
          imagePackProductList = Container();
        }

        return imagePackProductList;
      },
    );
  }
}
