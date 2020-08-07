import 'dart:async';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:in_app_purchase/in_app_purchase.dart';

import '../data/db_provider.dart';

class ShopProvider extends ChangeNotifier {
  static final InAppPurchaseConnection _iap = InAppPurchaseConnection.instance;
  StreamSubscription<List<PurchaseDetails>> _subscription;

  final List<String> _availableCategories = <String>['cities', 'foods', 'under_the_sea'];

  /// DEV only reveal all products
  // final List<String> _availableCategories = <String>[
  //   'animals',
  //   'art',
  //   'buildings',
  //   'cities',
  //   'flowers',
  //   'foods',
  //   'landscapes',
  //   'natural_wonders',
  //   'under_the_sea'
  // ];

  static const String _removeAdProductId = 'test1';
  static const List<String> _imagePackProductIds = <String>[
    'animals',
    'art',
    'buildings',
    'flowers',
    'landscapes',
    'natural_wonders',

    /// Test IDs
    // 'test8',
    // 'test9',
    // 'test10',
    // 'test11',
    // 'test12',
    // 'test13',
    // 'test14',
    // 'test15',
    // 'test16',
    // 'test17',
    // 'test18',
    // 'test19',
    // 'test20',
  ];

  ProductDetails _adProduct;
  List<ProductDetails> _imagePackProducts = <ProductDetails>[];
  List<PurchaseDetails> _pastPurchases = <PurchaseDetails>[];
  bool _available = false;
  bool _timeout = false;
  Function _callbackAlert;

  bool get getAvailable => _available;
  bool get getTimedout => _timeout;
  String get getRemoveAdProductId => _removeAdProductId;
  List<ProductDetails> get getImagePackProducts => _imagePackProducts;
  List<PurchaseDetails> get getPastPurchases => _pastPurchases;
  ProductDetails get getAdProduct => _adProduct;
  List<String> get getAvailableCategories => _availableCategories;

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

  Future<void> buyProduct({ProductDetails product, Function callback}) async {
    _callbackAlert = callback;

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
          _callbackAlert('Purchase complete', 'Thank you!');
          notifyListeners();
        } else if (billingResult.responseCode == BillingResponse.error ||
            billingResult.responseCode == BillingResponse.serviceUnavailable) {
          _callbackAlert(
              'Purchase error1', 'Please try again another time, you have not been charged.');
        }
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
    final Set<String> productIdsSet = Set<String>.from(
        <List<String>>[_imagePackProductIds].expand((List<String> product) => product));

    final ProductDetailsResponse response = await _iap.queryProductDetails(productIdsSet);

    return response.productDetails;
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
}
