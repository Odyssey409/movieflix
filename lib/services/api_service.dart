// import 'dart:convert';
// import 'package:http/http.dart' as http;
// import 'package:movieflix/models/movies_model.dart';


// class ApiService {
//   static const String baseUrl =
//       "https://movies-api.nomadcoders.workers.dev";


//   static Future<List<MoviesModel>> fetchWebtoonsToday() async {
//     List<MoviesModel> moviesInstances = [];
//     final url = Uri.parse('$baseUrl/');
//     final response = await http.get(url);

//     if (response.statusCode == 200) {
//       final List<dynamic> movies = jsonDecode(response.body);
//       for (var movie in movies) {
//         moviesInstances.add(MoviesModel.fromJson(movie));
//       }
//       return moviesInstances;
//     } else {
//       throw Error();
//     }
//   }

// //   static Future<WebtoonDetailModel> getToonById(String id) async {
// //     final url = Uri.parse('$baseUrl/$id');
// //     final response = await http.get(url);
// //     if (response.statusCode == 200) {
// //       final webtoon = jsonDecode(response.body);
// //       return WebtoonDetailModel.fromJson(webtoon);
// //     } else {
// //       throw Error();
// //     }
// //   }

// //   static Future<List<WebtoonEpisodeModel>> getLatestEpisodesById(
// //       String id) async {
// //     List<WebtoonEpisodeModel> episodesInstances = [];
// //     final url = Uri.parse('$baseUrl/$id/episodes');
// //     final response = await http.get(url);
// //     if (response.statusCode == 200) {
// //       final episodes = jsonDecode(response.body);
// //       for (var episode in episodes) {
// //         episodesInstances.add(WebtoonEpisodeModel.fromJson(episode));
// //       }
// //       return episodesInstances;
// //     } else {
// //       throw Error();
// //     }
// //   }
// // }
