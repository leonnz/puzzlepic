import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:picturepuzzle/components/category_button.dart';

class SelectCategory extends StatelessWidget {
  const SelectCategory({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<String> categories = [
      'Flowers',
      'Animals',
      'Buildings',
      'Sports',
    ];

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text('Select Cateogry'),
        ),
        body: Container(
          margin: EdgeInsets.all(10),
          child: GridView.builder(
            gridDelegate:
                SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
            itemCount: categories.length,
            itemBuilder: (context, i) {
              return CategoryButton(categoryName: categories[i]);
            },
          ),
        ),
      ),
    );
  }
}
