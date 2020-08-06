import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

import '../../providers/device_provider.dart';
import '../../providers/game_provider.dart';
import '../../screens/puzzle_screen.dart';
import '../../styles/element_theme.dart';
import '../../styles/text_theme.dart';

class ImageButton extends StatefulWidget {
  const ImageButton({
    Key key,
    this.imageAssetName,
    this.imageReadableName,
    this.imageReadableFullName,
    this.imageTitle,
    this.complete,
    this.refreshPictureSelectScreen,
  }) : super(key: key);

  final String imageAssetName;
  final String imageReadableName;
  final String imageReadableFullName;
  final String imageTitle;
  final bool complete;
  final Function refreshPictureSelectScreen;

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
    final DeviceProvider deviceProvider = Provider.of<DeviceProvider>(context);
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

        final bool result = await Navigator.push(
          context,
          CupertinoPageRoute<bool>(
            builder: (BuildContext context) => const PuzzleScreen(),
          ),
        );
        // Refreshes the pictures to show complete ticks from database
        if (result) {
          widget.refreshPictureSelectScreen();
        }
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
                decoration: CustomElementTheme.selectCategoryImageTextLabelBoxDecoration(),
                child: Center(
                  child: Text(
                    widget.imageReadableName,
                    style: CustomTextTheme.selectPictureButtonTextStyle(),
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
