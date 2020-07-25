import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../styles/customStyles.dart';
import '../providers/device_provider.dart';

class PuzzlePicLogo extends StatefulWidget {
  const PuzzlePicLogo({Key key, this.puzzlePicSlideController})
      : super(key: key);

  final AnimationController puzzlePicSlideController;
  @override
  _PuzzlePicLogoState createState() => _PuzzlePicLogoState();
}

class _PuzzlePicLogoState extends State<PuzzlePicLogo>
    with SingleTickerProviderStateMixin {
  Animation<Offset> _puzzlePicSlideAnimation;

  @override
  void initState() {
    _puzzlePicSlideAnimation = Tween<Offset>(
      begin: Offset(0, -2),
      end: Offset(0, 0),
    ).animate(
      CurvedAnimation(
        parent: widget.puzzlePicSlideController,
        curve: Interval(0.0, 1.0, curve: Curves.fastOutSlowIn),
      ),
    );

    widget.puzzlePicSlideController.forward();
    super.initState();
  }

  Widget build(BuildContext context) {
    DeviceProvider deviceProvider = Provider.of<DeviceProvider>(context);

    return Align(
      alignment: Alignment.topCenter,
      child: SlideTransition(
        position: _puzzlePicSlideAnimation,
        child: Container(
          width: double.infinity,
          color: Color.fromRGBO(147, 112, 219, 0.2),
          margin: EdgeInsets.only(
            top: deviceProvider.getDeviceScreenHeight * 0.2,
          ),
          child: Padding(
            padding:
                EdgeInsets.all(deviceProvider.getUseMobileLayout ? 30 : 50),
            child: Text(
              'Puzzle Pic',
              textAlign: TextAlign.center,
              style: CustomTextTheme(deviceProvider: deviceProvider)
                  .homeScreenAppName(context),
            ),
          ),
        ),
      ),
    );
  }
}
