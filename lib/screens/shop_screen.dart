import 'package:flutter/material.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:provider/provider.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import '../components/buttons/appbar_leading_button.dart';
import '../components/shop_screen/image_pack_list.dart';
import '../components/shop_screen/remove_ad_shop_button.dart';
import '../providers/device_provider.dart';
import '../providers/shop_provider.dart';
import '../styles/custom_styles.dart';

class ShopScreen extends StatefulWidget {
  @override
  _ShopScreenState createState() => _ShopScreenState();
}

class _ShopScreenState extends State<ShopScreen> {
  // bool shopLoaded;

  @override
  void initState() {
    // shopLoaded = false;
    // ShopProvider().initialize();
    final ShopProvider shopProvider = Provider.of<ShopProvider>(context, listen: false);
    shopProvider.initialize();
    super.initState();
  }

  @override
  void didChangeDependencies() {
    // final ShopProvider shopProvider = Provider.of<ShopProvider>(context);
    // // loadShop(shop: shopProvider);
    // shopProvider.initialize();

    super.didChangeDependencies();
  }

  @override
  void dispose() {
    print('disposed');
    super.dispose();
  }

  // Future<void> loadShop({ShopProvider shop}) async {
  //   final bool result = await shop.initialize();
  //   if (result) {
  //     Future<void>.delayed(const Duration(milliseconds: 500)).then(
  //       (_) {
  //         if (mounted) {
  //           setState(() {
  //             shopLoaded = true;
  //           });
  //         }
  //       },
  //     );
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    final DeviceProvider deviceProvider = Provider.of<DeviceProvider>(context);
    // final ShopProvider shopProvider = Provider.of<ShopProvider>(context, listen: false);

    // // // // loadShop(shop: shopProvider);
    // shopProvider.initialize();

    return Scaffold(
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
                AppBarLeadingButton(icon: Icons.close),
                Text(
                  'Shop',
                  style: CustomTextTheme(deviceProvider: deviceProvider)
                      .selectScreenTitleTextStyle(context),
                ),
              ],
            ),
          ),
        ),
        body: Consumer<ShopProvider>(
          builder: (BuildContext context, ShopProvider value, Widget child) {
            return Column(
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
              ],
            );
          },
          // child:
        )
        // : Container(
        //     color: Colors.white,
        //     child: Center(
        //       child: SpinKitFadingFour(
        //         color: Colors.purple,
        //         size: deviceProvider.getUseMobileLayout ? 50 : 80,
        //       ),
        //     ),
        //   ),
        );
  }
}

// Column(
//   children: <Widget>[
//     Text('test'),

// for (var prod in _products)
//   if (_hasPurchased(prod.id) != null) ...[
//     Text('Already purchased'),
//   ] else ...[
//     ListView.builder(
//       itemCount: _products.length,
//       itemBuilder: (context, index) {
//         return Container(
//           child: Text(_products[index].title),
//         );
//       },
//     ),
//     Text(prod.title),
//     Text(prod.description),
//     Text(prod.price),
//     FlatButton(
//       child: Text('BUY IT!!!'),
//       color: Colors.green,
//       onPressed: () => _buyProduct(prod),
//     )
//   ]
//   ],
// ),
