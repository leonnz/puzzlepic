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

    return Consumer<ShopProvider>(
      builder: (BuildContext context, ShopProvider shop, Widget child) {
        Widget productList;

        // DEV ONLY - Fake products
        // final List<ProductDetails> fakeProductsList = <ProductDetails>[];
        // for (final String product in shop.getAllProductIds) {
        //   fakeProductsList.add(ProductDetails(
        //       description: 'test product',
        //       id: product,
        //       price: '\$1.99',
        //       title: '$product (Puzzle Pic)'));
        // }

        // if (fakeProductsList.isNotEmpty) {
        //   productList = Expanded(
        //     child: Container(
        //       width: deviceProvider.getUseMobileLayout
        //           ? double.infinity
        //           : MediaQuery.of(context).size.width * 2 / 3,
        //       child: ListView.builder(
        //         shrinkWrap: true,
        //         itemCount: fakeProductsList.length,
        //         itemBuilder: (BuildContext context, int index) {
        //           return ProductTile(
        //             imagePackProduct: fakeProductsList[index],
        //             index: index,
        //             lastProduct: fakeProductsList.length,
        //           );
        //         },
        //       ),
        //     ),
        //   );
        // } else {
        //   productList = Container();
        // }

        if (shop.getAllProducts.isNotEmpty) {
          productList = Expanded(
            child: Container(
              width: deviceProvider.getUseMobileLayout
                  ? double.infinity
                  : MediaQuery.of(context).size.width * 2 / 3,
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: _sortedProducts().length,
                itemBuilder: (BuildContext context, int index) {
                  return ProductTile(
                    imagePackProduct: _sortedProducts()[index],
                    index: index,
                    lastProduct: _sortedProducts().length,
                  );
                },
              ),
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
