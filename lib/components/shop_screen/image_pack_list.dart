import 'package:flutter/material.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:provider/provider.dart';

import '../../components/shop_screen/image_pack_shop_button.dart';
import '../../providers/shop_provider.dart';

class ImagePackList extends StatelessWidget {
  const ImagePackList({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ShopProvider shopProvider = Provider.of<ShopProvider>(context);

    return FutureBuilder<void>(
      future: shopProvider.setImagePackProducts(),
      builder: (BuildContext context, AsyncSnapshot<void> snapshot) {
        Widget imagePackList;

        if (snapshot.connectionState == ConnectionState.done && snapshot.hasData) {
          imagePackList = Expanded(
            child: Container(
              padding: const EdgeInsets.all(10),
              child: ListView.builder(
                itemCount: shopProvider.getImagePackProducts.length,
                itemBuilder: (BuildContext context, int index) {
                  return ImagePackShopButton(
                    imagePackProduct: shopProvider.getImagePackProducts[index],
                  );
                },
              ),
            ),
          );
        } else {
          imagePackList = Container();
        }
        return imagePackList;
      },
    );
  }
}
