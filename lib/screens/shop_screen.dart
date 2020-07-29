import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:provider/provider.dart';

import '../components/buttons/appbar_leading_button.dart';
import '../providers/device_provider.dart';
import '../styles/customStyles.dart';

class ShopScreen extends StatefulWidget {
  @override
  _ShopScreenState createState() => _ShopScreenState();
}

class _ShopScreenState extends State<ShopScreen> {
  final String removeAdsID = 'remove_ads';
  final List<String> imagePackProductIDs = <String>['category_natural_wonders'];

  final InAppPurchaseConnection _iap = InAppPurchaseConnection.instance;
  StreamSubscription<List<PurchaseDetails>> _subscription;

  List<ProductDetails> _removeAdProduct = <ProductDetails>[];
  List<ProductDetails> _imagePackProducts = <ProductDetails>[];

  List<PurchaseDetails> _purchases = <PurchaseDetails>[];

  bool _available = false;
  bool removedAdsPurchased;

  @override
  void initState() {
    _initialize();
    super.initState();
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }

  Future<void> _initialize() async {
    _available = await _iap.isAvailable();

    if (_available) {
      final List<Future<void>> futures = <Future<void>>[
        _getProducts(),
        _getPastPurchases()
      ];
      await Future.wait(futures);

      _verifyPurchase();

      _subscription =
          _iap.purchaseUpdatedStream.listen((List<PurchaseDetails> data) {
        setState(() {
          print('NEW PURCHASE');
          _purchases.addAll(data);
        });
      });
    } else {
      print('fail');
    }
  }

  Future<void> _getProducts() async {
    final Set<String> removeAdsIDSet = <String>{removeAdsID};

    final Set<String> imagePackIDSet = Set<String>.from(<List<String>>[
      imagePackProductIDs
    ].expand((List<String> product) => product));

    final ProductDetailsResponse responseRemoveAd =
        await _iap.queryProductDetails(removeAdsIDSet);

    final ProductDetailsResponse responseImagePack =
        await _iap.queryProductDetails(imagePackIDSet);

    setState(() {
      _removeAdProduct = responseRemoveAd.productDetails;
      _imagePackProducts = responseImagePack.productDetails;
      print(_removeAdProduct.length);
      print(_imagePackProducts.length);
    });
  }

  Future<void> _getPastPurchases() async {
    final QueryPurchaseDetailsResponse response =
        await _iap.queryPastPurchases();

    for (final PurchaseDetails purchase in response.pastPurchases) {
      if (Platform.isIOS) {
        InAppPurchaseConnection.instance.completePurchase(purchase);
      }
    }

    setState(() {
      _purchases = response.pastPurchases;
    });
  }

  PurchaseDetails _hasPurchased(String productID) {
    return _purchases.firstWhere(
      (PurchaseDetails purchase) => purchase.productID == productID,
      orElse: () => null,
    );
  }

  void _verifyPurchase() {
    final PurchaseDetails purchase = _hasPurchased(removeAdsID);

    if (purchase != null && purchase.status == PurchaseStatus.purchased) {
      print(purchase.productID);
      print(purchase.purchaseID);
      print(purchase.status);
      print(purchase.verificationData.source);
      removedAdsPurchased = true;
    }
  }

  void _buyProduct(ProductDetails prod) {
    final PurchaseParam purchaseParam = PurchaseParam(productDetails: prod);
    _iap.buyNonConsumable(purchaseParam: purchaseParam);
    // _iap.buyConsumable(purchaseParam: purchaseParam);
    removedAdsPurchased = true;
    print('product bought');
  }

  @override
  Widget build(BuildContext context) {
    final DeviceProvider deviceProvider = Provider.of<DeviceProvider>(context);
    return Scaffold(
      appBar: PreferredSize(
        preferredSize:
            Size.fromHeight(deviceProvider.getDeviceScreenHeight * 0.10),
        child: Container(
          decoration: BoxDecoration(
            image: const DecorationImage(
              image: AssetImage(
                  'assets/images/_categories/_categories_banner.png'),
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
        children: <Widget>[
          Expanded(
            child: ListView.builder(
              itemCount: _removeAdProduct.length,
              padding: const EdgeInsets.all(20),
              itemBuilder: (BuildContext context, int index) {
                return GestureDetector(
                  onTap: () {
                    deviceProvider.playSound(sound: 'fast_click.wav');
                    _buyProduct(_removeAdProduct[index]);
                  },
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    height: deviceProvider.getUseMobileLayout ? 50 : 70,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: const BorderRadius.all(Radius.circular(10)),
                      boxShadow: <BoxShadow>[
                        BoxShadow(
                          color: Colors.black45,
                          blurRadius: 3.0,
                          offset: const Offset(0.0, 2.0),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                          _removeAdProduct[index].title,
                          style: CustomTextTheme(deviceProvider: deviceProvider)
                              .selectPictureButtonTextStyle(),
                        ),
                        Text(
                          _hasPurchased(_removeAdProduct[index].id) == null
                              ? _removeAdProduct[index].price
                              : 'Purchased',
                          style: CustomTextTheme(deviceProvider: deviceProvider)
                              .selectPictureButtonTextStyle(),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
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
