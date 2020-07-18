import 'package:flutter/material.dart';
import '../styles/customStyles.dart';
import '../providers/device_provider.dart';
import 'package:provider/provider.dart';

class ImageButton extends StatelessWidget {
  const ImageButton({
    Key key,
    this.assetName,
    this.readableName,
    this.categoryName,
    this.complete,
    this.imgNumber,
  }) : super(key: key);

  final int imgNumber;
  final String categoryName;
  final String assetName;
  final String readableName;
  final bool complete;

  @override
  Widget build(BuildContext context) {
    DeviceProvider deviceProvider = Provider.of<DeviceProvider>(context);
    return Card(
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
                  'assets/images/$categoryName/${assetName}_full.jpg'),
            ),
          ),
          Positioned(
            top: 5,
            right: 5,
            child: complete
                ? Icon(
                    Icons.check,
                    color: Colors.lightGreenAccent[400],
                    size: 40,
                  )
                : Container(),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: 50,
              width: double.infinity,
              decoration: BoxDecoration(
                  color: Color.fromRGBO(255, 255, 255, 0.80),
                  borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(10),
                      bottomRight: Radius.circular(10))),
              child: Center(
                child: Text(
                  readableName,
                  style: CustomTextTheme(deviceProvider: deviceProvider)
                      .selectPictureButtonTextStyle(context),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
