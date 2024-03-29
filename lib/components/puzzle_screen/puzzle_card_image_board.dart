import 'package:flutter/material.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:provider/provider.dart';
import 'package:firebase_admob/firebase_admob.dart';

import '../../ad_manager.dart';
import '../../providers/game_provider.dart';
import '../../providers/shop_provider.dart';
import 'puzzle_card_image_piece.dart';

class PuzzleCardImageBoard extends StatefulWidget {
  const PuzzleCardImageBoard({Key key}) : super(key: key);

  @override
  _PuzzleCardImageBoardState createState() => _PuzzleCardImageBoardState();
}

class _PuzzleCardImageBoardState extends State<PuzzleCardImageBoard> {
  InterstitialAd _interstitialAd;
  bool _isInterstitialAdReady;

  void _onInterstitialAdEvent(MobileAdEvent event) {
    switch (event) {
      case MobileAdEvent.loaded:
        _isInterstitialAdReady = true;
        break;
      case MobileAdEvent.failedToLoad:
        _isInterstitialAdReady = false;
        break;
      case MobileAdEvent.closed:
        _isInterstitialAdReady = false;
        break;
      default:
        _isInterstitialAdReady = false;
        break;
    }
  }

  List<ImagePiece> _generateImagePieces() {
    final GameProvider gameProvider = Provider.of<GameProvider>(context);
    final List<ImagePiece> imagePieceList = <ImagePiece>[];

    final int numOfpieces = gameProvider.getPuzzleComplete
        ? gameProvider.getTotalGridSize
        : gameProvider.getTotalGridSize - 1;

    // Always produce 1 less image piece that the grid size
    for (int i = 1; i <= numOfpieces; i++) {
      imagePieceList.add(
        ImagePiece(
          pieceNumber: i,
          lastPiece: gameProvider.getPuzzleComplete,
          interstitialAd: _interstitialAd,
          isInterstitialAdReady: _isInterstitialAdReady,
        ),
      );
      gameProvider.setInitialPuzzlePiecePosition(pieceNumber: i);
    }

    gameProvider.setGridPositions();

    return imagePieceList;
  }

  void checkRemoveAdsPurchased() {
    final ShopProvider shopProvider = Provider.of<ShopProvider>(context, listen: false);

    if (shopProvider.getShopAvailable) {
      final PurchaseDetails adPurchased = shopProvider.getPastPurchases.firstWhere(
        (PurchaseDetails purchase) => purchase.productID == shopProvider.getRemoveAdProductId,
        orElse: () => null,
      );
      if (adPurchased == null) {
        _interstitialAd = InterstitialAd(
          adUnitId: AdManager.interstitialAdUnitId,
          listener: _onInterstitialAdEvent,
        );
        _interstitialAd.load();
      }
    }
  }

  @override
  void initState() {
    _isInterstitialAdReady = false;
    checkRemoveAdsPurchased();
    super.initState();
  }

  @override
  void dispose() {
    _interstitialAd?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final GameProvider gameProvider = Provider.of<GameProvider>(context, listen: false);

    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: Container(
        width: gameProvider.getScreenWidth,
        height: gameProvider.getScreenWidth,
        color: Colors.grey,
        child: Stack(
          children: _generateImagePieces(),
        ),
      ),
    );
  }
}
