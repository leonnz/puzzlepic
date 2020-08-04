import 'package:flutter/material.dart';

class CustomElementThemes {
  static BoxDecoration homeScreenButtonBoxDecoration() {
    return BoxDecoration(
      borderRadius: BorderRadius.circular(5),
      boxShadow: const <BoxShadow>[
        BoxShadow(
          color: Colors.black45,
          blurRadius: 5.0,
          offset: Offset(0.0, 5.0),
        ),
      ],
      gradient:
          LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: <Color>[
        Colors.white,
        Colors.grey[350],
      ]),
    );
  }
}
