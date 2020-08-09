import 'package:flutter/material.dart';
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
import 'purchase_message.dart';

class ShopScreen extends StatefulWidget {
  @override
  _ShopScreenState createState() => _ShopScreenState();
}

class _ShopScreenState extends State<ShopScreen> with SingleTickerProviderStateMixin {
  @override
  void initState() {
    print('shop screen loaded');
    final ShopProvider shopProvider = Provider.of<ShopProvider>(context, listen: false);
    shopProvider.registerSubscription();

    ShopProvider.puchaseMessageController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );

    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final DeviceProvider deviceProvider = Provider.of<DeviceProvider>(context);
    final ShopProvider shopProvider = Provider.of<ShopProvider>(context);

    return WillPopScope(
      onWillPop: () async {
        final bool quit = shopProvider.cancelSubscription();
        return quit;
      },
      child: Container(
        decoration: CustomElementTheme.screenBackgroundBoxDecoration(),
        child: Stack(
          children: <Widget>[
            Scaffold(
              backgroundColor: const Color.fromRGBO(255, 255, 255, 0.7),
              appBar: PreferredSize(
                preferredSize: Size.fromHeight(deviceProvider.getDeviceScreenHeight * 0.10),
                child: Container(
                  decoration: CustomElementTheme.shopScreenAppBarBoxDecoration(),
                  child: Stack(
                    alignment: Alignment.center,
                    children: <Widget>[
                      AppBarLeadingButton(
                        icon: Icons.close,
                        customOperation: shopProvider.cancelSubscription,
                      ),
                      Text(
                        'Store',
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
                                children: const <Widget>[
                                  RemoveAdShopButton(),
                                  Text('Image Packs'),
                                  ImagePackList(),
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
            if (shopProvider.getShowSuccessMessage) ...<Widget>[
              const PurchaseMessage(),
            ] else ...<Widget>[
              Container()
            ],
          ],
        ),
      ),
    );
  }
}
