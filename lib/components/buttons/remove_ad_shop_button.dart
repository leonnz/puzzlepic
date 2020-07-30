import 'package:flutter/material.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:provider/provider.dart';

import '../../providers/device_provider.dart';
import '../../providers/shop_provider.dart';
import '../../styles/custom_styles.dart';

class RemoveAdShopButton extends StatelessWidget {
  const RemoveAdShopButton({Key key, this.removeAdProduct}) : super(key: key);

  final List<ProductDetails> removeAdProduct;

  @override
  Widget build(BuildContext context) {
    final DeviceProvider deviceProvider = Provider.of<DeviceProvider>(context);
    final ShopProvider shopProvider = Provider.of<ShopProvider>(context);

    return Expanded(
      child: ListView.builder(
        itemCount: removeAdProduct.length,
        padding: const EdgeInsets.all(20),
        itemBuilder: (BuildContext context, int index) {
          return GestureDetector(
            onTap: () {
              deviceProvider.playSound(sound: 'fast_click.wav');
              shopProvider.buyProduct(removeAdProduct[index]);
            },
            child: Container(
              padding: const EdgeInsets.all(10),
              height: deviceProvider.getUseMobileLayout ? 50 : 70,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: const BorderRadius.all(Radius.circular(10)),
                boxShadow: <BoxShadow>[
                  BoxShadow(
                    color: Colors.black45,
                    blurRadius: 3.0,
                    offset: const Offset(0.0, 2.0),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    removeAdProduct[index].title,
                    style: CustomTextTheme(deviceProvider: deviceProvider)
                        .selectPictureButtonTextStyle(),
                  ),
                  Text(
                    shopProvider.hasPurchased(removeAdProduct[index].id) == null
                        ? removeAdProduct[index].price
                        : 'Purchased',
                    style: CustomTextTheme(deviceProvider: deviceProvider)
                        .selectPictureButtonTextStyle(),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
