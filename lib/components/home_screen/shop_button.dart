import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter/cupertino.dart';

import '../../providers/device_provider.dart';
import '../../screens/shop_screen.dart';
import '../../styles/box_decoration_styes.dart';
import '../../styles/text_theme.dart';

class ShopButton extends StatefulWidget {
  const ShopButton({Key key, this.shopButtonSlideController}) : super(key: key);
  final AnimationController shopButtonSlideController;

  @override
  _ShopButtonState createState() => _ShopButtonState();
}

class _ShopButtonState extends State<ShopButton> with TickerProviderStateMixin {
  double _scale;
  AnimationController _shopButtonBounceController;
  Animation<Offset> _shopButtonSlideAnimation;

  void _onTapUp(TapUpDetails details) {
    Navigator.push(
      context,
      MaterialPageRoute<bool>(
        builder: (BuildContext context) => ShopScreen(),
      ),
    );
  }

  @override
  void initState() {
    _shopButtonBounceController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
      upperBound: 0.08,
    )..addListener(() {
        setState(() {});
      });

    _shopButtonSlideAnimation = Tween<Offset>(
      begin: const Offset(-10, 0),
      end: const Offset(0, 0),
    ).animate(
      CurvedAnimation(
        parent: widget.shopButtonSlideController,
        curve: const Interval(0.0, 1.0, curve: Curves.fastOutSlowIn),
      ),
    );

    Future<TickerFuture>.delayed(const Duration(milliseconds: 500))
        .then((_) => widget.shopButtonSlideController.forward());

    super.initState();
  }

  @override
  void dispose() {
    _shopButtonBounceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _scale = 1 - _shopButtonBounceController.value;

    final DeviceProvider deviceProvider = Provider.of<DeviceProvider>(context, listen: false);

    return Align(
      alignment: Alignment.bottomCenter,
      child: GestureDetector(
        onTap: () {
          deviceProvider.playSound(sound: 'play_button_click.wav');
        },
        onTapUp: _onTapUp,
        child: Padding(
          padding: EdgeInsets.only(bottom: deviceProvider.getDeviceScreenHeight * 0.15),
          child: SlideTransition(
            position: _shopButtonSlideAnimation,
            child: Transform.scale(
              scale: _scale,
              child: Container(
                width: deviceProvider.getUseMobileLayout ? 170 : 300,
                height: deviceProvider.getUseMobileLayout ? 50 : 80,
                decoration: kHomeScreenButtonBoxDecoration,
                child: Center(
                  child: Text(
                    'Shop',
                    style: CustomTextTheme.playButtonText(),
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
