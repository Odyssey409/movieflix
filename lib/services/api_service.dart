import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:movieflix/models/movies_model.dart';
import 'package:movieflix/models/movie_detail_model.dart';

class ApiService {
  static const String baseUrl = "https://movies-api.nomadcoders.workers.dev";

  static Future<List<MoviesModel>> fetchPopularMovies() async {
    return _fetchMoviesFromEndpoint('$baseUrl/popular');
  }

  static Future<List<MoviesModel>> fetchNowPlayingMovies() async {
    return _fetchMoviesFromEndpoint('$baseUrl/now-playing');
  }

  static Future<List<MoviesModel>> fetchComingSoonMovies() async {
    return _fetchMoviesFromEndpoint('$baseUrl/coming-soon');
  }

  static Future<MovieDetailModel> getMovieById(String id) async {
    final url = Uri.parse('$baseUrl/movie?id=$id');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final Map<String, dynamic> json = jsonDecode(response.body);
      return MovieDetailModel.fromJson(json);
    } else {
      throw Exception('Failed to load movie details: ${response.reasonPhrase}');
    }
  }

  static Future<List<MoviesModel>> _fetchMoviesFromEndpoint(
      String endpoint) async {
    final url = Uri.parse(endpoint);
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final Map<String, dynamic> json = jsonDecode(response.body);
      final List<dynamic> movies = json['results'];
      return movies.map((movie) => MoviesModel.fromJson(movie)).toList();
    } else {
      throw Exception('Failed to load movies: ${response.reasonPhrase}');
    }
  }
}
