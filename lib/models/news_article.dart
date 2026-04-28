//뉴스 기사 하나 추상화 dto
class NewsArticle {
  String title;
  String description;
  String url;
  String? urlToImage;
  String publishedAt;
  String? source;

  NewsArticle({
    required this.title,
    required this.description,
    required this.url,
    this.urlToImage,
    required this.publishedAt,
    this.source,
  });

  factory NewsArticle.fromJson(Map<String, dynamic> json) {
    return NewsArticle(
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      url: json['url'] ?? '',
      urlToImage: json['urlToImage'],
      publishedAt: json['publishedAt'] ?? '',
      source: json['source']?['name'],
    );
  }
}
