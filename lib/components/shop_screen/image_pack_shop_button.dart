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

    return Consumer<ShopProvider>(
      builder: (BuildContext context, ShopProvider shop, Widget child) {
        final PurchaseDetails purchased = shop.getPastPurchases.firstWhere(
          (PurchaseDetails purchase) => purchase.productID == imagePackProduct.id,
          orElse: () => null,
        );

        return GestureDetector(
          onTap: () {
            deviceProvider.playSound(sound: 'fast_click.wav');
            shop.buyProduct(imagePackProduct);
          },
          child: Container(
            margin: const EdgeInsets.all(10),
            padding: const EdgeInsets.all(10),
            height: deviceProvider.getUseMobileLayout ? 50 : 70,
            width: double.infinity,
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(10)),
              boxShadow: <BoxShadow>[
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
                  // imagePackProduct.title.substring(0, imagePackProduct.title.indexOf('(')),
                  imagePackProduct.id,
                  style: CustomTextTheme(deviceProvider: deviceProvider)
                      .selectPictureButtonTextStyle(),
                ),
                Text(
                  purchased != null ? 'Purchased' : imagePackProduct.price,
                  style: CustomTextTheme(deviceProvider: deviceProvider)
                      .selectPictureButtonTextStyle(),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
