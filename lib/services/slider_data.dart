import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:news_app/model/slider_model.dart';

class Sliders {
  List<SliderModel> sliders = [];

  Future<void> getSliders() async {
    String url =
        "https://newsapi.org/v2/everything?q=apple&from=2023-12-17&to=2023-12-17&sortBy=popularity&apiKey=1fe1150da9984ceaa85097262285ab2a";

    var response = await http.get(Uri.parse(url));

    var jsonData = jsonDecode(response.body);

    if (jsonData['status'] == 'ok') {
      jsonData["articles"].forEach((element) {
        if (element["urlToImage"] != null && element['description'] != null) {
          SliderModel sliderModel = SliderModel(
            title: element['title'],
            description: element['description'],
            content: element['content'],
            author: element['author'],
            urlToImage: element['urlToImage'],
            url: element['url'],
          );

          sliders.add(sliderModel);
        }
      });
    }
  }
}
