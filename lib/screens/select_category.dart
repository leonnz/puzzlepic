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

    List<CategoryButton> generateCategoryCards() {
      List<CategoryButton> cards = [];

      categories.forEach((category) {
        cards.add(
          CategoryButton(categoryName: category),
        );
      });

      return cards;
    }

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text('Select Cateogry'),
        ),
        body: Container(
          margin: EdgeInsets.all(10),
          child: GridView(
            gridDelegate:
                SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
            children: generateCategoryCards(),
          ),
        ),
      ),
    );
  }
}
