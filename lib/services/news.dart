import 'dart:convert';

import 'package:news_app/model/article_model.dart';
import 'package:http/http.dart' as http;

class News {
  List<ArticleModel> news = [];

  Future<void> getNews() async {
    String url =
        "https://newsapi.org/v2/everything?domains=wsj.com&apiKey=1fe1150da9984ceaa85097262285ab2a";

    var response = await http.get(Uri.parse(url));

    var jsonData = jsonDecode(response.body);

    if (jsonData['status'] == 'ok') {
      jsonData["articles"].forEach((element) {
        if (element["urlToImage"] != null && element['description'] != null) {
          ArticleModel articleModel = ArticleModel(
            title: element['title'],
            description: element['description'],
            content: element['content'],
            author: element['author'],
            urlToImage: element['urlToImage'],
            url: element['url'],
          );

          news.add(articleModel);
        }
      });
    }
  }
}
