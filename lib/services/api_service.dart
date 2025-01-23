import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:movieflix/models/movie_detail_model.dart';
import 'package:movieflix/models/movies_model.dart';

class ApiService {
  static const String baseUrl = "https://movies-api.nomadcoders.workers.dev";

  static Future<List<MoviesModel>> fetchWebtoonsToday() async {
    List<MoviesModel> moviesInstances = [];
    final url = Uri.parse('$baseUrl/');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final List<dynamic> movies = jsonDecode(response.body);
      for (var movie in movies) {
        moviesInstances.add(MoviesModel.fromJson(movie));
      }
      return moviesInstances;
    } else {
      throw Error();
    }
  }

  static Future<MovieDetailModel> getMovieById(String id) async {
    final url = Uri.parse('$baseUrl/movie?id=$id');
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final movie = jsonDecode(response.body);
      return MovieDetailModel.fromJson(movie);
    } else {
      throw Error();
    }
  }
}
