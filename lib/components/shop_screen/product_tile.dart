import 'package:flutter/material.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:provider/provider.dart';

import '../../data/images_data.dart';
import '../../providers/device_provider.dart';
import '../../providers/shop_provider.dart';
import '../../styles/element_theme.dart';
import '../_custom_widgets/custom_expansion_tile.dart';
import 'purchase_alert.dart';
import 'shop_buy_button.dart';

class ProductTile extends StatelessWidget {
  const ProductTile({
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
          margin: const EdgeInsets.only(bottom: 5, top: 5, left: 10, right: 10),
          decoration: CustomElementTheme.shopButtonBoxDecoration(),
          child: CustomExpansionTile(
            trailing: purchased != null
                ? ShopBuyButton(imagePackProductPrice: imagePackProduct.price)
                : ShopBuyButton(
                    imagePackProductPrice: imagePackProduct.price,
                    onClickAction: () {
                      deviceProvider.playSound(sound: 'fast_click.wav');
                      shop.buyProduct(product: imagePackProduct, callback: purchaseCallbackAlert);
                    },
                  ),
            title: Text(
              imagePackProduct.title.substring(0, imagePackProduct.title.indexOf('(')),
            ),
            subtitle: purchased != null ? const Text('(purchased)') : null,
            // subtitle: const Text('(purchased)'),
            backgroundColor: Colors.white,
            expandedAlignment: Alignment.centerLeft,
            childrenPadding: const EdgeInsets.only(top: 5, bottom: 16, left: 16, right: 16),
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(top: 10, bottom: 20),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Expanded(child: Text(imagePackProduct.description)),
                  ],
                ),
              ),
              if (imagePackProduct.id != 'removeads') ...<Widget>[
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
                                imageList['categoryName'] == imagePackProduct.id)['categoryImages']
                        as List<Map<String, dynamic>>;

                    return ClipRRect(
                      borderRadius: BorderRadius.circular(5),
                      child: Image(
                        image: AssetImage(
                            'assets/images/${imagePackProduct.id}/${previewImages[i]['assetName']}_full_mini.jpg'),
                      ),
                    );
                  },
                ),
              ]
            ],
          ),
        );
      },
    );
  }
}
