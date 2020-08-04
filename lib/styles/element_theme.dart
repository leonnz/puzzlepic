import 'package:flutter/material.dart';

class CustomElementTheme {
  static BoxDecoration screenBackgroundBoxDecoration() {
    return const BoxDecoration(
      image: DecorationImage(
        fit: BoxFit.cover,
        image: AssetImage('assets/images/background.png'),
      ),
    );
  }

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

  static BoxDecoration muteButtonBoxDecoration() {
    return BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(100),
      boxShadow: const <BoxShadow>[
        BoxShadow(
          color: Colors.black45,
          blurRadius: 4,
          offset: Offset(1, 1),
        )
      ],
    );
  }

  static BoxDecoration appBarBoxDecoration({String image}) {
    return BoxDecoration(
      image: DecorationImage(
        image: AssetImage(image),
        fit: BoxFit.cover,
      ),
      boxShadow: const <BoxShadow>[
        BoxShadow(
          color: Colors.black45,
          blurRadius: 5.0,
          offset: Offset(0.0, 3.0),
        ),
      ],
    );
  }

  static BoxDecoration selectCategoryImageTextLabelBoxDecoration({String image}) {
    return const BoxDecoration(
      color: Color.fromRGBO(255, 255, 255, 0.80),
      borderRadius: BorderRadius.only(
        bottomLeft: Radius.circular(10),
        bottomRight: Radius.circular(10),
      ),
    );
  }

  static BoxDecoration shopButtonBoxDecoration() {
    return const BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.all(Radius.circular(10)),
      boxShadow: <BoxShadow>[
        BoxShadow(
          color: Colors.black45,
          blurRadius: 3.0,
          offset: Offset(0.0, 2.0),
        ),
      ],
    );
  }
}
