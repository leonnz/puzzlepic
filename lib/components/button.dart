import 'package:flutter/material.dart';

class Button extends StatefulWidget {
  Button({Key key, this.buttonText, this.action, this.margin})
      : super(key: key);
  final String buttonText;
  final Function action;
  final double margin;

  @override
  _ButtonState createState() => _ButtonState();
}

class _ButtonState extends State<Button> with SingleTickerProviderStateMixin {
  double _scale;
  AnimationController _controller;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 200),
      lowerBound: 0.0,
      upperBound: 0.05,
    )..addListener(() {
        setState(() {});
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onTapDown(TapDownDetails details) {
    _controller.forward();
  }

  void _onTapUp(TapUpDetails details) {
    _controller.reverse();
    widget.action();
  }

  @override
  Widget build(BuildContext context) {
    _scale = 1 - _controller.value;

    return GestureDetector(
      onTapDown: _onTapDown,
      onTapUp: _onTapUp,
      child: Transform.scale(
        scale: _scale,
        child: Container(
          margin: EdgeInsets.all(widget.margin),
          width: 170,
          height: 50,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            boxShadow: [
              BoxShadow(
                color: Colors.grey,
                blurRadius: 5.0,
                offset: Offset(0.0, 5.0),
              ),
            ],
            gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.blue,
                  Colors.blue[900],
                ]),
          ),
          child: Center(
            child: Text(
              widget.buttonText,
              style: TextStyle(
                color: Colors.white,
                fontSize: 25.0,
                letterSpacing: 3,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
