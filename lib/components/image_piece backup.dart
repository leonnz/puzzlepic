import 'package:flutter/material.dart';

class ImagePiece extends StatefulWidget {
  const ImagePiece({Key key, @required this.image}) : super(key: key);

  final String image;

  @override
  _ImagePieceState createState() => _ImagePieceState();
}

class _ImagePieceState extends State<ImagePiece>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;
  double distance = 0.0;
  double initial = 0.0;

  Offset beginOffset = Offset.zero;

  Animation<Offset> moveTile({@required double distance}) {
    return Tween<Offset>(
      begin: Offset(0.0, 0.0),
      end: Offset(distance > 0.0 ? 0.5 : -0.5, 0.0),
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.linear,
    ));
  }

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(milliseconds: 100),
      vsync: this,
    );
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // return GestureDetector(
    //   onHorizontalDragStart: (DragStartDetails details) {
    //     initial = details.globalPosition.dx;
    //   },
    //   onHorizontalDragUpdate: (DragUpdateDetails details) {
    //     setState(() {
    //       distance = details.globalPosition.dx - initial;
    //     });
    //     print(distance);
    //     _controller.forward();
    //   },
    //   onHorizontalDragEnd: (DragEndDetails details) {
    //     initial = 0.0;
    //   },
    //   child: SlideTransition(
    //     position: moveTile(distance: distance),
    //     child: Image(
    //       image: AssetImage(widget.image),
    //     ),
    //   ),
    // );
    return SlideTransition(
      position: moveTile(distance: distance),
      child: GestureDetector(
        onHorizontalDragStart: (DragStartDetails details) {
          initial = details.globalPosition.dx;
        },
        onHorizontalDragUpdate: (DragUpdateDetails details) {
          setState(() {
            distance = details.globalPosition.dx - initial;
          });
          _controller.forward();
        },
        onHorizontalDragEnd: (DragEndDetails details) {
          setState(() {
            initial = 0.0;
          });
        },
        child: Image(
          image: AssetImage(widget.image),
        ),
      ),
    );
  }
}
