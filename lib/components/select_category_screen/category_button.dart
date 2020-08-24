import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../data/images_data.dart';
import '../../providers/device_provider.dart';
import '../../providers/game_provider.dart';
import '../../screens/select_picture_screen.dart';
import '../../styles/element_theme.dart';
import '../../styles/text_theme.dart';

class CategoryButton extends StatelessWidget {
  const CategoryButton({
    Key key,
    @required this.categoryName,
  }) : super(key: key);
  final String categoryName;

  String getCategoryReadableName() {
    return Images.imageList
        .firstWhere((Map<String, dynamic> category) => category['categoryName'] == categoryName)[
            'categoryReadableName']
        .toString();
  }

  @override
  Widget build(BuildContext context) {
    final DeviceProvider deviceProvider = Provider.of<DeviceProvider>(context, listen: false);
    final GameProvider gameProvider = Provider.of<GameProvider>(context);

    return GestureDetector(
      onTap: () {
        deviceProvider.playSound(sound: 'fast_click.wav');

        gameProvider.setSelectedCategory(
            assetName: categoryName, readableName: getCategoryReadableName());

        Navigator.push(
          context,
          CupertinoPageRoute<bool>(
            builder: (BuildContext context) => SelectPictureScreen(
              category: categoryName,
            ),
          ),
        );
      },
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        elevation: 3,
        child: Stack(
          children: <Widget>[
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image(
                image: AssetImage('assets/images/_categories/${categoryName}_cat.png'),
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                padding: const EdgeInsets.all(5),
                height: deviceProvider.getUseMobileLayout ? 50 : 70,
                width: double.infinity,
                decoration: CustomElementTheme.selectCategoryImageTextLabelBoxDecoration(),
                child: Center(
                  child: Text(
                    getCategoryReadableName(),
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
