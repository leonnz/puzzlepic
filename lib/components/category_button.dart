import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:audioplayers/audio_cache.dart';
import 'package:audioplayers/audioplayers.dart';

import '../screens/select_picture_screen.dart';
import '../styles/customStyles.dart';
import '../providers/device_provider.dart';

class CategoryButton extends StatelessWidget {
  const CategoryButton(
      {Key key, @required this.categoryName, this.categoryReadableName})
      : super(key: key);
  final String categoryName;
  final String categoryReadableName;

  @override
  Widget build(BuildContext context) {
    DeviceProvider deviceProvider = Provider.of<DeviceProvider>(context);
    AudioCache categoryButtonAudio = AudioCache(prefix: 'audio/');
    categoryButtonAudio.load('fast_click.wav');
    categoryButtonAudio.disableLog();

    return Container(
      child: GestureDetector(
        onTap: () {
          categoryButtonAudio.play('fast_click.wav',
              mode: PlayerMode.LOW_LATENCY);
          Navigator.push(
            context,
            CupertinoPageRoute(
              builder: (context) => SelectPicture(
                category: categoryName,
                categoryReadableName: categoryReadableName,
              ),
            ),
          );
        },
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          elevation: 3,
          borderOnForeground: true,
          child: Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image(
                  image: AssetImage(
                      'assets/images/_categories/${categoryName}_cat.png'),
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  padding: EdgeInsets.all(5),
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
                      categoryReadableName,
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
      ),
    );
  }
}
