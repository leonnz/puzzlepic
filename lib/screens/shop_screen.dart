import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../components/buttons/appbar_leading_button.dart';
import '../components/shop_screen/image_pack_list.dart';
import '../components/shop_screen/remove_ad_shop_button.dart';
import '../providers/device_provider.dart';
import '../providers/shop_provider.dart';
import '../styles/custom_styles.dart';

class ShopScreen extends StatefulWidget {
  @override
  _ShopScreenState createState() => _ShopScreenState();
}

class _ShopScreenState extends State<ShopScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final DeviceProvider deviceProvider = Provider.of<DeviceProvider>(context);
    final ShopProvider shopProvider = Provider.of<ShopProvider>(context);

    shopProvider.initialize();

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(deviceProvider.getDeviceScreenHeight * 0.10),
        child: Container(
          decoration: BoxDecoration(
            image: const DecorationImage(
              image: AssetImage('assets/images/_categories/_categories_banner.png'),
              fit: BoxFit.cover,
            ),
            boxShadow: <BoxShadow>[
              BoxShadow(
                color: Colors.black45,
                blurRadius: 5.0,
                offset: const Offset(0.0, 3.0),
              ),
            ],
          ),
          child: Stack(
            alignment: Alignment.center,
            children: <Widget>[
              AppBarLeadingButton(icon: Icons.close),
              Text(
                'Shop',
                style: CustomTextTheme(deviceProvider: deviceProvider)
                    .selectScreenTitleTextStyle(context),
              ),
            ],
          ),
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          const RemoveAdShopButton(),
          const Text('Image Packs'),
          // if (_imagePackProducts.isNotEmpty)
          //   ImagePackList(
          //     imagePackProducts: _imagePackProducts,
          //   ),
          const Spacer(),
          Text(shopProvider.getPastPurchases.length.toString()),
          Text(shopProvider.getAdProduct.toString()),
          Text(shopProvider.getProducts.length.toString()),
        ],
      ),
    );
  }
}

// Column(
//   children: <Widget>[
//     Text('test'),

// for (var prod in _products)
//   if (_hasPurchased(prod.id) != null) ...[
//     Text('Already purchased'),
//   ] else ...[
//     ListView.builder(
//       itemCount: _products.length,
//       itemBuilder: (context, index) {
//         return Container(
//           child: Text(_products[index].title),
//         );
//       },
//     ),
//     Text(prod.title),
//     Text(prod.description),
//     Text(prod.price),
//     FlatButton(
//       child: Text('BUY IT!!!'),
//       color: Colors.green,
//       onPressed: () => _buyProduct(prod),
//     )
//   ]
//   ],
// ),
