import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter/cupertino.dart';

import '../../providers/device_provider.dart';
import '../../screens/select_category_screen.dart';
import '../../styles/box_decoration_styes.dart';
import '../../styles/text_styles.dart';

class PlayButton extends StatefulWidget {
  const PlayButton({
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

  void _onTapUp(TapUpDetails details) {
    _playButtonBounceController.forward();
    widget.playButtonSlideController.reverse();
    widget.shopButtonSlideController.reverse();
    widget.puzzlePicSlideController.reverse();
    widget.polaroidSlideController.reverse().then((_) async {
      final bool result = await Navigator.push(
        context,
        CupertinoPageRoute<bool>(
          builder: (BuildContext context) => const SelectCategoryScreen(),
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
  void initState() {
    _playButtonBounceController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
      upperBound: 0.08,
    )..addListener(() {
        setState(() {});
      });

    _playButtonSlideAnimation = Tween<Offset>(
      begin: const Offset(10, 0),
      end: const Offset(0, 0),
    ).animate(
      CurvedAnimation(
        parent: widget.playButtonSlideController,
        curve: const Interval(0.0, 1.0, curve: Curves.fastOutSlowIn),
      ),
    );

    Future<TickerFuture>.delayed(const Duration(milliseconds: 500))
        .then((_) => widget.playButtonSlideController.forward());

    super.initState();
  }

  @override
  void dispose() {
    _playButtonBounceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _scale = 1 - _playButtonBounceController.value;

    final DeviceProvider deviceProvider = Provider.of<DeviceProvider>(context, listen: false);

    return Align(
      alignment: Alignment.bottomCenter,
      child: GestureDetector(
        onTap: () {
          deviceProvider.playSound(sound: 'play_button_click.wav');
        },
        onTapUp: _onTapUp,
        child: Padding(
          padding: EdgeInsets.only(bottom: deviceProvider.getDeviceScreenHeight * 0.25),
          child: SlideTransition(
            position: _playButtonSlideAnimation,
            child: Transform.scale(
              scale: _scale,
              child: Container(
                width: deviceProvider.getUseMobileLayout ? 170 : 300,
                height: deviceProvider.getUseMobileLayout ? 50 : 80,
                decoration: kHomeScreenButtonBoxDecoration,
                child: Center(
                  child: Text(
                    'Play!',
                    style: kPlayButtonText,
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
