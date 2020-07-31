import 'package:flutter/material.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:provider/provider.dart';

import '../../providers/device_provider.dart';
import '../../providers/shop_provider.dart';
import '../../styles/custom_styles.dart';

class RemoveAdShopButton extends StatelessWidget {
  const RemoveAdShopButton({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final DeviceProvider deviceProvider = Provider.of<DeviceProvider>(context);
    final ShopProvider shopProvider = Provider.of<ShopProvider>(context);

    return FutureBuilder<List<ProductDetails>>(
      future: shopProvider.setRemoveAdsProduct(),
      builder: (BuildContext context, AsyncSnapshot<List<ProductDetails>> snapshot) {
        Widget removeAdShopButton;
        if (snapshot.connectionState == ConnectionState.done && snapshot.hasData) {
          removeAdShopButton = Expanded(
            child: ListView.builder(
              itemCount: snapshot.data.length,
              padding: const EdgeInsets.all(20),
              itemBuilder: (BuildContext context, int index) {
                return GestureDetector(
                  onTap: () {
                    deviceProvider.playSound(sound: 'fast_click.wav');
                    shopProvider.buyProduct(snapshot.data[index]);
                  },
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    height: deviceProvider.getUseMobileLayout ? 50 : 70,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: const BorderRadius.all(Radius.circular(10)),
                      boxShadow: <BoxShadow>[
                        BoxShadow(
                          color: Colors.black45,
                          blurRadius: 3.0,
                          offset: const Offset(0.0, 2.0),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                          snapshot.data[index].title,
                          style: CustomTextTheme(deviceProvider: deviceProvider)
                              .selectPictureButtonTextStyle(),
                        ),
                        Text(
                          shopProvider.getRemovedAdsPurchased
                              ? snapshot.data[index].price
                              : 'Purchased',
                          style: CustomTextTheme(deviceProvider: deviceProvider)
                              .selectPictureButtonTextStyle(),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          );
        } else {
          print(snapshot.connectionState);
          print(snapshot.hasData);

          removeAdShopButton = Container();
        }
        return removeAdShopButton;
      },
    );
  }
}
