import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:news_app/model/show_category.dart';
import 'package:news_app/model/slider_model.dart';

class ShowCategoryNews {
  List<ShowCategoryModel> categories = [];

  Future<void> getCategories(String category) async {
    String url =
        "https://newsapi.org/v2/top-headlines?country=us&category=$category&apiKey=1fe1150da9984ceaa85097262285ab2a";

    var response = await http.get(Uri.parse(url));

    var jsonData = jsonDecode(response.body);

    if (jsonData['status'] == 'ok') {
      jsonData["articles"].forEach((element) {
        if (element["urlToImage"] != null && element['description'] != null) {
          ShowCategoryModel categoryModel = ShowCategoryModel(
            title: element['title'],
            description: element['description'],
            content: element['content'],
            author: element['author'],
            urlToImage: element['urlToImage'],
            url: element['url'],
          );

          categories.add(categoryModel);
        }
      });
    }
  }
}
