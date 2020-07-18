import 'package:flutter/material.dart';
import '../providers/device_provider.dart';
import 'package:provider/provider.dart';

class Button extends StatefulWidget {
  Button({Key key, this.buttonText, this.action}) : super(key: key);
  final String buttonText;
  final Function action;

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
      upperBound: 0.08,
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

    DeviceProvider deviceProvider = Provider.of<DeviceProvider>(context);

    return GestureDetector(
      onTapDown: _onTapDown,
      onTapUp: _onTapUp,
      child: Transform.scale(
        scale: _scale,
        child: Container(
          width: deviceProvider.getUseMobileLayout ? 170 : 300,
          height: deviceProvider.getUseMobileLayout ? 50 : 80,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            boxShadow: [
              BoxShadow(
                color: Colors.black45,
                blurRadius: 5.0,
                offset: Offset(0.0, 5.0),
              ),
            ],
            gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.white,
                  Colors.white,
                ]),
          ),
          child: Center(
            child: Text(
              widget.buttonText,
              style: TextStyle(
                color: Colors.purple,
                fontSize: deviceProvider.getUseMobileLayout ? 25 : 40,
                letterSpacing: 1,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
