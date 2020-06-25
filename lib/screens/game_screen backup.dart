import 'package:flutter/material.dart';

class GameScreen extends StatefulWidget {
  GameScreen({Key key, @required this.image}) : super(key: key);

  final String image;

  @override
  _GameScreenState createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;
  double distance = 0.0;
  double initial = 0.0;

  Animation<Offset> moveTile({@required double distance}) {
    return Tween<Offset>(
      begin: Offset.zero,
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
    return Container(
      child: SafeArea(
        child: Scaffold(
          appBar: AppBar(
            title: Text(widget.image),
          ),
          body: Column(
            children: <Widget>[
              GestureDetector(
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
                  initial = 0.0;
                },
                child: SlideTransition(
                  position: moveTile(distance: distance),
                  child: Image(
                    image: AssetImage(widget.image),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
