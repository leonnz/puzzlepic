import 'package:flutter/material.dart';
import '../providers/device_provider.dart';
import 'package:provider/provider.dart';
import '../styles/customStyles.dart';
import 'package:flutter/cupertino.dart';
import '../screens/select_category_screen.dart';

class PlayButton extends StatefulWidget {
  PlayButton({
    Key key,
    this.buttonText,
    this.playButtonSlideController,
    this.puzzlePicSlideController,
    this.polaroidSlideController,
  }) : super(key: key);
  final String buttonText;
  final AnimationController playButtonSlideController;
  final AnimationController puzzlePicSlideController;
  final AnimationController polaroidSlideController;

  @override
  _PlayButtonState createState() => _PlayButtonState();
}

class _PlayButtonState extends State<PlayButton> with TickerProviderStateMixin {
  double _scale;
  AnimationController _playButtonBounceController;
  Animation<Offset> _playButtonSlideAnimation;

  @override
  void initState() {
    _playButtonBounceController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 200),
      lowerBound: 0.0,
      upperBound: 0.08,
    )..addListener(() {
        setState(() {});
      });

    _playButtonSlideAnimation = Tween<Offset>(
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
    _playButtonBounceController.dispose();
    super.dispose();
  }

  void _onTapDown(TapDownDetails details) {
    _playButtonBounceController.forward();
    widget.playButtonSlideController.reverse();
    widget.puzzlePicSlideController.reverse();
    widget.polaroidSlideController.reverse().then((_) async {
      var result = await Navigator.push(
        context,
        CupertinoPageRoute(
          builder: (context) => SelectCategory(),
        ),
      );

      if (result) {
        widget.polaroidSlideController.forward();
        widget.playButtonSlideController.forward();
        widget.puzzlePicSlideController.forward();
      }
    });
  }

  void _onTapUp(TapUpDetails details) {
    _playButtonBounceController.reverse();
  }

  @override
  Widget build(BuildContext context) {
    _scale = 1 - _playButtonBounceController.value;

    DeviceProvider deviceProvider = Provider.of<DeviceProvider>(context);

    return GestureDetector(
      onTapDown: _onTapDown,
      onTapUp: _onTapUp,
      child: SlideTransition(
        position: _playButtonSlideAnimation,
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
