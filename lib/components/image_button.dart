import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:audioplayers/audio_cache.dart';
import 'package:audioplayers/audioplayers.dart';

import '../styles/customStyles.dart';
import '../providers/device_provider.dart';
import '../screens/puzzle_screen.dart';

class ImageButton extends StatefulWidget {
  const ImageButton({
    Key key,
    this.assetName,
    this.readableName,
    this.readableFullName,
    this.title,
    this.categoryName,
    this.complete,
    this.imgNumber,
    this.refreshPictureSelectScreen,
  }) : super(key: key);

  final int imgNumber;
  final String categoryName;
  final String assetName;
  final String readableName;
  final String readableFullName;
  final String title;
  final bool complete;
  final Function refreshPictureSelectScreen;

  @override
  _ImageButtonState createState() => _ImageButtonState();
}

class _ImageButtonState extends State<ImageButton> {
  AudioCache imageButtonClickAudio = AudioCache(prefix: 'audio/');

  @override
  void initState() {
    imageButtonClickAudio.load('fast_click.wav');
    imageButtonClickAudio.disableLog();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    DeviceProvider deviceProvider = Provider.of<DeviceProvider>(context);
    return GestureDetector(
      onTap: () async {
        imageButtonClickAudio.play('fast_click.wav',
            mode: PlayerMode.LOW_LATENCY);
        final result = await Navigator.push(
          context,
          CupertinoPageRoute(
            builder: (context) => PuzzleScreen(
              imageCategory: widget.categoryName,
              imageAssetName: widget.assetName,
              imageReadableName: widget.readableName,
              imageReadableFullname: widget.readableFullName,
              imageTitle: widget.title,
            ),
          ),
        );
        // Refreshes the pictures to show complete ticks from database
        if (result) {
          widget.refreshPictureSelectScreen();
        }
      },
      child: Card(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
            side: BorderSide(width: 1, color: Colors.white)),
        elevation: 5,
        child: Stack(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image(
                image: AssetImage(
                    'assets/images/${widget.categoryName}/${widget.assetName}_full_mini.jpg'),
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
                decoration: BoxDecoration(
                  color: Color.fromRGBO(255, 255, 255, 0.80),
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(10),
                    bottomRight: Radius.circular(10),
                  ),
                ),
                child: Center(
                  child: Text(
                    widget.readableName,
                    style: CustomTextTheme(deviceProvider: deviceProvider)
                        .selectPictureButtonTextStyle(),
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
