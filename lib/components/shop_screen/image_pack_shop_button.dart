import 'package:flutter/material.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:provider/provider.dart';

import '../../providers/device_provider.dart';
import '../../providers/shop_provider.dart';
import '../../styles/custom_styles.dart';

class ImagePackShopButton extends StatelessWidget {
  const ImagePackShopButton({
    Key key,
    this.imagePackProduct,
  }) : super(key: key);

  final ProductDetails imagePackProduct;

  @override
  Widget build(BuildContext context) {
    final DeviceProvider deviceProvider = Provider.of<DeviceProvider>(context);
    final ShopProvider shopProvider = Provider.of<ShopProvider>(context);

    return GestureDetector(
      onTap: () {
        deviceProvider.playSound(sound: 'fast_click.wav');
        shopProvider.buyProduct(imagePackProduct);
      },
      child: Container(
        margin: const EdgeInsets.all(10),
        padding: const EdgeInsets.all(20),
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
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(
              imagePackProduct.title.substring(0, imagePackProduct.title.indexOf('(')),
              style: CustomTextTheme(deviceProvider: deviceProvider).selectPictureButtonTextStyle(),
            ),
            Text(
              shopProvider.hasPurchased(imagePackProduct.id) == null
                  ? imagePackProduct.price
                  : 'Purchased',
              style: CustomTextTheme(deviceProvider: deviceProvider).selectPictureButtonTextStyle(),
            ),
          ],
        ),
      ),
    );
  }
}
