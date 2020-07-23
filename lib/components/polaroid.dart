import 'package:flutter/material.dart';
import '../providers/game_state_provider.dart';
import 'package:provider/provider.dart';

class Polaroid extends StatefulWidget {
  Polaroid({
    Key key,
    this.alignment,
    this.angle,
    this.image,
    this.startInterval,
    this.beginPosition,
    this.endPosition,
  }) : super(key: key);

  final Alignment alignment;
  final double angle;
  final String image;
  final double startInterval;
  final Offset beginPosition;
  final Offset endPosition;

  @override
  _PolaroidState createState() => _PolaroidState();
}

class _PolaroidState extends State<Polaroid>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;
  Animation<Offset> _offsetAnimation;

  @override
  void initState() {
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    )..forward();

    _offsetAnimation = Tween<Offset>(
      begin: widget.beginPosition,
      end: widget.endPosition,
    ).animate(
      CurvedAnimation(
        parent: _controller,
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
        width: state.getScreenWidth * 0.6,
        height: state.getScreenWidth * 0.666,
        child: SlideTransition(
          position: _offsetAnimation,
          child: Transform.rotate(
            angle: widget.angle,
            child: Container(
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: Colors.black45,
                    blurRadius: 5.0,
                    offset: Offset(0.0, 3.0),
                  ),
                ],
              ),
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
