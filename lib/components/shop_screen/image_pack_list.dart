import 'package:flutter/material.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:provider/provider.dart';

import '../../components/shop_screen/image_pack_shop_button.dart';
import '../../providers/device_provider.dart';
import '../../providers/shop_provider.dart';

class ImagePackList extends StatelessWidget {
  const ImagePackList({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final DeviceProvider deviceProvider = Provider.of<DeviceProvider>(context);
    final ShopProvider shopProvider = Provider.of<ShopProvider>(context);

    return FutureBuilder<List<ProductDetails>>(
      future: shopProvider.setImagePackProducts(),
      builder: (BuildContext context, AsyncSnapshot<List<ProductDetails>> snapshot) {
        Widget imagePackList;

        if (snapshot.connectionState == ConnectionState.done && snapshot.hasData) {
          imagePackList = Expanded(
            child: Container(
              padding: const EdgeInsets.all(10),
              child: ListView.builder(
                // gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                //   crossAxisCount: deviceProvider.getGridSize,
                //   crossAxisSpacing: 10,
                //   mainAxisSpacing: 10,
                // ),
                itemCount: snapshot.data.length,
                itemBuilder: (BuildContext context, int index) {
                  return ImagePackShopButton(
                    imagePackProduct: snapshot.data[index],
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
