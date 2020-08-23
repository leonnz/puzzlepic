import 'package:flutter/material.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:provider/provider.dart';
import 'package:firebase_admob/firebase_admob.dart';

import '../../ad_manager.dart';
import '../../providers/game_provider.dart';
import '../../providers/image_piece_provider.dart';
import '../../providers/shop_provider.dart';
import 'puzzle_card_image_piece.dart';

class PuzzleCardImageBoard extends StatefulWidget {
  const PuzzleCardImageBoard({
    Key key,
  }) : super(key: key);

  @override
  _PuzzleCardImageBoardState createState() => _PuzzleCardImageBoardState();
}

class _PuzzleCardImageBoardState extends State<PuzzleCardImageBoard> {
  InterstitialAd _interstitialAd;
  bool _isInterstitialAdReady;

  void _loadInterstitialAd() {
    _interstitialAd.load();
  }

  void _onInterstitialAdEvent(MobileAdEvent event) {
    switch (event) {
      case MobileAdEvent.loaded:
        _isInterstitialAdReady = true;
        break;
      case MobileAdEvent.failedToLoad:
        _isInterstitialAdReady = false;
        print('Failed to load an interstitial ad.');
        break;
      case MobileAdEvent.closed:
        break;
      default:
    }
  }

  List<ImagePiece> _generateImagePieces(
      {int numberOfPieces, bool complete, GameProvider gameProvider}) {
    final List<ImagePiece> imagePieceList = <ImagePiece>[];

    // Always produce 1 less image piece that the grid size
    for (int i = 1; i <= numberOfPieces; i++) {
      imagePieceList.add(
        ImagePiece(
          pieceNumber: i,
          lastPiece: complete,
          interstitialAd: _interstitialAd,
          isInterstitialAdReady: _isInterstitialAdReady,
        ),
      );
      gameProvider.setInitialPuzzlePiecePosition(i);
    }

    return imagePieceList;
  }

  @override
  void initState() {
    _isInterstitialAdReady = false;

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

        _loadInterstitialAd();
      }
    }

    super.initState();
  }

  @override
  void dispose() {
    _interstitialAd?.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final GameProvider gameProvider = Provider.of<GameProvider>(context);

    return ChangeNotifierProvider<ImagePieceProvider>(
      create: (BuildContext context) => ImagePieceProvider(),
      child: Padding(
        padding: const EdgeInsets.all(5.0),
        child: Container(
          width: gameProvider.getScreenWidth,
          height: gameProvider.getScreenWidth,
          color: Colors.grey,
          child: Stack(
            children: _generateImagePieces(
              numberOfPieces: gameProvider.getPuzzleComplete
                  ? gameProvider.getTotalGridSize
                  : gameProvider.getTotalGridSize - 1,
              complete: gameProvider.getPuzzleComplete,
              gameProvider: gameProvider,
            ),
          ),
        ),
      ),
    );
  }
}
