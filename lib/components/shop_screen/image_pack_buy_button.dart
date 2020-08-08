import 'package:flutter/material.dart';

class ImagePackBuyButton extends StatelessWidget {
  const ImagePackBuyButton({Key key, @required this.imagePackProductPrice, this.onClickAction})
      : super(key: key);

  final String imagePackProductPrice;
  final Function onClickAction;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 20.0),
      child: RaisedButton(
        color: Colors.green,
        onPressed: onClickAction != null ? () => onClickAction() : null,
        child: Text(
          imagePackProductPrice,
          style: const TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}
