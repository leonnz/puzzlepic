import 'package:flutter/material.dart';
import 'package:picturepuzzle/providers/game_state_provider.dart';
import 'package:provider/provider.dart';
import './screens/select_category.dart';
import './components/button.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => GameStateProvider(),
      child: MaterialApp(
        title: 'Picture Puzzle',
        theme: ThemeData(
            fontFamily: 'Rabelo',
            primarySwatch: Colors.purple,
            buttonTheme: ButtonThemeData(
                buttonColor: Colors.purple,
                textTheme: ButtonTextTheme.primary)),
        initialRoute: '/',
        routes: {
          '/': (context) => Home(),
        },
      ),
    );
  }
}

class Home extends StatelessWidget {
  const Home({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text('Picture Puzzle'),
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          // mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            Text('test'),
            Center(
              child: Button(
                buttonText: 'Play!',
                margin: 0.0,
                action: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SelectCategory(),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
