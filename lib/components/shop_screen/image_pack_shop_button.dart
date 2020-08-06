import 'package:flutter/material.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:provider/provider.dart';

import '../../providers/device_provider.dart';
import '../../providers/shop_provider.dart';
import '../../styles/element_theme.dart';
import '../../styles/text_theme.dart';
import 'purchase_alert.dart';

class ImagePackShopButton extends StatelessWidget {
  const ImagePackShopButton({
    Key key,
    this.imagePackProduct,
  }) : super(key: key);

  final ProductDetails imagePackProduct;

  @override
  Widget build(BuildContext context) {
    final DeviceProvider deviceProvider = Provider.of<DeviceProvider>(context);

    Future<void> purchaseCallbackAlert(String title, String message) {
      return showDialog(
        context: context,
        builder: (BuildContext context) => PurchaseAlert(
          title: title,
          message: message,
        ),
      );
    }

    return Consumer<ShopProvider>(
      builder: (BuildContext context, ShopProvider shop, Widget child) {
        final PurchaseDetails purchased = shop.getPastPurchases.firstWhere(
          (PurchaseDetails purchase) => purchase.productID == imagePackProduct.id,
          orElse: () => null,
        );

        return GestureDetector(
          onTap: () {
            deviceProvider.playSound(sound: 'fast_click.wav');
            shop.buyProduct(product: imagePackProduct, callback: purchaseCallbackAlert);
          },
          child: Container(
            margin: const EdgeInsets.all(10),
            padding: const EdgeInsets.all(10),
            // height: deviceProvider.getUseMobileLayout ? 50 : 70,
            width: double.infinity,
            decoration: CustomElementTheme.shopButtonBoxDecoration(),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      // imagePackProduct.title.substring(0, imagePackProduct.title.indexOf('(')),
                      imagePackProduct.id,
                      style: CustomTextTheme.selectPictureButtonTextStyle(),
                    ),
                    Text(
                      purchased != null ? 'Purchased' : imagePackProduct.price,
                      style: CustomTextTheme.selectPictureButtonTextStyle(),
                    ),
                  ],
                ),
                Text(imagePackProduct.description),
              ],
            ),
          ),
        );
      },
    );
  }
}
