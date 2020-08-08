import 'package:flutter/material.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:provider/provider.dart';

import '../../data/images_data.dart';
import '../../providers/device_provider.dart';
import '../../providers/shop_provider.dart';
import '../../styles/element_theme.dart';
import '../_custom_widgets/custom_expansion_tile.dart';
import 'image_pack_buy_button.dart';
import 'purchase_alert.dart';

class ImagePackShopTile extends StatelessWidget {
  const ImagePackShopTile({
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
            title: Text(
              purchased != null
                  ? '${imagePackProduct.title.substring(0, imagePackProduct.title.indexOf('('))}(purchased)'
                  : imagePackProduct.title.substring(0, imagePackProduct.title.indexOf('(')),
            ),
            backgroundColor: Colors.white,
            expandedAlignment: Alignment.centerLeft,
            childrenPadding: const EdgeInsets.only(top: 5, bottom: 16, left: 16, right: 16),
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Expanded(
                        child: Text(
                      imagePackProduct.description,
                    )),
                    if (purchased != null) ...<Widget>[
                      ImagePackBuyButton(imagePackProductPrice: imagePackProduct.price),
                    ] else ...<Widget>[
                      ImagePackBuyButton(
                        imagePackProductPrice: imagePackProduct.price,
                        onClickAction: () {
                          deviceProvider.playSound(sound: 'fast_click.wav');
                          shop.buyProduct(
                              product: imagePackProduct, callback: purchaseCallbackAlert);
                        },
                      )
                    ]
                  ],
                ),
              ),
              GridView.builder(
                primary: false,
                shrinkWrap: true,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                ),
                itemCount: 12,
                itemBuilder: (BuildContext context, int i) {
                  final List<Map<String, dynamic>> previewImages = Images.imageList.firstWhere(
                          (Map<String, dynamic> imageList) =>
                              imageList['categoryName'] == 'animals')['categoryImages']
                      as List<Map<String, dynamic>>;

                  return ClipRRect(
                    borderRadius: BorderRadius.circular(5),
                    child: Image(
                      image: AssetImage(
                          // 'assets/images/${imagePackProduct.id}/${previewImages[i]['assetName']}_full_mini.jpg'),

                          'assets/images/_categories/test20_cat.png'),
                    ),
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
