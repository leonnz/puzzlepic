import 'package:flutter/material.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:provider/provider.dart';

import '../../providers/shop_provider.dart';
import 'product_tile.dart';

class ImagePackList extends StatelessWidget {
  const ImagePackList({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<ProductDetails> sortedProducts() {
      final List<ProductDetails> sortedProductList = <ProductDetails>[];
      final ShopProvider shop = Provider.of<ShopProvider>(context, listen: false);

      sortedProductList.add(shop.getImagePackProducts
          .firstWhere((ProductDetails product) => product.id == 'removeads'));

      for (final ProductDetails product in shop.getImagePackProducts) {
        if (product.id != 'removeads') {
          sortedProductList.add(product);
        }
      }
      return sortedProductList;
    }

    return Consumer<ShopProvider>(
      builder: (BuildContext context, ShopProvider shop, Widget child) {
        Widget productList;

        if (shop.getImagePackProducts.isNotEmpty) {
          productList = Expanded(
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: sortedProducts().length,
              itemBuilder: (BuildContext context, int index) {
                return ImagePackShopTile(
                  imagePackProduct: sortedProducts()[index],
                );
              },
            ),
          );
        } else {
          productList = Container();
        }

        return productList;
      },
    );
  }
}
