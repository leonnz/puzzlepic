import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../components/_shared/appbar_leading_button.dart';
import '../components/_shared/loading_animation.dart';
import '../components/shop_screen/product_list.dart';
import '../components/shop_screen/purchase_message.dart';
import '../components/shop_screen/shop_error_message.dart';
import '../providers/device_provider.dart';
import '../providers/shop_provider.dart';
import '../styles/box_decoration_styes.dart';
import '../styles/text_styles.dart';

class ShopScreen extends StatefulWidget {
  const ShopScreen({Key key}) : super(key: key);

  @override
  _ShopScreenState createState() => _ShopScreenState();
}

class _ShopScreenState extends State<ShopScreen> {
  @override
  void initState() {
    final ShopProvider shopProvider = Provider.of<ShopProvider>(context, listen: false);
    shopProvider.registerSubscription();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final DeviceProvider deviceProvider = Provider.of<DeviceProvider>(context, listen: false);
    final ShopProvider shopProvider = Provider.of<ShopProvider>(context);

    return WillPopScope(
      onWillPop: () async {
        final bool quit = shopProvider.cancelSubscription();
        return quit;
      },
      child: Container(
        decoration: kScreenBackgroundBoxDecoration,
        child: SafeArea(
          child: Scaffold(
            backgroundColor: const Color.fromRGBO(255, 255, 255, 0.7),
            appBar: PreferredSize(
              preferredSize: Size.fromHeight(deviceProvider.getDeviceScreenHeight * 0.10),
              child: Container(
                decoration: kShopScreenAppBarBoxDecoration,
                child: Stack(
                  alignment: Alignment.center,
                  children: <Widget>[
                    AppBarLeadingButton(
                      icon: Icons.close,
                      customOperation: shopProvider.cancelSubscription,
                    ),
                    Text(
                      'Store',
                      style: kSelectScreenTitleTextStyle,
                    ),
                  ],
                ),
              ),
            ),

            //DEV ONLY - Test on Emulator where shop connection doesn't work.
            // body: Center(
            //   child: Column(
            //     children: const <Widget>[
            //       ProductList(),
            //     ],
            //   ),
            // ),
            body: Stack(
              children: <Widget>[
                if (deviceProvider.getHasInternetConnection) ...<Widget>[
                  Consumer<ShopProvider>(
                    builder: (BuildContext context, ShopProvider value, Widget child) {
                      return shopProvider.getShopAvailable
                          ? Center(
                              child: Column(
                                children: const <Widget>[
                                  ProductList(),
                                ],
                              ),
                            )
                          : shopProvider.getTimedout
                              ? const ShopErrorMessage(
                                  message: 'Problem connecting to store',
                                )
                              : const LoadingAnimation();
                    },
                  )
                ] else ...<Widget>[
                  const ShopErrorMessage(
                    message: 'No Internet connection',
                  ),
                ],
                const PurchaseMessage(),
              ],
            ),
            bottomNavigationBar: shopProvider.getBannerAdLoaded
                ? Container(
                    height: 60,
                    color: Colors.white,
                  )
                : null,
          ),
        ),
      ),
    );
  }
}
