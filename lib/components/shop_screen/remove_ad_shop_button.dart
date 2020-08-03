import 'package:flutter/material.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:provider/provider.dart';

import '../../providers/device_provider.dart';
import '../../providers/shop_provider.dart';
import '../../styles/custom_styles.dart';
import 'purchase_alert.dart';

class RemoveAdShopButton extends StatelessWidget {
  const RemoveAdShopButton({
    Key key,
  }) : super(key: key);

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
        Widget buyRemoveAdsButton;

        if (shop.getAdProduct != null) {
          final PurchaseDetails purchased = shop.getPastPurchases.firstWhere(
            (PurchaseDetails purchase) => purchase.productID == shop.getAdProduct.id,
            orElse: () => null,
          );

          buyRemoveAdsButton = GestureDetector(
            onTap: () {
              deviceProvider.playSound(sound: 'fast_click.wav');
              shop.buyProduct(product: shop.getAdProduct, callback: purchaseCallbackAlert);
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
                    // shop.getAdProduct.id.substring(0, shop.getAdProduct.id.indexOf('(')),
                    shop.getAdProduct.id,
                    style: CustomTextTheme(deviceProvider: deviceProvider)
                        .selectPictureButtonTextStyle(),
                  ),
                  Text(
                    purchased != null ? 'Purchased' : shop.getAdProduct.price,
                    style: CustomTextTheme(deviceProvider: deviceProvider)
                        .selectPictureButtonTextStyle(),
                  ),
                ],
              ),
            ),
          );
        } else {
          buyRemoveAdsButton = Container();
        }
        return buyRemoveAdsButton;
      },
    );
  }
}
