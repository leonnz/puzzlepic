import 'package:flutter/material.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:provider/provider.dart';

import '../../providers/device_provider.dart';
import '../../styles/custom_styles.dart';

class RemoveAdShopButton extends StatelessWidget {
  const RemoveAdShopButton({
    Key key,
    this.removeAdProduct,
  }) : super(key: key);

  final ProductDetails removeAdProduct;

  @override
  Widget build(BuildContext context) {
    final DeviceProvider deviceProvider = Provider.of<DeviceProvider>(context);

    return GestureDetector(
      onTap: () {
        // deviceProvider.playSound(sound: 'fast_click.wav');
        // shopProvider.buyProduct(snapshot.data[index]);
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
              removeAdProduct.title.substring(0, removeAdProduct.title.indexOf('(')),
              style: CustomTextTheme(deviceProvider: deviceProvider).selectPictureButtonTextStyle(),
            ),
            Text(
              removeAdProduct.price,
              // : 'Purchased',
              style: CustomTextTheme(deviceProvider: deviceProvider).selectPictureButtonTextStyle(),
            ),
          ],
        ),
      ),
    );
  }
}
