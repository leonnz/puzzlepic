import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/device_provider.dart';
import '../../styles/custom_styles.dart';

class ShopErrorMessage extends StatelessWidget {
  const ShopErrorMessage({
    Key key,
    this.message,
  }) : super(key: key);

  final String message;

  @override
  Widget build(BuildContext context) {
    final DeviceProvider deviceProvider = Provider.of<DeviceProvider>(context);

    return Center(
      child: Container(
        margin: const EdgeInsets.all(10),
        padding: const EdgeInsets.all(10),
        height: deviceProvider.getUseMobileLayout ? 50 : 70,
        width: deviceProvider.getUseMobileLayout
            ? double.infinity
            : MediaQuery.of(context).size.width * 2 / 3,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(10)),
          boxShadow: <BoxShadow>[
            BoxShadow(
              color: Colors.black45,
              blurRadius: 3.0,
              offset: Offset(0.0, 2.0),
            ),
          ],
        ),
        child: Center(
          child: Text(
            message,
            style: CustomTextTheme.selectPictureButtonTextStyle(),
            // textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
