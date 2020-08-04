import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/device_provider.dart';
import '../../screens/shop_screen.dart';
import '../../styles/element_theme.dart';

class CategoryShopButton extends StatelessWidget {
  const CategoryShopButton({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final DeviceProvider deviceProvider = Provider.of<DeviceProvider>(context);

    return GestureDetector(
      onTap: () {
        deviceProvider.playSound(sound: 'fast_click.wav');
        Navigator.push(
            context,
            MaterialPageRoute<bool>(
              builder: (BuildContext context) => ShopScreen(),
            ));
      },
      child: Padding(
        padding: const EdgeInsets.only(right: 40),
        child: Align(
          alignment: Alignment.centerRight,
          child: Container(
            padding: const EdgeInsets.all(5),
            decoration: CustomElementTheme.cetegoryScreenShopButtonBoxDecoration(),
            child: Icon(
              Icons.add,
              size: deviceProvider.getUseMobileLayout ? 35 : 50,
              color: Colors.black45,
            ),
          ),
        ),
      ),
    );
  }
}
