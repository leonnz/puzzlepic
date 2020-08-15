import 'dart:async';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:firebase_admob/firebase_admob.dart';

import '../ad_manager.dart';
import '../data/db_provider.dart';

class ShopProvider extends ChangeNotifier {
  static final InAppPurchaseConnection _iap = InAppPurchaseConnection.instance;
  StreamSubscription<List<PurchaseDetails>> _subscription;

  final List<String> _availableCategories = <String>['cities', 'under_the_sea'];

  /// DEV only reveal all products
  // final List<String> _availableCategories = <String>[
  //   'animals',
  //   'art',
  //   'buildings',
  //   'cities',
  //   'flowers',
  //   'foods',
  //   'landscapes',
  //   'under_the_sea'
  // ];

  static const String _removeAdProductId = 'removeads';
  static const List<String> _productIds = <String>[
    'removeads',
    'animals',
    'art',
    'buildings',
    'flowers',
    'foods',
    'landscapes',

    /// Test IDs
    'test18',
    'test19',
    'test20',
  ];

  List<ProductDetails> _allProducts = <ProductDetails>[];
  List<PurchaseDetails> _pastPurchases = <PurchaseDetails>[];
  bool _available = false;
  bool _timeout = false;
  Function _failedPurchaseCallbackAlert;
  bool _showSuccessMessage = false;
  static AnimationController puchaseMessageController;
  BannerAd _bannerAd;

  bool get getAvailable => _available;
  bool get getTimedout => _timeout;
  String get getRemoveAdProductId => _removeAdProductId;
  List<ProductDetails> get getAllProducts => _allProducts;
  List<PurchaseDetails> get getPastPurchases => _pastPurchases;
  List<String> get getAvailableCategories => _availableCategories;
  bool get getShowSuccessMessage => _showSuccessMessage;
  BannerAd get getBannerAd => _bannerAd;

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
      _allProducts = await getProductsFromAppStore();
    } else {
      _timeout = true;
    }
    notifyListeners();
    return _available;
  }

  void registerSubscription() {
    if (_available) {
      _subscription = _iap.purchaseUpdatedStream.listen(
        (List<PurchaseDetails> purchases) {
          completePurchase(purchases);
        },
      );
    }
  }

  void setBannerAd() {
    _bannerAd = BannerAd(
      adUnitId: AdManager.bannerAdUnitId,
      size: AdSize.fullBanner,
    );
  }

  void disposeBannerAd() {
    _bannerAd?.dispose();
  }

  Future<void> buyProduct({ProductDetails product, Function callback}) async {
    _failedPurchaseCallbackAlert = callback;

    final PurchaseDetails productPurchaseIfExists = _pastPurchases.firstWhere(
      (PurchaseDetails purchase) => purchase.productID == product.id,
      orElse: () => null,
    );

    if (productPurchaseIfExists == null) {
      final PurchaseParam purchaseParam = PurchaseParam(productDetails: product);
      await _iap.buyNonConsumable(purchaseParam: purchaseParam);
    }
  }

  void addAvailableCategory({String category}) {
    _availableCategories.add(category);
    notifyListeners();
  }

  Future<void> completePurchase(List<PurchaseDetails> purchases) async {
    for (final PurchaseDetails purchase in purchases) {
      if (purchase.status == PurchaseStatus.purchased) {
        print('Purchased!');

        final BillingResultWrapper billingResult = await _iap.completePurchase(purchase);

        print('${billingResult.responseCode}');

        if (billingResult.responseCode == BillingResponse.ok) {
          _pastPurchases.addAll(purchases);
          final DBProviderDb dbProvider = DBProviderDb();
          dbProvider.insertCategoryPurchasedRecord(purchasedCategory: purchase.productID);
          addAvailableCategory(category: purchase.productID);
          setShowSuccessMessage(show: true);
          notifyListeners();
        } else if (billingResult.responseCode == BillingResponse.error ||
            billingResult.responseCode == BillingResponse.serviceUnavailable) {
          _failedPurchaseCallbackAlert(
              'Purchase error', 'Please try again another time, you have not been charged.');
        }
      }
    }
  }

  void setShowSuccessMessage({bool show}) {
    _showSuccessMessage = show;
    notifyListeners();
  }

  bool cancelSubscription() {
    _subscription?.cancel();
    return true;
  }

  Future<List<ProductDetails>> getProductsFromAppStore() async {
    final Set<String> productIdsSet =
        Set<String>.from(<List<String>>[_productIds].expand((List<String> product) => product));

    final ProductDetailsResponse response = await _iap.queryProductDetails(productIdsSet);

    return response.productDetails;
  }

  Future<List<PurchaseDetails>> getPastPurchasesFromAppStore() async {
    final QueryPurchaseDetailsResponse response = await _iap.queryPastPurchases();
    final List<String> pastPurchaseProductIds =
        response.pastPurchases.map((PurchaseDetails p) => p.productID).toList();
    final DBProviderDb dbProvider = DBProviderDb();
    final List<String> purchasedProductsDb = await dbProvider.getPurchasedCategories();

    for (final PurchaseDetails purchase in response.pastPurchases) {
      if (Platform.isIOS) {
        InAppPurchaseConnection.instance.completePurchase(purchase);
      }
    }

    // Add purchased products to DB if it doesn't exist.
    for (final PurchaseDetails purchase in response.pastPurchases) {
      print(purchase.productID);
      if (_productIds.contains(purchase.productID) &&
          !purchasedProductsDb.contains(purchase.productID)) {
        dbProvider.insertCategoryPurchasedRecord(purchasedCategory: purchase.productID);
      }
    }

    // If the DB contains a purchase NOT in Past Purchases i.e a refund, then remove it from DB
    for (final String product in purchasedProductsDb) {
      if (!pastPurchaseProductIds.contains(product)) {
        dbProvider.deleteCategoryPurchasedRecord(purchasedCategory: product);
      }
    }

    return response.pastPurchases;
  }
}
