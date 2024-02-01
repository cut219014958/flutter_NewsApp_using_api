import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:news_app/miscellaneous/app_loading.dart';
import 'package:news_app/model/article_model.dart';
import 'package:news_app/model/show_category.dart';
import 'package:news_app/services/show_category_news.dart';
import 'package:news_app/views/pages/article_view.dart';

class CategoryNews extends StatefulWidget {
  String name;
  CategoryNews({required this.name});

  @override
  State<CategoryNews> createState() => _CategoryNewsState();
}

class _CategoryNewsState extends State<CategoryNews> {
  List<ShowCategoryModel> categories = [];

  bool _loading = true;

  int activeIndex = 0;

  @override
  void initState() {
    getNews();

    super.initState();
  }

  getNews() async {
    ShowCategoryNews showCategoryNews = ShowCategoryNews();
    await showCategoryNews.getCategories(widget.name.toLowerCase());
    categories = showCategoryNews.categories;
    setState(() {
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const LoadingPage(),
                ));
          },
        ),
        title: Text(
          widget.name,
          style: const TextStyle(
            color: Colors.blue,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        elevation: 0.0,
      ),
      body: Container(
        margin: const EdgeInsets.symmetric(
          horizontal: 10.0,
        ),
        child: ListView.builder(
          shrinkWrap: true,
          physics: const ClampingScrollPhysics(),
          itemCount: categories.length,
          itemBuilder: (context, index) {
            return ShowCategory(
              image: categories[index].urlToImage!,
              title: categories[index].title!,
              desc: categories[index].description!,
              url: categories[index].url!,
            );
          },
        ),
      ),
    );
  }
}

class ShowCategory extends StatelessWidget {
  String image, desc, title, url;
  ShowCategory(
      {required this.image,
      required this.title,
      required this.desc,
      required this.url});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ArticleView(
                blogUrl: url,
              ),
            ));
      },
      child: Container(
        child: Column(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: CachedNetworkImage(
                imageBuilder: (context, imageProvider) => Container(
                  decoration: BoxDecoration(
                    // Use the imageProvider to set the background image
                    image: DecorationImage(
                      image: imageProvider, // Cast to ImageProvider
                      fit: BoxFit.cover,
                    ),
                  ),
                ),

                imageUrl: image,
                width: MediaQuery.of(context).size.width,
                height: 200,
                fit: BoxFit.cover,
                placeholder: (context, url) => CircularProgressIndicator(),
                // Error widget can be customized as needed
                errorWidget: (context, url, error) => Icon(Icons.error),
              ),
            ),
            const SizedBox(
              height: 5.0,
            ),
            Text(
              title,
              maxLines: 2,
              style: const TextStyle(
                color: Colors.black,
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              desc,
              maxLines: 3,
            ),
            const SizedBox(
              height: 20.0,
            ),
          ],
        ),
      ),
    );
  }
}
