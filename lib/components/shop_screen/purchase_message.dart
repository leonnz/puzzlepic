import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/shop_provider.dart';
import '../../styles/box_decoration_styes.dart';

class PurchaseMessage extends StatefulWidget {
  const PurchaseMessage({Key key}) : super(key: key);

  @override
  _PurchaseMessageState createState() => _PurchaseMessageState();
}

class _PurchaseMessageState extends State<PurchaseMessage> with SingleTickerProviderStateMixin {
  AnimationController _controller;
  Animation<Offset> _animation;

  @override
  void initState() {
    _controller = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );

    _animation = Tween<Offset>(begin: const Offset(0, -10), end: const Offset(0, 0))
        .animate(CurvedAnimation(parent: _controller, curve: Curves.fastOutSlowIn));

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final ShopProvider shopProvider = Provider.of<ShopProvider>(context);

    if (shopProvider.getShowSuccessMessage) {
      _controller.forward().then(
            (_) => Future<TickerFuture>.delayed(const Duration(milliseconds: 2000)).then(
              (_) {
                _controller.reverse();
                shopProvider.setShowSuccessMessage(show: false);
              },
            ),
          );
    }

    return SlideTransition(
      position: _animation,
      child: Container(
        decoration: kShopSuccessMessageBoxDecoration,
        height: 50,
        width: double.infinity,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const <Widget>[
            Text(
              'Purchase complete',
              style: TextStyle(color: Colors.white),
            ),
            Icon(
              Icons.check,
              color: Colors.lightGreenAccent,
            ),
          ],
        ),
      ),
    );
  }
}
