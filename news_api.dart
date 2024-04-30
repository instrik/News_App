import 'dart:convert';
import 'dart:developer';

import 'package:News_App/consts/http_exceptions.dart';
import 'package:News_App/models/bookmarks_model.dart';
import 'package:News_App/models/news_model.dart';

import 'package:http/http.dart' as http;

import '../consts/api_consts.dart';

class NewsAPiServices {
  static Future<List<NewsModel>> getAllNews(
      {required int page, required String sortBy}) async {
    try {
      var uri = Uri.https(BASEURL, "v2/everything", {
        "q": "bitcoin",
        "pageSize": "5",
        "domains": "instrik.com",
        "page": page.toString(),
        "sortBy": sortBy
        // "apiKEY": API_KEY
      });
      var response = await http.get(
        uri,
        headers: {"X-Api-key": API_KEY},
      );

      Map data = jsonDecode(response.body);
      List newsTempList = [];

      if (data['code'] != null) {
        throw HttpException(data['code']);
        // throw data['message'];
      }
      for (var v in data["articles"]) {
        newsTempList.add(v);
      }
      return NewsModel.newsFromSnapshot(newsTempList);
    } catch (error) {
      throw error.toString();
    }
  }

  static Future<List<NewsModel>> getTopHeadlines() async {
    try {
      var uri = Uri.https(BASEURL, "v2/top-headlines", {'country': 'us'});
      var response = await http.get(
        uri,
        headers: {"X-Api-key": API_KEY},
      );
      log('Response status: ${response.statusCode}');
      Map data = jsonDecode(response.body);
      List newsTempList = [];

      if (data['code'] != null) {
        throw HttpException(data['code']);
        // throw data['message'];
      }
      for (var v in data["articles"]) {
        newsTempList.add(v);
      }
      return NewsModel.newsFromSnapshot(newsTempList);
    } catch (error) {
      throw error.toString();
    }
  }

  static Future<List<NewsModel>> searchNews({required String query}) async {
    try {
      var uri = Uri.https(BASEURL, "v2/everything", {
        "q": query,
        "pageSize": "10",
        "domains": "instrik.com",
      });
      var response = await http.get(
        uri,
        headers: {"X-Api-key": API_KEY},
      );

      Map data = jsonDecode(response.body);
      List newsTempList = [];

      if (data['code'] != null) {
        throw HttpException(data['code']);
        // throw data['message'];
      }
      for (var v in data["articles"]) {
        newsTempList.add(v);
      }
      return NewsModel.newsFromSnapshot(newsTempList);
    } catch (error) {
      throw error.toString();
    }
  }

  static Future<List<BookmarksModel>?> getBookmarks() async {
    try {
      var uri = Uri.https(BASEURL_FIREBASE, "bookmarks.json");
      var response = await http.get(
        uri,
      );

      Map data = jsonDecode(response.body);
      List allKeys = [];

      if (data['code'] != null) {
        throw HttpException(data['code']);
        // throw data['message'];
      }
      for (String key in data.keys) {
        allKeys.add(key);
      }
      log("allKeys $allKeys");
      return BookmarksModel.bookmarksFromSnapshot(json: data, allKeys: allKeys);
    } catch (error) {
      rethrow;
    }
  }
}
