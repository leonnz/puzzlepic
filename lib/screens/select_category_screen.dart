import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../components/category_button.dart';
import '../data/images_data.dart';
import '../providers/device_provider.dart';
import 'package:provider/provider.dart';
import '../styles/customStyles.dart';

class SelectCategory extends StatelessWidget {
  const SelectCategory({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    DeviceProvider deviceState = Provider.of<DeviceProvider>(context);
    deviceState.setGridSize(
        useMobile: deviceState.getUseMobileLayout,
        orientation: MediaQuery.of(context).orientation);

    return GestureDetector(
      onPanUpdate: (details) {
        if (details.delta.dx > 0) {
          Navigator.pop(context);
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
          appBar: AppBar(
            centerTitle: true,
            title: Text(
              'Categories',
              style: selectScreenTitleTextStyle,
            ),
            backgroundColor: Color(0xffffffff),
            iconTheme: IconThemeData(
              color: Colors.black,
            ),
            leading: IconButton(
              icon: Icon(Icons.arrow_back_ios),
              onPressed: () => Navigator.pop(context),
            ),
          ),
          body: Container(
            padding: EdgeInsets.all(10),
            child: GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: deviceState.getGridSize,
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
    );
  }
}
