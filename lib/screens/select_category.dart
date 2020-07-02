import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:picturepuzzle/components/category_button.dart';
import '../data/images.dart';

class SelectCategory extends StatelessWidget {
  const SelectCategory({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Future<String> getJson() async {
      String jsonData = await DefaultAssetBundle.of(context)
          .loadString("assets/data/asset_image_map.json");
      return jsonData;
    }

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text('Select Cateogry'),
        ),
        body: Container(
          margin: EdgeInsets.all(10),
          child: FutureBuilder<String>(
            future: getJson(),
            builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
              Widget view;
              if (snapshot.hasData) {
                List<dynamic> assetImageMap = jsonDecode(snapshot.data);

                view = GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                  ),
                  itemCount: assetImageMap.length,
                  itemBuilder: (BuildContext context, int i) {
                    var images = Images.fromJson(assetImageMap[i]);
                    return CategoryButton(categoryName: images.categoryName);
                  },
                );
              } else {
                // Todo Maybe return a spinner
                view = Container(width: 0.0, height: 0.0);
              }
              return view;
            },
          ),
        ),
      ),
    );
  }
}
