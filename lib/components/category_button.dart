import 'package:flutter/material.dart';
import '../screens/select_picture.dart';
import '../utilities/helpers.dart';

class CategoryButton extends StatelessWidget {
  const CategoryButton({Key key, @required this.categoryName})
      : super(key: key);
  final String categoryName;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: GestureDetector(
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => SelectPicture(category: categoryName),
          ),
        ),
        child: Card(
          elevation: 3,
          borderOnForeground: true,
          child: Stack(
            children: [
              Image(
                image: AssetImage(
                    'assets/images/_category/${categoryName}_cat.png'),
              ),
              Align(
                alignment: Alignment.center,
                child: Container(
                  height: 50,
                  width: double.infinity,
                  decoration:
                      BoxDecoration(color: Color.fromRGBO(255, 255, 255, 0.90)),
                  child: Center(
                    child: Text(
                      Helpers.capitalize(categoryName),
                      style: TextStyle(
                        fontSize: 25.0,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
