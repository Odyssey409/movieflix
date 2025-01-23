class MoviesModel {
  final String id; // String으로 정의
  final String title;
  final String poster;

  MoviesModel.fromJson(Map<String, dynamic> json)
      : id = json['id'].toString(), // int를 String으로 변환
        title = json['title'],
        poster = json['poster_path'] ?? '';
}
