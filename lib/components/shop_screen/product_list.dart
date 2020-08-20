import 'package:flutter/material.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:provider/provider.dart';

import '../../providers/device_provider.dart';
import '../../providers/shop_provider.dart';
import 'product_tile.dart';

class ProductList extends StatelessWidget {
  const ProductList({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final DeviceProvider deviceProvider = Provider.of<DeviceProvider>(context, listen: false);

    List<ProductDetails> _sortedProducts() {
      final List<ProductDetails> sortedProductList = <ProductDetails>[];
      final ShopProvider shop = Provider.of<ShopProvider>(context, listen: false);

      sortedProductList.add(
          shop.getAllProducts.firstWhere((ProductDetails product) => product.id == 'removeads'));

      for (final ProductDetails product in shop.getAllProducts) {
        if (product.id != 'removeads') {
          sortedProductList.add(product);
        }
      }
      return sortedProductList;
    }

    final List<ProductDetails> fakeProductsList = <ProductDetails>[];

    for (int i = 1; i <= 10; i++) {
      fakeProductsList.add(ProductDetails(
          description: 'description', id: 'id $i', price: '\$1.99', title: 'title: $i (test)'));
    }

    return Consumer<ShopProvider>(
      builder: (BuildContext context, ShopProvider shop, Widget child) {
        Widget productList;

        if (fakeProductsList.isNotEmpty) {
          productList = Expanded(
            child: Container(
              width: deviceProvider.getUseMobileLayout
                  ? double.infinity
                  : MediaQuery.of(context).size.width * 2 / 3,
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: fakeProductsList.length,
                itemBuilder: (BuildContext context, int index) {
                  return ProductTile(
                    imagePackProduct: fakeProductsList[index],
                  );
                },
              ),
            ),
          );
        } else {
          productList = Container();
        }

        // if (shop.getAllProducts.isNotEmpty) {
        //   productList = Expanded(
        //     child: ListView.builder(
        //       shrinkWrap: true,
        //       itemCount: _sortedProducts().length,
        //       itemBuilder: (BuildContext context, int index) {
        //         return ProductTile(
        //           imagePackProduct: _sortedProducts()[index],
        //         );
        //       },
        //     ),
        //   );
        // } else {
        //   productList = Container();
        // }

        return productList;
      },
    );
  }
}
