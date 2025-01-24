class MoviesModel {
  final String id;
  final String title;
  final String poster;

  MoviesModel.fromJson(Map<String, dynamic> json)
      : id = json['id'].toString(),
        title = json['title'],
        poster = json['poster_path'] ?? '';
}
