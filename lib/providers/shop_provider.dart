import 'dart:async';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:in_app_purchase/in_app_purchase.dart';

class ShopProvider extends ChangeNotifier {
  static final InAppPurchaseConnection _iap = InAppPurchaseConnection.instance;
  StreamSubscription<List<PurchaseDetails>> _subscription;

  static const String _removeAdProductId = 'test1';
  String get getRemoveAdProductId => _removeAdProductId;

  static const List<String> _productIds = <String>[
    'test8',
    'test9',
    'test10',
    'test11',
    'test12',
    'test13',
    'test14',
    'test15',
    'test16',
    'test17',
    'test18',
    'test19',
    'test20',
  ];

  ProductDetails _adProduct;
  ProductDetails get getAdProduct => _adProduct;

  List<ProductDetails> _imagePackProducts = <ProductDetails>[];
  List<ProductDetails> get getImagePackProducts => _imagePackProducts;

  List<PurchaseDetails> _pastPurchases = <PurchaseDetails>[];
  List<PurchaseDetails> get getPastPurchases => _pastPurchases;

  bool _available = false;
  bool get getAvailable => _available;

  bool _timeout = false;
  bool get getTimedout => _timeout;

  Future<bool> initialize() async {
    try {
      _available = await _iap.isAvailable().timeout(
        const Duration(milliseconds: 5000),
        onTimeout: () {
          return false;
        },
      );
    } on TimeoutException catch (_) {}
    if (_available) {
      _pastPurchases = await getPastPurchasesFromAppStore();
      _adProduct = await getRemoveAdProductFromAppStore();
      _imagePackProducts = await getImageProductsFromAppStore();
      _subscription = _iap.purchaseUpdatedStream.listen((List<PurchaseDetails> purchases) {
        completePurchase(purchases);
      });
    } else {
      _timeout = true;
    }
    notifyListeners();
    return _available;
  }

  Future<void> completePurchase(List<PurchaseDetails> purchases) async {
    for (final PurchaseDetails purchase in purchases) {
      if (purchase.status == PurchaseStatus.purchased) {
        final BillingResultWrapper billingResult = await _iap.completePurchase(purchase);

        if (billingResult.responseCode == BillingResponse.ok) {
          _pastPurchases.addAll(purchases);
          notifyListeners();
        } else if (billingResult.responseCode == BillingResponse.error ||
            billingResult.responseCode == BillingResponse.serviceUnavailable) {
          // completePurchase(purchases);
          print('BILLING ERROR');
        }
      } else {
        print('Purchase status ${purchase.status}');
      }
    }
  }

  bool cancelSubscription() {
    _subscription?.cancel();
    return true;
  }

  Future<ProductDetails> getRemoveAdProductFromAppStore() async {
    final Set<String> productIdsSet = Set<String>.from(<String>{_removeAdProductId});

    final ProductDetailsResponse response = await _iap.queryProductDetails(productIdsSet);

    return response.productDetails[0];
  }

  Future<List<ProductDetails>> getImageProductsFromAppStore() async {
    final Set<String> productIdsSet =
        Set<String>.from(<List<String>>[_productIds].expand((List<String> product) => product));

    final ProductDetailsResponse reponse = await _iap.queryProductDetails(productIdsSet);
    return reponse.productDetails;
  }

  Future<List<PurchaseDetails>> getPastPurchasesFromAppStore() async {
    final QueryPurchaseDetailsResponse response = await _iap.queryPastPurchases();
    for (final PurchaseDetails purchase in response.pastPurchases) {
      if (Platform.isIOS) {
        InAppPurchaseConnection.instance.completePurchase(purchase);
      }
    }

    if (response.error != null) {
      print(response.error);
    }

    return response.pastPurchases;
  }

  // void verifyPurchase() {
  //   final PurchaseDetails purchase = hasPurchased(_removeAdsID);

  //   if (purchase != null && purchase.status == PurchaseStatus.purchased) {
  //     print(purchase.productID);
  //     print(purchase.purchaseID);
  //     print(purchase.status);
  //     print(purchase.verificationData.source);
  //     // setRemovedAdsPurchased();
  //   }
  // }

  Future<void> buyProduct(ProductDetails prod) async {
    final PurchaseParam purchaseParam = PurchaseParam(productDetails: prod);
    await _iap.buyNonConsumable(purchaseParam: purchaseParam);
    // _iap.buyConsumable(purchaseParam: purchaseParam);
  }
}
