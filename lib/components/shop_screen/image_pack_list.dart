import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../components/shop_screen/image_pack_shop_button.dart';
import '../../providers/shop_provider.dart';

class ImagePackList extends StatelessWidget {
  const ImagePackList({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<ShopProvider>(
      builder: (BuildContext context, ShopProvider shop, Widget child) {
        Widget imagePackProductList;

        if (shop.getImagePackProducts.isNotEmpty) {
          imagePackProductList = Expanded(
            child: ListView.builder(
              itemCount: shop.getImagePackProducts.length,
              itemBuilder: (BuildContext context, int index) {
                return ImagePackShopButton(
                  imagePackProduct: shop.getImagePackProducts[index],
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
