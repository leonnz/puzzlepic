import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:picturepuzzle/components/category_button.dart';
import '../data/images_data.dart';

class SelectCategory extends StatelessWidget {
  const SelectCategory({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text('Select Cateogry'),
          backgroundColor: Color(0xff000000),
        ),
        body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color(0xff501E5D),
                Color(0xff9E2950),
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
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
      ),
    );
  }
}
