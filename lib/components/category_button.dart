import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../screens/select_picture_screen.dart';
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
          CupertinoPageRoute(
            builder: (context) => SelectPicture(category: categoryName),
          ),
        ),
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          elevation: 3,
          borderOnForeground: true,
          child: Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image(
                  image: AssetImage(
                      'assets/images/_category/${categoryName}_cat.png'),
                ),
              ),
              Align(
                alignment: Alignment.center,
                child: Container(
                  height: 50,
                  width: double.infinity,
                  decoration:
                      BoxDecoration(color: Color.fromRGBO(255, 255, 255, 0.80)),
                  child: Center(
                    child: Text(
                      Helpers.capitalize(categoryName),
                      style: Theme.of(context).textTheme.headline2,
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
