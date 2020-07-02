import 'package:flutter/material.dart';
import 'package:picturepuzzle/providers/game_state_provider.dart';
import 'package:provider/provider.dart';
import 'screens/select_category_screen.dart';
import './components/button.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => GameStateProvider(),
      child: MaterialApp(
        title: 'Puzzle Pic',
        theme: ThemeData(
          fontFamily: 'Rabelo',
          primarySwatch: Colors.blue,
          buttonTheme: ButtonThemeData(
            buttonColor: Colors.blue,
            textTheme: ButtonTextTheme.primary,
          ),
        ),
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
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Text('test'),
            Center(
              child: Button(
                buttonText: 'Play!',
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
