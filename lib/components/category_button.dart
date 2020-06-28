import 'package:flutter/material.dart';
import '../screens/select_picture.dart';

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
          child: Center(
            child: Container(
              child: Text(categoryName),
            ),
          ),
        ),
      ),
    );
  }
}
