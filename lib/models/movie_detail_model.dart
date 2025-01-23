class MovieDetailModel {
  final String homepage;
  final String title;
  final int runtime;
  final String overview;
  final String backdrop;
  final double voteAverage;
  final List<String> genres;

  MovieDetailModel.fromJson(Map<String, dynamic> json)
      : homepage = json['homepage'],
        title = json['title'],
        overview = json['overview'],
        runtime = json['runtime'],
        voteAverage = (json['vote_average'] as num).toDouble(),
        backdrop = json['backdrop_path'],
        genres = (json['genres'] as List<dynamic>)
            .map((genre) => genre['name'] as String)
            .toList();
}
