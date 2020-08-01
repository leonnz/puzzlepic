import 'dart:async';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:in_app_purchase/in_app_purchase.dart';

class ShopProvider extends ChangeNotifier {
  static final InAppPurchaseConnection iap = InAppPurchaseConnection.instance;
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

  static List<PurchaseDetails> _pastPurchases = <PurchaseDetails>[];
  List<PurchaseDetails> get getPastPurchases => _pastPurchases;

  static bool available = false;

  Future<void> initialize() async {
    available = await ShopProvider.iap.isAvailable();

    if (available) {
      _pastPurchases = await getPastPurchasesFromAppStore();
      _adProduct = await getRemoveAdProductFromAppStore();
      _imagePackProducts = await getImageProductsFromAppStore();
    }
    notifyListeners();
    // Future<dynamic>.delayed(const Duration(milliseconds: 5000)).then(
    //   (_) => notifyListeners(),
    // );
    // notifyListeners();
    // print('wwwhhyyyyyyyyyyyyyy');
    // if (available) {
    //   print('available');

    //   final List<Future<void>> futures = <Future<void>>[
    //     getPastPurchases(),
    //     getRemoveAdsProductFromAppStore(),
    //     getImagePackProductsFromAppStore(),
    //   ];
    //   await Future.wait(futures);
    //   print('wwwhhyyyyyyyyyyyyyy');
    //   // verifyPurchase();

    //   subscription = iap.purchaseUpdatedStream.listen((List<PurchaseDetails> data) {
    //     print('NEW PURCHASE');
    //     _purchases.addAll(data);
    //     print(_purchases);

    //     notifyListeners();
    //   });
    // } else {
    //   print('fail');
    // }
  }

  void cancelSubscription() {
    subscription?.cancel();
  }

  Future<ProductDetails> getRemoveAdProductFromAppStore() async {
    final Set<String> productIdsSet = Set<String>.from(<String>{_removeAdProductId});

    final ProductDetailsResponse response = await iap.queryProductDetails(productIdsSet);

    return response.productDetails[0];
  }

  Future<List<ProductDetails>> getImageProductsFromAppStore() async {
    final Set<String> productIdsSet =
        Set<String>.from(<List<String>>[_productIds].expand((List<String> product) => product));

    final ProductDetailsResponse reponse = await iap.queryProductDetails(productIdsSet);

    return reponse.productDetails;
  }

  Future<List<PurchaseDetails>> getPastPurchasesFromAppStore() async {
    final QueryPurchaseDetailsResponse response = await iap.queryPastPurchases();

    for (final PurchaseDetails purchase in response.pastPurchases) {
      if (Platform.isIOS) {
        InAppPurchaseConnection.instance.completePurchase(purchase);
      }
    }
    // _purchases = response.pastPurchases;
    return response.pastPurchases;
    // notifyListeners();
    print('Purchases: ${_pastPurchases.length}');
  }

  PurchaseDetails hasPurchased(String productID) {
    print(productID);
    return _pastPurchases.firstWhere(
      (PurchaseDetails purchase) => purchase.productID == productID,
      orElse: () => null,
    );
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

  // void buyProduct(ProductDetails prod) {
  //   final PurchaseParam purchaseParam = PurchaseParam(productDetails: prod);
  //   iap.buyNonConsumable(purchaseParam: purchaseParam);
  //   // _iap.buyConsumable(purchaseParam: purchaseParam);
  //   // setRemovedAdsPurchased();
  //   // notifyListeners();
  //   if (prod.id == _removeAdsID) {
  //     setRemovedAdsPurchased();
  //     print('remove ads product bought');
  //   }
  // }
}
