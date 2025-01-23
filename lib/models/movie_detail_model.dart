class MovieDetailModel {
  final String title;
  final String overview;
  final String posterPath;
  final String backdropPath;
  final int runtime;
  final double voteAverage;
  final int voteCount;
  final String releaseDate;
  final String tagline;
  final int budget;
  final int revenue;
  final String homepage;
  final List<Genre> genres;
  final bool isAdult; // 성인 영화 여부

  MovieDetailModel.fromJson(Map<String, dynamic> json)
      : title = json['title'],
        overview = json['overview'],
        posterPath = json['poster_path'] ?? '',
        backdropPath = json['backdrop_path'] ?? '',
        runtime = json['runtime'] ?? 0,
        voteAverage = (json['vote_average'] as num).toDouble(),
        voteCount = json['vote_count'],
        releaseDate = json['release_date'] ?? 'Unknown',
        tagline = json['tagline'] ?? '',
        budget = json['budget'] ?? 0,
        revenue = json['revenue'] ?? 0,
        homepage = json['homepage'] ?? '',
        genres = (json['genres'] as List<dynamic>)
            .map((genre) => Genre.fromJson(genre))
            .toList(),
        isAdult = json['adult'] ?? false; // 성인 영화 여부
}

class Genre {
  final int id;
  final String name;

  Genre.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        name = json['name'];
}
