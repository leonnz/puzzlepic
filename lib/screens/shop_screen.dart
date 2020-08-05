import 'package:flutter/material.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:provider/provider.dart';

import '../components/_shared/appbar_leading_button.dart';
import '../components/_shared/loading_animation.dart';
import '../components/shop_screen/image_pack_list.dart';
import '../components/shop_screen/remove_ad_shop_button.dart';
import '../components/shop_screen/shop_error_message.dart';
import '../providers/device_provider.dart';
import '../providers/shop_provider.dart';
import '../styles/element_theme.dart';
import '../styles/text_theme.dart';

class ShopScreen extends StatefulWidget {
  @override
  _ShopScreenState createState() => _ShopScreenState();
}

class _ShopScreenState extends State<ShopScreen> {
  @override
  void initState() {
    print('shop screen loaded');
    final ShopProvider shopProvider = Provider.of<ShopProvider>(context, listen: false);
    shopProvider.registerSubscription();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final DeviceProvider deviceProvider = Provider.of<DeviceProvider>(context);
    final ShopProvider shopProvider = Provider.of<ShopProvider>(context, listen: false);

    return WillPopScope(
      // TODO maybe dont cancel this
      onWillPop: () async {
        final bool quit = shopProvider.cancelSubscription();
        return quit;
      },
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(deviceProvider.getDeviceScreenHeight * 0.10),
          child: Container(
            decoration: CustomElementTheme.appBarBoxDecoration(
                image: 'assets/images/_categories/_categories_banner.png'),
            child: Stack(
              alignment: Alignment.center,
              children: <Widget>[
                AppBarLeadingButton(
                  icon: Icons.close,
                  customOperation: shopProvider.cancelSubscription,
                ),
                Text(
                  'Shop',
                  style: CustomTextTheme.selectScreenTitleTextStyle(context),
                ),
              ],
            ),
          ),
        ),
        body: deviceProvider.getHasInternetConnection
            ? Consumer<ShopProvider>(
                builder: (BuildContext context, ShopProvider value, Widget child) {
                  return shopProvider.getAvailable
                      ? Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            const RemoveAdShopButton(),
                            const Text('Image Packs'),
                            const ImagePackList(),
                            // const Spacer(),
                            Text('past purchases ${value.getPastPurchases.length}'),
                            for (PurchaseDetails purchase in value.getPastPurchases) ...<Widget>[
                              Text('past purchase: ${purchase.productID}')
                            ],
                            // Text('Ad product ${shopProvider.getAdProduct}'),
                            Text('image products ${value.getImagePackProducts.length}'),
                            Text('${deviceProvider.getHasInternetConnection}')
                          ],
                        )
                      : shopProvider.getTimedout
                          ? const ShopErrorMessage(
                              message: 'Problem connecting to store',
                            )
                          : const LoadingAnimation();
                },
              )
            : const ShopErrorMessage(
                message: 'No Internet connection',
              ),
      ),
    );
  }
}
