import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:news_app/model/article_model.dart';
import 'package:news_app/model/slider_model.dart';
import 'package:news_app/services/news.dart';
import 'package:news_app/services/slider_data.dart';
import 'package:news_app/views/pages/article_view.dart';

class AllNews extends StatefulWidget {
  String news;
  AllNews({required this.news});

  @override
  State<AllNews> createState() => _AllNewsState();
}

class _AllNewsState extends State<AllNews> {
  @override
  @override
  Widget build(BuildContext context) {
    List<SliderModel> sliders = [];
    List<ArticleModel> articles = [];
    bool _loading = true;

    getNews() async {
      News newsClass = News();
      await newsClass.getNews();
      articles = newsClass.news;
      setState(() {});
    }

    getSliders() async {
      Sliders slider = Sliders();
      await slider.getSliders();
      sliders = slider.sliders;
      setState(() {});
    }

    @override
    void initState() {
      getSliders();
      getNews();

      super.initState();
    }

    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              widget.news! + " News",
              style: TextStyle(
                color: Colors.blue,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        centerTitle: true,
        elevation: 0.0,
      ),
      body: Container(
        margin: const EdgeInsets.symmetric(horizontal: 10.0),
        child: ListView.builder(
          shrinkWrap: true,
          physics: const ClampingScrollPhysics(),
          itemCount:
              widget.news == "Breaking" ? sliders.length : articles.length,
          itemBuilder: (context, index) {
            return AllNewsSection(
              image: widget.news == "Breaking"
                  ? sliders[index].urlToImage!
                  : articles[index].urlToImage!,
              title: widget.news == "Breaking"
                  ? sliders[index].title!
                  : articles[index].title!,
              desc: widget.news == "Breaking"
                  ? sliders[index].description!
                  : articles[index].description!,
              url: widget.news == "Breaking"
                  ? sliders[index].url!
                  : articles[index].url!,
            );
          },
        ),
      ),
    );
  }
}

class AllNewsSection extends StatelessWidget {
  String image, desc, title, url;
  AllNewsSection(
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
