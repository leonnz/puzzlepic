import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

import '../../providers/device_provider.dart';
import '../../providers/game_provider.dart';
import '../../screens/puzzle_screen.dart';
import '../../styles/box_decoration_styes.dart';
import '../../styles/text_styles.dart';

class ImageButton extends StatefulWidget {
  const ImageButton({
    Key key,
    @required this.imageAssetName,
    @required this.imageReadableName,
    @required this.imageReadableFullName,
    @required this.imageTitle,
    @required this.complete,
  }) : super(key: key);

  final String imageAssetName;
  final String imageReadableName;
  final String imageReadableFullName;
  final String imageTitle;
  final bool complete;

  @override
  _ImageButtonState createState() => _ImageButtonState();
}

class _ImageButtonState extends State<ImageButton> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final DeviceProvider deviceProvider = Provider.of<DeviceProvider>(context, listen: false);
    final GameProvider gameProvider = Provider.of<GameProvider>(context);

    return GestureDetector(
      onTap: () async {
        deviceProvider.playSound(sound: 'fast_click.wav');

        gameProvider.setImageData(
          assetName: widget.imageAssetName,
          readableName: widget.imageReadableName,
          readableFullname: widget.imageReadableFullName,
          title: widget.imageTitle,
        );

        Navigator.push(
          context,
          CupertinoPageRoute<bool>(
            builder: (BuildContext context) => const PuzzleScreen(),
          ),
        );
      },
      child: Card(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10), side: const BorderSide(color: Colors.white)),
        elevation: 5,
        child: Stack(
          children: <Widget>[
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image(
                image: AssetImage(
                    'assets/images/${gameProvider.getImageCategoryAssetName}/${widget.imageAssetName}_full_mini.jpg'),
              ),
            ),
            Positioned(
              top: 5,
              right: 5,
              child: widget.complete
                  ? Icon(
                      Icons.check,
                      color: Colors.lightGreenAccent[400],
                      size: deviceProvider.getUseMobileLayout ? 40 : 60,
                    )
                  : Container(),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                height: deviceProvider.getUseMobileLayout ? 50 : 70,
                width: double.infinity,
                decoration: kSelectCategoryImageTextLabelBoxDecoration,
                child: Center(
                  child: Text(
                    widget.imageReadableName,
                    style: kSelectPictureButtonTextStyle,
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
