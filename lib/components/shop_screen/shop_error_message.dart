import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/device_provider.dart';
import '../../styles/box_decoration_styes.dart';
import '../../styles/text_styles.dart';

class ShopErrorMessage extends StatelessWidget {
  const ShopErrorMessage({
    Key key,
    @required this.message,
  }) : super(key: key);

  final String message;

  @override
  Widget build(BuildContext context) {
    final DeviceProvider deviceProvider = Provider.of<DeviceProvider>(context, listen: false);

    return Center(
      child: Container(
        margin: const EdgeInsets.all(10),
        padding: const EdgeInsets.all(10),
        height: DeviceProvider.shortestSide / 9.5,
        width: deviceProvider.getUseMobileLayout
            ? double.infinity
            : MediaQuery.of(context).size.width * 2 / 3,
        decoration: kShopButtonBoxDecoration,
        child: Center(
          child: Text(
            message,
            style: kSelectPictureButtonTextStyle,
          ),
        ),
      ),
    );
  }
}
