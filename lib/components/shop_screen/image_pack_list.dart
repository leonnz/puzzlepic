import 'package:flutter/material.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:provider/provider.dart';

import '../../providers/shop_provider.dart';
import 'product_tile.dart';

class ImagePackList extends StatelessWidget {
  const ImagePackList({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<ShopProvider>(
      builder: (BuildContext context, ShopProvider shop, Widget child) {
        Widget imagePackProductList;

        if (shop.getImagePackProducts.isNotEmpty) {
          final List<ProductDetails> sortedProductList = <ProductDetails>[];

          final ProductDetails removeAds = shop.getImagePackProducts
              .firstWhere((ProductDetails product) => product.id == 'removeads');
          sortedProductList.add(removeAds);

          for (final ProductDetails product in shop.getImagePackProducts) {
            if (product.id != 'removeads') {
              sortedProductList.add(product);
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
