import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/game_provider.dart';

class Polaroid extends StatefulWidget {
  Polaroid(
      {Key key,
      this.alignment,
      this.angle,
      this.image,
      this.startInterval,
      this.beginPosition,
      this.endPosition,
      this.polaroidSlideController})
      : super(key: key);

  final Alignment alignment;
  final double angle;
  final String image;
  final double startInterval;
  final Offset beginPosition;
  final Offset endPosition;
  final AnimationController polaroidSlideController;

  @override
  _PolaroidState createState() => _PolaroidState();
}

class _PolaroidState extends State<Polaroid>
    with SingleTickerProviderStateMixin {
  Animation<Offset> _slideAnimation;

  @override
  void initState() {
    _slideAnimation = Tween<Offset>(
      begin: widget.beginPosition,
      end: widget.endPosition,
    ).animate(
      CurvedAnimation(
        parent: widget.polaroidSlideController,
        curve: Interval(
          widget.startInterval,
          1.0,
          curve: Curves.fastLinearToSlowEaseIn,
        ),
      ),
    );

    Future.delayed(Duration(milliseconds: 500))
        .then((_) => widget.polaroidSlideController.forward());

    super.initState();
  }

  @override
  void dispose() {
    widget.polaroidSlideController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    GameProvider gameState = Provider.of<GameProvider>(context, listen: false);

    return Align(
      alignment: widget.alignment,
      child: Container(
        width: gameState.getScreenWidth * 0.7,
        height: gameState.getScreenWidth * 0.777,
        child: SlideTransition(
          position: _slideAnimation,
          child: Transform.rotate(
            angle: widget.angle,
            child: Container(
              child: Image(
                image: AssetImage(
                    'assets/images/_polaroids/polaroid_${widget.image}.jpg'),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
