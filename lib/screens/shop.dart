import 'package:flutter/material.dart';
import 'package:in_app_purchase/in_app_purchase.dart';

import 'dart:io';
import 'dart:async';

final String testId = 'remove_ads';

class ShopScreen extends StatefulWidget {
  createState() => _ShopScreenState();
}

class _ShopScreenState extends State<ShopScreen> {
  InAppPurchaseConnection _iap = InAppPurchaseConnection.instance;
  StreamSubscription<List<PurchaseDetails>> _subscription;

  List<ProductDetails> _products = [];
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
      print(_available);
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
    Set<String> ids = Set.from([testId]);
    ProductDetailsResponse response = await _iap.queryProductDetails(ids);

    setState(() {
      _products = response.productDetails;
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
    PurchaseDetails purchase = _hasPurchased(testId);
    if (purchase != null && purchase.status == PurchaseStatus.purchased) {
      removedAdsPurchased = true;
    }
  }

  void _buyProduct(ProductDetails prod) {
    final PurchaseParam purchaseParam = PurchaseParam(productDetails: prod);
    // _iap.buyNonConsumable(purchaseParam: purchaseParam);
    _iap.buyConsumable(purchaseParam: purchaseParam);
    removedAdsPurchased = true;
    print('product bought');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          Text('test'),
          for (var prod in _products)
            if (_hasPurchased(prod.id) != null) ...[
              Text('Already purchased'),
            ] else ...[
              Text(prod.title),
              Text(prod.description),
              Text(prod.price),
              FlatButton(
                child: Text('BUY IT!!!'),
                color: Colors.green,
                onPressed: () => _buyProduct(prod),
              )
            ]
        ],
      ),
    );
  }
}
