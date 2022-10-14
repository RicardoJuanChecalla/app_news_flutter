import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:news_app/src/models/category_model.dart';
import 'package:news_app/src/models/news_models.dart';
import 'package:http/http.dart' as http;

class NewsService extends ChangeNotifier {
  final String _baseUrl = 'newsapi.org';
  final String _apiKey = '33a3a04dc43e4e5eaab0f1e140bc00f6';

  List<Article> headlines = [];
  String _selectedCategory = 'business';
  List<Category> categories = [
    Category(FontAwesomeIcons.building, 'business'),
    Category(FontAwesomeIcons.tv, 'entertainment'),
    Category(FontAwesomeIcons.addressCard, 'general'),
    Category(FontAwesomeIcons.headSideVirus, 'health'),
    Category(FontAwesomeIcons.vials, 'science'),
    Category(FontAwesomeIcons.volleyball, 'sports'),
    Category(FontAwesomeIcons.memory, 'technology'),
  ];

  Map<String, List<Article>> categoryArticles = {};

  NewsService() {
    getTopHeadLines();
    for (var item in categories) {
      categoryArticles[item.name] = [];
    }
  }

  String get selectedCategory => _selectedCategory;
  set selectedCategory(String value) {
    _selectedCategory = value;
    getArticlesByCategory(value);
    notifyListeners();
  }

  List<Article>? get getArticleBySelectedCategory =>
      categoryArticles[selectedCategory];

  getTopHeadLines() async {
    final url = Uri.https(_baseUrl, 'v2/top-headlines',
        {'apiKey': _apiKey, 'country': 'us', 'category': 'business'});
    final response = await http.get(url);
    final newsResponse = NewsResponse.fromJson(response.body);
    headlines.addAll(newsResponse.articles);
    notifyListeners();
  }

  getArticlesByCategory(String category) async {
    if (categoryArticles[category]!.isNotEmpty) {
      return categoryArticles[category];
    }
    final url = Uri.https(_baseUrl, 'v2/top-headlines',
        {'apiKey': _apiKey, 'country': 'us', 'category': category});
    final response = await http.get(url);
    final newsResponse = NewsResponse.fromJson(response.body);
    categoryArticles[category]!.addAll(newsResponse.articles);
    notifyListeners();
  }
}
