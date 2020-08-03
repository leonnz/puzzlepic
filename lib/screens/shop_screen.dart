import 'package:flutter/material.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:provider/provider.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import '../components/buttons/appbar_leading_button.dart';
import '../components/shop_screen/image_pack_list.dart';
import '../components/shop_screen/remove_ad_shop_button.dart';
import '../components/shop_screen/shop_error_message.dart';
import '../providers/device_provider.dart';
import '../providers/shop_provider.dart';
import '../styles/custom_styles.dart';

class ShopScreen extends StatefulWidget {
  @override
  _ShopScreenState createState() => _ShopScreenState();
}

class _ShopScreenState extends State<ShopScreen> {
  @override
  void initState() {
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
      onWillPop: () async {
        final bool quit = shopProvider.cancelSubscription();
        return quit;
      },
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(deviceProvider.getDeviceScreenHeight * 0.10),
          child: Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/_categories/_categories_banner.png'),
                fit: BoxFit.cover,
              ),
              boxShadow: <BoxShadow>[
                BoxShadow(
                  color: Colors.black45,
                  blurRadius: 5.0,
                  offset: Offset(0.0, 3.0),
                ),
              ],
            ),
            child: Stack(
              alignment: Alignment.center,
              children: <Widget>[
                AppBarLeadingButton(
                  icon: Icons.close,
                  customOperation: shopProvider.cancelSubscription,
                ),
                Text(
                  'Shop',
                  style: CustomTextTheme(deviceProvider: deviceProvider)
                      .selectScreenTitleTextStyle(context),
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
                          : Container(
                              color: Colors.white,
                              child: Center(
                                child: SpinKitFadingFour(
                                  color: Colors.purple,
                                  size: deviceProvider.getUseMobileLayout ? 50 : 80,
                                ),
                              ),
                            );
                },
              )
            : const ShopErrorMessage(
                message: 'No Internet connection',
              ),
      ),
    );
  }
}
