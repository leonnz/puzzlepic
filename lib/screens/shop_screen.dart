import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:provider/provider.dart';

import '../components/buttons/appbar_leading_button.dart';
import '../components/shop_screen/image_pack_list.dart';
import '../components/shop_screen/remove_ad_shop_button.dart';
import '../components/shop_screen/shop_data.dart';
import '../providers/device_provider.dart';
import '../styles/custom_styles.dart';

class ShopScreen extends StatefulWidget {
  @override
  _ShopScreenState createState() => _ShopScreenState();
}

class _ShopScreenState extends State<ShopScreen> {
  // Initial Shop data
  List<ProductDetails> _removeAdsProduct = <ProductDetails>[];
  static List<ProductDetails> _imagePackProducts = <ProductDetails>[];
  static List<PurchaseDetails> _purchases = <PurchaseDetails>[];

  // App Store connections
  static final InAppPurchaseConnection _iap = InAppPurchaseConnection.instance;
  StreamSubscription<List<PurchaseDetails>> _subscription;

  Future<void> _getPastPurchases() async {
    final QueryPurchaseDetailsResponse response = await _iap.queryPastPurchases();

    for (final PurchaseDetails purchase in response.pastPurchases) {
      if (Platform.isIOS) {
        InAppPurchaseConnection.instance.completePurchase(purchase);
      }
    }

    _purchases = response.pastPurchases;
    print('Purchases: ${_purchases.length}');
  }

  Future<void> _getRemoveAdsProductFromAppStore() async {
    final Set<String> removeAdsIDSet = <String>{ShopData.removeAdsID};

    final ProductDetailsResponse responseRemoveAd = await _iap.queryProductDetails(removeAdsIDSet);

    setState(() {
      _removeAdsProduct = responseRemoveAd.productDetails;
    });
    print('Remove ad products ${_removeAdsProduct.length}');
  }

  Future<void> _getImagePackProductsFromAppStore() async {
    final Set<String> imagePackIDSet = Set<String>.from(
        <List<String>>[ShopData.imagePackProductIDs].expand((List<String> product) => product));

    final ProductDetailsResponse responseImagePacks =
        await _iap.queryProductDetails(imagePackIDSet);

    setState(() {
      _imagePackProducts = responseImagePacks.productDetails;
    });

    print('Image pack products ${_imagePackProducts.length}');
  }

  Future<void> _initialize() async {
    final bool available = await _iap.isAvailable();

    if (available) {
      print('available');

      final List<Future<void>> futures = <Future<void>>[
        _getPastPurchases(),
        _getRemoveAdsProductFromAppStore(),
        _getImagePackProductsFromAppStore(),
      ];
      await Future.wait(futures);

      // verifyPurchase();

      _subscription = _iap.purchaseUpdatedStream.listen((List<PurchaseDetails> data) {
        setState(() {
          print('NEW PURCHASE');
          _purchases.addAll(data);
          // _verifyPurchase();
        });
      });
    } else {
      print('fail');
    }
  }

  @override
  void initState() {
    _initialize();
    super.initState();
  }

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final DeviceProvider deviceProvider = Provider.of<DeviceProvider>(context);

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(deviceProvider.getDeviceScreenHeight * 0.10),
        child: Container(
          decoration: BoxDecoration(
            image: const DecorationImage(
              image: AssetImage('assets/images/_categories/_categories_banner.png'),
              fit: BoxFit.cover,
            ),
            boxShadow: <BoxShadow>[
              BoxShadow(
                color: Colors.black45,
                blurRadius: 5.0,
                offset: const Offset(0.0, 3.0),
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
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          if (_removeAdsProduct.isNotEmpty)
            RemoveAdShopButton(
              removeAdProduct: _removeAdsProduct[0],
            ),
          const Text('Image Packs'),
          if (_imagePackProducts.isNotEmpty)
            ImagePackList(
              imagePackProducts: _imagePackProducts,
            ),
          const Spacer(),
        ],
      ),
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
