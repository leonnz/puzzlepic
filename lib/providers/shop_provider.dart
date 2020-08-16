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

//DEV ONLY - Test ad product
  static const String _removeAdProductId = 'test_removeads';
  // static const String _removeAdProductId = 'removeads';
  static const List<String> _productIds = <String>[
    'test_removeads',
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
  bool _shopAvailable = false;
  bool _timeout = false;
  Function _failedPurchaseCallbackAlert;
  bool _showSuccessMessage = false;
  static AnimationController puchaseMessageController;
  BannerAd _bannerAd;
  bool _bannerAdLoaded = false;

  bool get getShopAvailable => _shopAvailable;
  bool get getTimedout => _timeout;
  String get getRemoveAdProductId => _removeAdProductId;
  List<ProductDetails> get getAllProducts => _allProducts;
  List<PurchaseDetails> get getPastPurchases => _pastPurchases;
  List<String> get getAvailableCategories => _availableCategories;
  bool get getShowSuccessMessage => _showSuccessMessage;
  BannerAd get getBannerAd => _bannerAd;
  bool get getBannerAdLoaded => _bannerAdLoaded;

  Future<bool> initialize() async {
    try {
      _shopAvailable = await _iap.isAvailable().timeout(
        const Duration(milliseconds: 5000),
        onTimeout: () {
          return false;
        },
      );
    } on TimeoutException catch (_) {}
    if (_shopAvailable) {
      _pastPurchases = await getPastPurchasesFromAppStore();
      _allProducts = await getProductsFromAppStore();
    } else {
      _timeout = true;
    }
    notifyListeners();
    return _shopAvailable;
  }

  void registerSubscription() {
    if (_shopAvailable) {
      _subscription = _iap.purchaseUpdatedStream.listen(
        (List<PurchaseDetails> purchases) {
          completePurchase(purchases);
        },
      );
    }
  }

  void showBannerAd({bool useMobile}) {
    _bannerAd = BannerAd(
      adUnitId: AdManager.bannerAdUnitId,
      size: useMobile ? AdSize.fullBanner : AdSize.leaderboard,
      listener: (MobileAdEvent event) {
        if (event == MobileAdEvent.loaded) {
          _bannerAdLoaded = true;
        } else {
          _bannerAdLoaded = false;
        }
      },
    )
      ..load()
      ..show();
  }

  Future<void> disposeBannerAd() async {
    await _bannerAd?.dispose()?.then((_) => _bannerAdLoaded = false);
    notifyListeners();
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
        final BillingResultWrapper billingResult = await _iap.completePurchase(purchase);

        if (billingResult.responseCode == BillingResponse.ok) {
          final DBProviderDb dbProvider = DBProviderDb();
          _pastPurchases.addAll(purchases);
          dbProvider.insertCategoryPurchasedRecord(purchasedCategory: purchase.productID);
          addAvailableCategory(category: purchase.productID);

          if (purchase.productID == _removeAdProductId) {
            disposeBannerAd();
          }

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
