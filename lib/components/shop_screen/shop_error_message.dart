import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/device_provider.dart';
import '../../styles/element_theme.dart';
import '../../styles/text_theme.dart';

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
        decoration: CustomElementTheme.shopButtonBoxDecoration(),
        child: Center(
          child: Text(
            message,
            style: CustomTextTheme.selectPictureButtonTextStyle(),
          ),
        ),
      ),
    );
  }
}
