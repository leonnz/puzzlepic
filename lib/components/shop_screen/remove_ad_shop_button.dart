import 'package:flutter/material.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:provider/provider.dart';

import '../../providers/device_provider.dart';
import '../../providers/shop_provider.dart';
import '../../styles/element_theme.dart';
import '../../styles/text_theme.dart';
import 'purchase_alert.dart';
import 'shop_buy_button.dart';

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
              decoration: CustomElementTheme.shopButtonBoxDecoration(),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    shop.getAdProduct.title.substring(0, shop.getAdProduct.title.indexOf('(')),
                    style: CustomTextTheme.selectPictureButtonTextStyle(),
                  ),
                  if (purchased != null) ...<Widget>[
                    ShopBuyButton(imagePackProductPrice: shop.getAdProduct.price),
                  ] else ...<Widget>[
                    ShopBuyButton(
                      imagePackProductPrice: shop.getAdProduct.price,
                      onClickAction: () {
                        deviceProvider.playSound(sound: 'fast_click.wav');
                        shop.buyProduct(
                            product: shop.getAdProduct, callback: purchaseCallbackAlert);
                      },
                    ),
                  ]
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
