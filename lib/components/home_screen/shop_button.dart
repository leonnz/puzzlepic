import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter/cupertino.dart';

import '../../providers/device_provider.dart';
import '../../screens/shop_screen.dart';
import '../../styles/text_theme.dart';

class ShopButton extends StatefulWidget {
  const ShopButton({
    Key key,
    this.shopButtonSlideController,
  }) : super(key: key);
  final AnimationController shopButtonSlideController;

  @override
  _ShopButtonState createState() => _ShopButtonState();
}

class _ShopButtonState extends State<ShopButton> with TickerProviderStateMixin {
  double _scale;
  AnimationController _shopButtonBounceController;
  Animation<Offset> _shopButtonSlideAnimation;

  @override
  void initState() {
    _shopButtonBounceController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
      lowerBound: 0.0,
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
        curve: Interval(0.0, 1.0, curve: Curves.fastOutSlowIn),
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

  void _onTapUp(TapUpDetails details) {
    Navigator.push(
      context,
      MaterialPageRoute<bool>(
        builder: (BuildContext context) => ShopScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    _scale = 1 - _shopButtonBounceController.value;

    final DeviceProvider deviceProvider = Provider.of<DeviceProvider>(context);

    return Align(
      alignment: Alignment.bottomCenter,
      child: GestureDetector(
        onTap: () {
          deviceProvider.playSound(sound: 'play_button_click.wav');
        },
        onTapUp: _onTapUp,
        child: Padding(
          padding: EdgeInsets.only(bottom: deviceProvider.getDeviceScreenHeight * 0.1),
          child: SlideTransition(
            position: _shopButtonSlideAnimation,
            child: Transform.scale(
              scale: _scale,
              child: Container(
                width: deviceProvider.getUseMobileLayout ? 170 : 300,
                height: deviceProvider.getUseMobileLayout ? 50 : 80,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  boxShadow: const <BoxShadow>[
                    BoxShadow(
                      color: Colors.black45,
                      blurRadius: 5.0,
                      offset: Offset(0.0, 5.0),
                    ),
                  ],
                  gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: <Color>[
                        Colors.white,
                        Colors.grey[350],
                      ]),
                ),
                child: Center(
                  child: Text(
                    'Shop',
                    style: CustomTextThemes.playButtonText(),
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
