import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:picturepuzzle/components/category_button.dart';
import '../data/images_data.dart';

class SelectCategory extends StatelessWidget {
  const SelectCategory({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Select Category',
          style: Theme.of(context).textTheme.headline1,
        ),
        backgroundColor: Color(0xff501E5D),
      ),
      body: Container(
        padding: EdgeInsets.all(10),
        child: GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
          ),
          itemCount: Images.imageList.length,
          itemBuilder: (BuildContext context, int i) {
            return CategoryButton(
                categoryName: Images.imageList[i]["categoryName"]);
          },
        ),
      ),
    );
  }
}
