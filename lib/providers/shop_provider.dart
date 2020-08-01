import 'dart:async';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:in_app_purchase/in_app_purchase.dart';

class ShopProvider extends ChangeNotifier {
  static final InAppPurchaseConnection _iap = InAppPurchaseConnection.instance;
  StreamSubscription<List<PurchaseDetails>> subscription;

  static const String _removeAdProductId = 'remove_ads';

  static const List<String> _productIds = <String>[
    'category_natural_wonders',
    'category_sports',
  ];

  ProductDetails _adProduct;
  ProductDetails get getAdProduct => _adProduct;

  List<ProductDetails> _imagePackProducts = <ProductDetails>[];
  List<ProductDetails> get getImagePackProducts => _imagePackProducts;

  List<PurchaseDetails> _pastPurchases = <PurchaseDetails>[];
  List<PurchaseDetails> get getPastPurchases => _pastPurchases;

  static bool available = false;

  Future<bool> initialize() async {
    available = await _iap.isAvailable();

    if (available) {
      _pastPurchases = await getPastPurchasesFromAppStore();
      _adProduct = await getRemoveAdProductFromAppStore();
      _imagePackProducts = await getImageProductsFromAppStore();

      subscription = _iap.purchaseUpdatedStream.listen((List<PurchaseDetails> purchases) async {
        completePurchase(purchases);
      });
      notifyListeners();
      return true;
    }

    return false;
  }

  Future<void> completePurchase(List<PurchaseDetails> purchases) async {
    for (final PurchaseDetails purchase in purchases) {
      if (purchase.status == PurchaseStatus.purchased) {
        final BillingResultWrapper billingResult = await _iap.completePurchase(purchase);

        if (billingResult.responseCode == BillingResponse.ok) {
          _pastPurchases.addAll(purchases);
        } else if (billingResult.responseCode == BillingResponse.error ||
            billingResult.responseCode == BillingResponse.serviceUnavailable) {
          completePurchase(purchases);
        }
      }
    }
  }

  void cancelSubscription() {
    subscription?.cancel();
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

  void buyProduct(ProductDetails prod) {
    final PurchaseParam purchaseParam = PurchaseParam(productDetails: prod);
    _iap.buyNonConsumable(purchaseParam: purchaseParam);
    // _iap.buyConsumable(purchaseParam: purchaseParam);
  }
}
