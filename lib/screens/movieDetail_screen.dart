import 'package:flutter/material.dart';
import 'package:movieflix/models/movie_detail_model.dart';
import 'package:movieflix/services/api_service.dart';
import 'package:url_launcher/url_launcher.dart'; // url_launcher 추가

class MovieDetailScreen extends StatelessWidget {
  final String movieId;
  const MovieDetailScreen({super.key, required this.movieId});

  // URL을 열기 위한 함수
  void _launchUrl(BuildContext context, String url) async {
    final Uri uri = Uri.parse(url);

    // URL 유효성 검사 및 실행
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Could not open the URL')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Movie Details'),
        leading: BackButton(onPressed: () => Navigator.pop(context)),
      ),
      body: FutureBuilder<MovieDetailModel>(
        future: ApiService.getMovieById(movieId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData) {
            return Center(child: Text('No details available.'));
          }

          final movie = snapshot.data!;
          return SingleChildScrollView(
            child: Stack(
              children: [
                // 배경 이미지
                Image.network(
                  'https://image.tmdb.org/t/p/w500${movie.backdropPath}',
                  width: double.infinity,
                  height: 300,
                  fit: BoxFit.cover,
                ),
                // 상세 정보
                Container(
                  margin: EdgeInsets.only(top: 250),
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius:
                        BorderRadius.vertical(top: Radius.circular(20)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // 제목과 등급
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              movie.title,
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.symmetric(
                                vertical: 4, horizontal: 8),
                            decoration: BoxDecoration(
                              color: movie.isAdult ? Colors.red : Colors.green,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              movie.isAdult ? '18+' : 'All Ages',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 8),
                      // 태그라인
                      if (movie.tagline.isNotEmpty)
                        Text(
                          movie.tagline,
                          style: TextStyle(
                              fontStyle: FontStyle.italic, color: Colors.grey),
                        ),
                      SizedBox(height: 16),
                      // 장르
                      Wrap(
                        spacing: 8,
                        children: movie.genres
                            .map((genre) => Chip(label: Text(genre.name)))
                            .toList(),
                      ),
                      SizedBox(height: 16),
                      // 줄거리
                      Text(
                        'Storyline',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 8),
                      Text(movie.overview),
                      SizedBox(height: 16),
                      // 상영 시간
                      Text(
                        'Duration: ${movie.runtime} minutes',
                        style: TextStyle(fontSize: 16),
                      ),
                      SizedBox(height: 16),
                      // Buy Ticket 버튼
                      Center(
                        child: ElevatedButton(
                          onPressed: () {
                            if (movie.homepage.isNotEmpty) {
                              _launchUrl(context, movie.homepage); // URL 열기
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                    content: Text(
                                        'No homepage available for this movie')),
                              );
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.amber,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                            padding: EdgeInsets.symmetric(
                                horizontal: 32, vertical: 16),
                          ),
                          child: Text('Buy ticket'),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
