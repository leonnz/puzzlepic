import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/game_provider.dart';

class Polaroid extends StatefulWidget {
  const Polaroid({
    Key key,
    @required this.alignment,
    @required this.angle,
    @required this.image,
    @required this.startInterval,
    @required this.beginPosition,
    @required this.endPosition,
    @required this.polaroidSlideController,
  }) : super(key: key);

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

class _PolaroidState extends State<Polaroid> with SingleTickerProviderStateMixin {
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

    Future<TickerFuture>.delayed(const Duration(milliseconds: 500))
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
    final GameProvider gameState = Provider.of<GameProvider>(context, listen: false);

    return Align(
      alignment: widget.alignment,
      child: Container(
        width: gameState.getScreenWidth * 0.7,
        height: gameState.getScreenWidth * 0.777,
        child: SlideTransition(
          position: _slideAnimation,
          child: Transform.rotate(
            angle: widget.angle,
            child: Image(
              image: AssetImage('assets/images/_polaroids/polaroid_${widget.image}.jpg'),
            ),
          ),
        ),
      ),
    );
  }
}
