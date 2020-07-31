import 'package:flutter/material.dart';
import 'package:in_app_purchase/in_app_purchase.dart';

import '../../components/shop_screen/image_pack_shop_button.dart';

class ImagePackList extends StatelessWidget {
  const ImagePackList({Key key, this.imagePackProducts}) : super(key: key);

  final List<ProductDetails> imagePackProducts;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView.builder(
        itemCount: imagePackProducts.length,
        itemBuilder: (BuildContext context, int index) {
          return ImagePackShopButton(
            imagePackProduct: imagePackProducts[index],
          );
        },
      ),
    );
  }
}
