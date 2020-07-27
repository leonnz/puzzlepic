import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:audioplayers/audioplayers.dart';

import '../components/category_button.dart';
import '../data/images_data.dart';
import '../providers/device_provider.dart';
import '../styles/customStyles.dart';

class SelectCategory extends StatelessWidget {
  const SelectCategory({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    DeviceProvider deviceProvider = Provider.of<DeviceProvider>(context);

    return WillPopScope(
      onWillPop: () async {
        Navigator.pop(context, true);
        return true;
      },
      child: GestureDetector(
        onPanUpdate: (details) {
          if (details.delta.dx > 0) {
            Navigator.pop(context, true);
          }
        },
        child: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              fit: BoxFit.cover,
              image: AssetImage('assets/images/background.png'),
            ),
          ),
          child: Scaffold(
            backgroundColor: Color.fromRGBO(255, 255, 255, 0.7),
            appBar: PreferredSize(
              preferredSize:
                  Size.fromHeight(deviceProvider.getDeviceScreenHeight * 0.10),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black45,
                      blurRadius: 5.0,
                      offset: Offset(0.0, 3.0),
                    ),
                  ],
                ),
                child: Stack(
                  alignment: Alignment.center,
                  children: <Widget>[
                    Align(
                      alignment: Alignment.centerLeft,
                      child: IconButton(
                        iconSize: deviceProvider.getUseMobileLayout ? 25 : 50,
                        icon: Icon(Icons.arrow_back_ios),
                        onPressed: () {
                          deviceProvider.getAudioCache.play(
                            'fast_click.wav',
                            mode: PlayerMode.LOW_LATENCY,
                          );
                          Navigator.pop(context, true);
                        },
                      ),
                    ),
                    Text(
                      'Categories',
                      style: CustomTextTheme(deviceProvider: deviceProvider)
                          .selectScreenTitleTextStyle(context),
                    ),
                  ],
                ),
              ),
            ),
            body: Container(
              padding: EdgeInsets.all(10),
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: deviceProvider.getGridSize,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                ),
                itemCount: Images.imageList.length,
                itemBuilder: (BuildContext context, int i) {
                  return CategoryButton(
                    categoryName: Images.imageList[i]["categoryName"],
                    categoryReadableName: Images.imageList[i]
                        ["categoryReadableName"],
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}
