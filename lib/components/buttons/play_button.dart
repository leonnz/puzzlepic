import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter/cupertino.dart';

import '../../providers/device_provider.dart';
import '../../styles/customStyles.dart';
import '../../screens/select_category_screen.dart';

class PlayButton extends StatefulWidget {
  PlayButton({
    Key key,
    this.playButtonSlideController,
    this.shopButtonSlideController,
    this.puzzlePicSlideController,
    this.polaroidSlideController,
  }) : super(key: key);
  final AnimationController playButtonSlideController;
  final AnimationController shopButtonSlideController;
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
      begin: Offset(10, 0),
      end: Offset(0, 0),
    ).animate(
      CurvedAnimation(
        parent: widget.playButtonSlideController,
        curve: Interval(0.0, 1.0, curve: Curves.fastOutSlowIn),
      ),
    );

    Future.delayed(Duration(milliseconds: 500))
        .then((_) => widget.playButtonSlideController.forward());

    super.initState();
  }

  @override
  void dispose() {
    _playButtonBounceController.dispose();
    super.dispose();
  }

  void _onTapUp(TapUpDetails details) {
    _playButtonBounceController.forward();
    widget.playButtonSlideController.reverse();
    widget.shopButtonSlideController.reverse();
    widget.puzzlePicSlideController.reverse();
    widget.polaroidSlideController.reverse().then((_) async {
      final bool result = await Navigator.push(
        context,
        CupertinoPageRoute<bool>(
          builder: (BuildContext context) => const SelectCategory(),
        ),
      );

      if (result) {
        widget.polaroidSlideController.forward();
        widget.playButtonSlideController.forward();
        widget.shopButtonSlideController.forward();
        widget.puzzlePicSlideController.forward();
      }
    });
    _playButtonBounceController.reverse();
  }

  @override
  Widget build(BuildContext context) {
    _scale = 1 - _playButtonBounceController.value;

    DeviceProvider deviceProvider = Provider.of<DeviceProvider>(context);

    return Align(
      alignment: Alignment.bottomCenter,
      child: GestureDetector(
        onTap: () {
          deviceProvider.playSound(sound: 'play_button_click.wav');
        },
        onTapUp: _onTapUp,
        child: Padding(
          padding: EdgeInsets.only(
              bottom: deviceProvider.getDeviceScreenHeight * 0.2),
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
                        Colors.grey[350],
                      ]),
                ),
                child: Center(
                  child: Text(
                    'Play!',
                    style: CustomTextTheme(deviceProvider: deviceProvider)
                        .playButtonText(context),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
