import 'dart:async';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:in_app_purchase/in_app_purchase.dart';

class ShopProvider extends ChangeNotifier {
  static const String _removeAdsID = 'remove_ads';
  String get getRemoveAdsID => _removeAdsID;
  static final List<String> imagePackProductIDs = <String>[
    'category_natural_wonders',
    'category_sports',
  ];

  static final InAppPurchaseConnection iap = InAppPurchaseConnection.instance;
  StreamSubscription<List<PurchaseDetails>> subscription;

  List<ProductDetails> _removeAdsProduct = <ProductDetails>[];
  List<ProductDetails> get getRemoveAdsProduct => _removeAdsProduct;

  void setRemoveAdsProduct(List<ProductDetails> product) {
    _removeAdsProduct = product;
    notifyListeners();
  }

  static List<ProductDetails> _imagePackProducts = <ProductDetails>[];
  List<ProductDetails> get getImagePackProducts => _imagePackProducts;

  static List<PurchaseDetails> _purchases = <PurchaseDetails>[];
  List<PurchaseDetails> get getPurchases => _purchases;

  static bool available = false;

  static bool _removedAdsPurchased = false;
  bool get getRemovedAdsPurchased => _removedAdsPurchased;
  void setRemovedAdsPurchased() {
    _removedAdsPurchased = true;
    notifyListeners();
  }

  Future<void> initialize() async {
    ShopProvider.available = await ShopProvider.iap.isAvailable();

    if (available) {
      print('available');

      final List<Future<void>> futures = <Future<void>>[
        getPastPurchases(),
        getRemoveAdsProductFromAppStore(),
        getImagePackProductsFromAppStore(),
      ];
      await Future.wait(futures);

      // verifyPurchase();

      subscription = iap.purchaseUpdatedStream.listen((List<PurchaseDetails> data) {
        print('NEW PURCHASE');
        _purchases.addAll(data);
        print(_purchases);

        notifyListeners();
      });
    } else {
      print('fail');
    }
  }

  void cancelSubscription() {
    subscription?.cancel();
  }

  Future<void> getRemoveAdsProductFromAppStore() async {
    final Set<String> removeAdsIDSet = <String>{_removeAdsID};

    final ProductDetailsResponse responseRemoveAd = await iap.queryProductDetails(removeAdsIDSet);

    _removeAdsProduct = responseRemoveAd.productDetails;
    print('Remove ad products ${_removeAdsProduct.length}');
    notifyListeners();
  }

  Future<void> getImagePackProductsFromAppStore() async {
    final Set<String> imagePackIDSet = Set<String>.from(
        <List<String>>[imagePackProductIDs].expand((List<String> product) => product));

    final ProductDetailsResponse responseImagePacks = await iap.queryProductDetails(imagePackIDSet);

    _imagePackProducts = responseImagePacks.productDetails;
    print('Image pack products ${_imagePackProducts.length}');
    notifyListeners();
  }

  static Future<void> getPastPurchases() async {
    final QueryPurchaseDetailsResponse response = await iap.queryPastPurchases();

    for (final PurchaseDetails purchase in response.pastPurchases) {
      if (Platform.isIOS) {
        InAppPurchaseConnection.instance.completePurchase(purchase);
      }
    }

    _purchases = response.pastPurchases;
    print('Purchases: ${_purchases.length}');
  }

  PurchaseDetails hasPurchased(String productID) {
    print(productID);
    return _purchases.firstWhere(
      (PurchaseDetails purchase) => purchase.productID == productID,
      orElse: () => null,
    );
  }

  void verifyPurchase() {
    final PurchaseDetails purchase = hasPurchased(_removeAdsID);

    if (purchase != null && purchase.status == PurchaseStatus.purchased) {
      print(purchase.productID);
      print(purchase.purchaseID);
      print(purchase.status);
      print(purchase.verificationData.source);
      // setRemovedAdsPurchased();
    }
  }

  void buyProduct(ProductDetails prod) {
    final PurchaseParam purchaseParam = PurchaseParam(productDetails: prod);
    iap.buyNonConsumable(purchaseParam: purchaseParam);
    // _iap.buyConsumable(purchaseParam: purchaseParam);
    // setRemovedAdsPurchased();
    // notifyListeners();
    if (prod.id == _removeAdsID) {
      setRemovedAdsPurchased();
      print('remove ads product bought');
    }
  }
}
