import 'dart:async';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:in_app_purchase/in_app_purchase.dart';

class ShopProvider extends ChangeNotifier {
  static const String removeAdsID = 'remove_ads';
  static final List<String> imagePackProductIDs = <String>[
    'category_natural_wonders'
  ];

  static final InAppPurchaseConnection iap = InAppPurchaseConnection.instance;
  static StreamSubscription<List<PurchaseDetails>> subscription;

  List<ProductDetails> _removeAdsProduct = <ProductDetails>[];

  static List<ProductDetails> _imagePackProducts = <ProductDetails>[];

  static List<PurchaseDetails> purchases = <PurchaseDetails>[];

  static bool available = false;
  static bool removedAdsPurchased;

  Future<void> initialize() async {
    ShopProvider.available = await ShopProvider.iap.isAvailable();

    if (ShopProvider.available) {
      print(ShopProvider.available);
      final List<Future<void>> futures = <Future<void>>[getPastPurchases()];
      await Future.wait(futures);

      verifyPurchase();

      ShopProvider.subscription = ShopProvider.iap.purchaseUpdatedStream
          .listen((List<PurchaseDetails> data) {
        print('NEW PURCHASE');
        ShopProvider.purchases.addAll(data);
      });
    } else {
      print('fail');
    }
  }

  void cancelSubscription() {
    subscription.cancel();
  }

  Future<List<ProductDetails>> setRemoveAdsProduct() async {
    final Set<String> removeAdsIDSet = <String>{removeAdsID};

    final ProductDetailsResponse responseRemoveAd =
        await iap.queryProductDetails(removeAdsIDSet);

    _removeAdsProduct = responseRemoveAd.productDetails;

    print(_removeAdsProduct.length);

    return _removeAdsProduct;
  }

  Future<List<ProductDetails>> setImagePackProducts() async {
    final Set<String> imagePackIDSet = Set<String>.from(<List<String>>[
      imagePackProductIDs
    ].expand((List<String> product) => product));

    final ProductDetailsResponse responseImagePack =
        await iap.queryProductDetails(imagePackIDSet);

    _imagePackProducts = responseImagePack.productDetails;
    print(_imagePackProducts.length);

    return _imagePackProducts;
  }

  static Future<void> getPastPurchases() async {
    final QueryPurchaseDetailsResponse response =
        await iap.queryPastPurchases();

    for (final PurchaseDetails purchase in response.pastPurchases) {
      if (Platform.isIOS) {
        InAppPurchaseConnection.instance.completePurchase(purchase);
      }
    }

    purchases = response.pastPurchases;
  }

  PurchaseDetails hasPurchased(String productID) {
    return purchases.firstWhere(
      (PurchaseDetails purchase) => purchase.productID == productID,
      orElse: () => null,
    );
  }

  void verifyPurchase() {
    final PurchaseDetails purchase = hasPurchased(removeAdsID);

    if (purchase != null && purchase.status == PurchaseStatus.purchased) {
      print(purchase.productID);
      print(purchase.purchaseID);
      print(purchase.status);
      print(purchase.verificationData.source);
      removedAdsPurchased = true;
    }
  }

  void buyProduct(ProductDetails prod) {
    final PurchaseParam purchaseParam = PurchaseParam(productDetails: prod);
    iap.buyNonConsumable(purchaseParam: purchaseParam);
    // _iap.buyConsumable(purchaseParam: purchaseParam);
    removedAdsPurchased = true;
    print('product bought');
  }
}
