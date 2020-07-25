import 'package:flutter/material.dart';
import '../providers/device_provider.dart';
import 'package:provider/provider.dart';
import '../styles/customStyles.dart';

class PlayButton extends StatefulWidget {
  PlayButton(
      {Key key, this.buttonText, this.action, this.playButtonSlideController})
      : super(key: key);
  final String buttonText;
  final Function action;
  final AnimationController playButtonSlideController;

  @override
  _PlayButtonState createState() => _PlayButtonState();
}

class _PlayButtonState extends State<PlayButton> with TickerProviderStateMixin {
  double _scale;
  AnimationController _controller;
  Animation<Offset> _slideAnimation;

  @override
  void initState() {
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 200),
      lowerBound: 0.0,
      upperBound: 0.08,
    )..addListener(() {
        setState(() {});
      });

    _slideAnimation = Tween<Offset>(
      begin: Offset(0, 10),
      end: Offset(0, 0),
    ).animate(
      CurvedAnimation(
        parent: widget.playButtonSlideController,
        curve: Interval(0.0, 1.0, curve: Curves.fastOutSlowIn),
      ),
    );

    widget.playButtonSlideController.forward();

    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onTapDown(TapDownDetails details) {
    _controller.forward();
    widget.action();
  }

  void _onTapUp(TapUpDetails details) {
    _controller.reverse();
  }

  @override
  Widget build(BuildContext context) {
    _scale = 1 - _controller.value;

    DeviceProvider deviceProvider = Provider.of<DeviceProvider>(context);

    return GestureDetector(
      onTapDown: _onTapDown,
      onTapUp: _onTapUp,
      child: SlideTransition(
        position: _slideAnimation,
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
                style: CustomTextTheme(deviceProvider: deviceProvider)
                    .playButtonText(context),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
