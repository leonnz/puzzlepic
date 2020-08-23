import 'dart:math' as math;

import 'package:flutter/material.dart';
import '../../components/_shared/mute_button.dart';
import '../../components/home_screen/play_button.dart';
import '../../components/home_screen/polaroid.dart';
import '../../components/home_screen/puzzle_pic_logo.dart';
import '../../components/home_screen/shop_button.dart';

class HomeScreenStack extends StatefulWidget {
  const HomeScreenStack({
    Key key,
  }) : super(key: key);

  @override
  _HomeScreenStackState createState() => _HomeScreenStackState();
}

class _HomeScreenStackState extends State<HomeScreenStack> with TickerProviderStateMixin {
  AnimationController _polaroidSlideController;
  AnimationController _playButtonSlideController;
  AnimationController _shopButtonSlideController;
  AnimationController _puzzlePicSlideController;

  @override
  void initState() {
    _polaroidSlideController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );

    _shopButtonSlideController = AnimationController(
      duration: const Duration(milliseconds: 350),
      vsync: this,
    );

    _playButtonSlideController = AnimationController(
      duration: const Duration(milliseconds: 350),
      vsync: this,
    );

    _puzzlePicSlideController = AnimationController(
      duration: const Duration(milliseconds: 350),
      vsync: this,
    );
    super.initState();
  }

  @override
  void dispose() {
    _polaroidSlideController.dispose();
    _playButtonSlideController.dispose();
    _shopButtonSlideController.dispose();
    _puzzlePicSlideController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Polaroid(
          polaroidSlideController: _polaroidSlideController,
          alignment: Alignment.bottomRight,
          angle: math.pi / 6,
          beginPosition: const Offset(1, 1),
          endPosition: const Offset(0.3, 0),
          image: 'grand_canyon',
          startInterval: 0.4,
        ),
        Polaroid(
          polaroidSlideController: _polaroidSlideController,
          alignment: Alignment.bottomLeft,
          angle: -math.pi / 10,
          beginPosition: const Offset(-1.5, 1.5),
          endPosition: const Offset(-0.2, 0.1),
          image: 'pyramids',
          startInterval: 0.2,
        ),
        Polaroid(
          polaroidSlideController: _polaroidSlideController,
          alignment: Alignment.topLeft,
          angle: -math.pi / 6,
          beginPosition: const Offset(-1, -1),
          endPosition: const Offset(0, 0),
          image: 'daisies',
          startInterval: 0.1,
        ),
        Polaroid(
          polaroidSlideController: _polaroidSlideController,
          alignment: Alignment.centerLeft,
          angle: math.pi / 7,
          beginPosition: const Offset(-1.5, 0),
          endPosition: const Offset(0, 0),
          image: 'sea_turtle',
          startInterval: 0.3,
        ),
        Polaroid(
          polaroidSlideController: _polaroidSlideController,
          alignment: Alignment.centerRight,
          angle: -math.pi / 9,
          beginPosition: const Offset(1.5, 0),
          endPosition: const Offset(0.2, 0),
          image: 'taj_mahal',
          startInterval: 0.1,
        ),
        Polaroid(
          polaroidSlideController: _polaroidSlideController,
          alignment: Alignment.topRight,
          angle: math.pi / 8,
          beginPosition: const Offset(1.5, -1),
          endPosition: const Offset(0.2, -0.2),
          image: 'eiffel_tower',
          startInterval: 0.3,
        ),
        const MuteButton(),
        PlayButton(
          playButtonSlideController: _playButtonSlideController,
          shopButtonSlideController: _shopButtonSlideController,
          puzzlePicSlideController: _puzzlePicSlideController,
          polaroidSlideController: _polaroidSlideController,
        ),
        ShopButton(
          shopButtonSlideController: _shopButtonSlideController,
        ),
        PuzzlePicLogo(
          puzzlePicSlideController: _puzzlePicSlideController,
        ),
      ],
    );
  }
}
