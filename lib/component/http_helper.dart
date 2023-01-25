import 'dart:io';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'movie.dart';

class HttpHelper {
  final String urlKey = '8b2201d73dba2456434a4dd5f12721e8';
  final String urlBase = 'https://api.themoviedb.org/3/movie/';
  final String urlUpcoming = '/upcoming?';
  final String urlLanguage = '&language=en-US';
  final String urlApiKeys = 'api_key=';
  final String urlSearchBase =
      'https://api.themoviedb.org/3/search/movie?api_key=8b2201d73dba2456434a4dd5f12721e8&query=';

  Future<List> getUpcoming() async {
    final String upcoming =urlBase + urlUpcoming + urlApiKeys + urlKey + urlLanguage;
    http.Response result = await http.get(Uri.parse(upcoming));
    if (result.statusCode == HttpStatus.ok) {
      final jsonResponse = json.decode(result.body);
      final moviesMap = jsonResponse['results'];
      List movies = moviesMap.map((i) => Movie.fromJson(i)).toList();
      return movies;
    } else {
      return urlKey.codeUnits;
    }
  }

  Future<List> findMovies(String title) async {
    final String query = urlSearchBase + title;
    http.Response result = await http.get(Uri.parse(query));
    if (result.statusCode == HttpStatus.ok) {
      final jsonResponse = json.decode(result.body);
      final movieMap = jsonResponse['results'];
      List movies = movieMap.map((i) => Movie.fromJson(i)).toList();
      return movies;
    } else {
      return urlKey.codeUnits;
    }
  }
}
