import 'package:flutter/material.dart';
import '../../models/news_article.dart';

class NewsItemWidget extends StatelessWidget {
  NewsArticle article;

  NewsItemWidget(this.article);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: article.urlToImage != null
          ? Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                image: DecorationImage(
                  image: NetworkImage(article.urlToImage!),
                  fit: BoxFit.cover,
                ),
              ),
            )
          : Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: Colors.grey.shade300,
              ),
            ),
      title: Text(article.title, maxLines: 2, overflow: TextOverflow.ellipsis),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            article.description,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          SizedBox(height: 4),
          Text(
            article.source ?? '',
            style: TextStyle(fontSize: 12, color: Colors.blue),
          ),
        ],
      ),
      onTap: (){

      },
    );
  }
}
