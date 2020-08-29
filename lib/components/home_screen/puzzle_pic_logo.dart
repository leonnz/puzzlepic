import 'package:flutter/material.dart';

import '../../providers/device_provider.dart';
import '../../styles/text_styles.dart';

class PuzzlePicLogo extends StatefulWidget {
  const PuzzlePicLogo({
    Key key,
    @required this.puzzlePicSlideController,
  }) : super(key: key);

  final AnimationController puzzlePicSlideController;
  @override
  _PuzzlePicLogoState createState() => _PuzzlePicLogoState();
}

class _PuzzlePicLogoState extends State<PuzzlePicLogo> with SingleTickerProviderStateMixin {
  Animation<Offset> _puzzlePicSlideAnimation;

  @override
  void initState() {
    _puzzlePicSlideAnimation = Tween<Offset>(
      begin: const Offset(0, -2),
      end: const Offset(0, 0),
    ).animate(
      CurvedAnimation(
        parent: widget.puzzlePicSlideController,
        curve: const Interval(0.0, 1.0, curve: Curves.fastOutSlowIn),
      ),
    );

    Future<TickerFuture>.delayed(const Duration(milliseconds: 500))
        .then((_) => widget.puzzlePicSlideController.forward());

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topCenter,
      child: SlideTransition(
        position: _puzzlePicSlideAnimation,
        child: Container(
          width: double.infinity,
          color: const Color.fromRGBO(147, 112, 219, 0.2),
          margin: EdgeInsets.only(
            top: DeviceProvider.longestSide / 4,
          ),
          child: Padding(
            padding: EdgeInsets.all(DeviceProvider.shortestSide / 14.5),
            child: Text(
              'Puzzle Pic',
              textAlign: TextAlign.center,
              style: kHomeScreenAppName,
            ),
          ),
        ),
      ),
    );
  }
}
