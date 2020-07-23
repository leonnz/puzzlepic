import 'package:flutter/material.dart';
import '../providers/game_state_provider.dart';
import 'package:provider/provider.dart';

class Polaroid extends StatefulWidget {
  Polaroid(
      {Key key,
      this.alignment,
      this.angle,
      this.image,
      this.startInterval,
      this.beginPosition,
      this.endPosition,
      this.testController})
      : super(key: key);

  final Alignment alignment;
  final double angle;
  final String image;
  final double startInterval;
  final Offset beginPosition;
  final Offset endPosition;
  final AnimationController testController;

  @override
  _PolaroidState createState() => _PolaroidState();
}

class _PolaroidState extends State<Polaroid>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;
  Animation<Offset> _offsetAnimation;

  @override
  void initState() {
    // _controller = AnimationController(
    //   duration: const Duration(milliseconds: 1000),
    //   vsync: this,
    // )..forward();

    widget.testController..forward();

    _offsetAnimation = Tween<Offset>(
      begin: widget.beginPosition,
      end: widget.endPosition,
    ).animate(
      CurvedAnimation(
        // parent: _controller,
        parent: widget.testController,
        curve: Interval(widget.startInterval, 1.0, curve: Curves.elasticOut),
      ),
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    GameStateProvider state = Provider.of<GameStateProvider>(context);

    return Align(
      alignment: widget.alignment,
      child: Container(
        width: state.getScreenWidth * 0.7,
        height: state.getScreenWidth * 0.777,
        child: SlideTransition(
          position: _offsetAnimation,
          child: Transform.rotate(
            angle: widget.angle,
            child: Container(
              child: Image(
                width: double.infinity,
                image: AssetImage(
                    'assets/images/polaroids/polaroid_${widget.image}.jpg'),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
