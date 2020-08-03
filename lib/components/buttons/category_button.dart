import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/device_provider.dart';
import '../../screens/select_picture_screen.dart';
import '../../styles/custom_styles.dart';

class CategoryButton extends StatelessWidget {
  const CategoryButton({Key key, @required this.categoryName, this.categoryReadableName})
      : super(key: key);
  final String categoryName;
  final String categoryReadableName;

  @override
  Widget build(BuildContext context) {
    final DeviceProvider deviceProvider = Provider.of<DeviceProvider>(context);

    return GestureDetector(
      onTap: () {
        deviceProvider.playSound(sound: 'fast_click.wav');
        Navigator.push(
          context,
          CupertinoPageRoute<bool>(
            builder: (BuildContext context) => SelectPicture(
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
                decoration: const BoxDecoration(
                  color: Color.fromRGBO(255, 255, 255, 0.80),
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(10),
                    bottomRight: Radius.circular(10),
                  ),
                ),
                child: Center(
                  child: Text(
                    categoryReadableName,
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
