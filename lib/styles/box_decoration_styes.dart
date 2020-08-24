import 'package:flutter/material.dart';

final BoxDecoration kMuteButtonBoxDecoration = BoxDecoration(
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

const BoxDecoration kScreenBackgroundBoxDecoration = BoxDecoration(
  image: DecorationImage(
    fit: BoxFit.cover,
    image: AssetImage('assets/images/background.png'),
  ),
);

final BoxDecoration kHomeScreenButtonBoxDecoration = BoxDecoration(
  borderRadius: BorderRadius.circular(5),
  boxShadow: const <BoxShadow>[
    BoxShadow(
      color: Colors.black45,
      blurRadius: 5.0,
      offset: Offset(0.0, 5.0),
    ),
  ],
  gradient: LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: <Color>[
    Colors.white,
    Colors.grey[350],
  ]),
);

final BoxDecoration kCategoryScreenShopButtonBoxDecoration = BoxDecoration(
  color: Colors.white,
  borderRadius: BorderRadius.circular(8),
  border: Border.all(color: Colors.purple[200]),
);

final BoxDecoration kCategoryScreenAppBarBoxDecoration = BoxDecoration(
  gradient: LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: <Color>[
    Colors.grey[300],
    Colors.white,
  ]),
  boxShadow: const <BoxShadow>[
    BoxShadow(
      color: Colors.black45,
      blurRadius: 5.0,
      offset: Offset(0.0, 3.0),
    ),
  ],
);

final BoxDecoration kShopScreenAppBarBoxDecoration = BoxDecoration(
  gradient: LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: <Color>[
    Colors.grey[300],
    Colors.white,
  ]),
  boxShadow: const <BoxShadow>[
    BoxShadow(
      color: Colors.black45,
      blurRadius: 5.0,
      offset: Offset(0.0, 3.0),
    ),
  ],
);

const BoxDecoration kSelectCategoryImageTextLabelBoxDecoration = BoxDecoration(
  color: Color.fromRGBO(255, 255, 255, 0.80),
  borderRadius: BorderRadius.only(
    bottomLeft: Radius.circular(10),
    bottomRight: Radius.circular(10),
  ),
);

const BoxDecoration kShopButtonBoxDecoration = BoxDecoration(
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

final BoxDecoration kShopSuccessMessageBoxDecoration = BoxDecoration(
  color: Colors.green[400],
  borderRadius:
      const BorderRadius.only(bottomLeft: Radius.circular(5), bottomRight: Radius.circular(5)),
);

BoxDecoration kImageScreenAppBarBoxDecoration({@required String image}) {
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
