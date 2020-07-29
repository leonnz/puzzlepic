import 'package:flutter/material.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:provider/provider.dart';

import '../providers/device_provider.dart';
import '../components/buttons/appbar_leading_button.dart';
import '../styles/customStyles.dart';

import 'dart:io';
import 'dart:async';

class ShopScreen extends StatefulWidget {
  createState() => _ShopScreenState();
}

class _ShopScreenState extends State<ShopScreen> {
  final String removeAdsID = 'remove_ads';
  final List<String> imagePackProductIDs = ['category_natural_wonders'];

  InAppPurchaseConnection _iap = InAppPurchaseConnection.instance;
  StreamSubscription<List<PurchaseDetails>> _subscription;

  List<ProductDetails> _removeAdProduct = [];
  List<ProductDetails> _imagePackProducts = [];

  List<PurchaseDetails> _purchases = [];

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

  void _initialize() async {
    _available = await _iap.isAvailable();

    if (_available) {
      List<Future> futures = [_getProducts(), _getPastPurchases()];
      await Future.wait(futures);

      _verifyPurchase();

      _subscription = _iap.purchaseUpdatedStream.listen((data) {
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
    Set<String> removeAdsIDSet = Set.from([removeAdsID]);
    Set<String> imagePackIDSet =
        Set.from([imagePackProductIDs].expand((product) => product));

    ProductDetailsResponse responseRemoveAd =
        await _iap.queryProductDetails(removeAdsIDSet);

    ProductDetailsResponse responseImagePack =
        await _iap.queryProductDetails(imagePackIDSet);

    setState(() {
      _removeAdProduct = responseRemoveAd.productDetails;
      _imagePackProducts = responseImagePack.productDetails;
      print(_removeAdProduct.length);
      print(_imagePackProducts.length);
    });
  }

  Future<void> _getPastPurchases() async {
    QueryPurchaseDetailsResponse response = await _iap.queryPastPurchases();

    for (PurchaseDetails purchase in response.pastPurchases) {
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
      (purchase) => purchase.productID == productID,
      orElse: () => null,
    );
  }

  void _verifyPurchase() {
    PurchaseDetails purchase = _hasPurchased(removeAdsID);

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
    DeviceProvider deviceProvider = Provider.of<DeviceProvider>(context);
    return Scaffold(
      appBar: PreferredSize(
        preferredSize:
            Size.fromHeight(deviceProvider.getDeviceScreenHeight * 0.10),
        child: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage(
                  'assets/images/_categories/_categories_banner.png'),
              fit: BoxFit.cover,
            ),
            boxShadow: [
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
      body: Column(
        children: <Widget>[
          Expanded(
            child: ListView.builder(
              itemCount: _removeAdProduct.length,
              padding: EdgeInsets.all(20),
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    deviceProvider.playSound(sound: 'fast_click.wav');
                    _buyProduct(_removeAdProduct[index]);
                  },
                  child: Container(
                    padding: EdgeInsets.all(10),
                    height: deviceProvider.getUseMobileLayout ? 50 : 70,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black45,
                          blurRadius: 3.0,
                          offset: Offset(0.0, 2.0),
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
                              : "Purchased",
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
    );
  }
}
