import 'package:flutter/material.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:provider/provider.dart';

import '../../providers/device_provider.dart';
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

    return GestureDetector(
      onTap: () {
        deviceProvider.playSound(sound: 'fast_click.wav');
      },
      child: Container(
        margin: const EdgeInsets.all(10),
        padding: const EdgeInsets.all(10),
        height: deviceProvider.getUseMobileLayout ? 50 : 70,
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.all(Radius.circular(10)),
          boxShadow: const <BoxShadow>[
            BoxShadow(
              color: Colors.black45,
              blurRadius: 3.0,
              offset: Offset(0.0, 2.0),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(
              imagePackProduct.title.substring(0, imagePackProduct.title.indexOf('(')),
              style: CustomTextTheme(deviceProvider: deviceProvider).selectPictureButtonTextStyle(),
            ),
            Text(
              imagePackProduct.price,
              style: CustomTextTheme(deviceProvider: deviceProvider).selectPictureButtonTextStyle(),
            ),
          ],
        ),
      ),
    );
  }
}
