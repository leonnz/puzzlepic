import 'package:flutter/material.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:provider/provider.dart';

import '../../providers/device_provider.dart';
import '../../providers/shop_provider.dart';
import '../../styles/element_theme.dart';
import '../../styles/text_theme.dart';
import '../_custom_widgets/custom_expansion_tile.dart';
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

        return Container(
          margin: const EdgeInsets.all(10),
          width: double.infinity,
          decoration: CustomElementTheme.shopButtonBoxDecoration(),
          child: CustomExpansionTile(
            trailing: Text(
              purchased != null ? 'Purchased' : imagePackProduct.price,
              style: CustomTextTheme.selectPictureButtonTextStyle(),
            ),
            title: Text(
                // imagePackProduct.title.substring(0, imagePackProduct.title.indexOf('(')),
                imagePackProduct.id),
            backgroundColor: Colors.white,
            expandedAlignment: Alignment.centerLeft,
            childrenPadding: const EdgeInsets.only(top: 5, bottom: 16, left: 16, right: 16),
            children: <Widget>[
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Expanded(
                      child: Text(
                          'Lorem Ipsum is simply dummy text of the a s d f and typesetting industry 11111.' // 80 character limit
                          // imagePackProduct.description,
                          )),
                  if (purchased != null) ...<Widget>[
                    Container(),
                  ] else ...<Widget>[
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: RaisedButton(
                        color: Colors.green,
                        onPressed: () {
                          deviceProvider.playSound(sound: 'fast_click.wav');
                          shop.buyProduct(
                              product: imagePackProduct, callback: purchaseCallbackAlert);
                        },
                        child: Text(
                          'Buy',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ]
                ],
              ),
              Row(
                children: [
                  Text(
                    'samples',
                  ),
                ],
              ),
              GridView.builder(
                shrinkWrap: true,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                ),
                itemCount: 4,
                itemBuilder: (BuildContext context, int i) {
                  return Image(
                    image: AssetImage('assets/images/_categories/test18_cat.png'),
                  );
                },
              )
            ],
          ),
        );
      },
    );
  }
}
