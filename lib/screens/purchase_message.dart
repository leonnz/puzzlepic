import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/shop_provider.dart';

class PurchaseMessage extends StatefulWidget {
  const PurchaseMessage({
    Key key,
  }) : super(key: key);

  @override
  _PurchaseMessageState createState() => _PurchaseMessageState();
}

class _PurchaseMessageState extends State<PurchaseMessage> with SingleTickerProviderStateMixin {
  Animation<Offset> _animation;

  @override
  void initState() {
    _animation = Tween<Offset>(begin: const Offset(0, -10), end: const Offset(0, 0)).animate(
        CurvedAnimation(
            parent: ShopProvider.puchaseMessageController, curve: Curves.fastOutSlowIn));

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: _animation,
      child: Container(
        color: Colors.green,
        height: 100,
        width: double.infinity,
        child: const Text('Purchase complete'),
      ),
    );
  }
}
