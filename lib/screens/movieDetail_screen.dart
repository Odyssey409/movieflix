import 'package:flutter/material.dart';
import 'package:movieflix/models/movie_detail_model.dart';
import 'package:movieflix/services/api_service.dart';
import 'package:url_launcher/url_launcher.dart';

class MovieDetailScreen extends StatelessWidget {
  final String movieId;
  const MovieDetailScreen({super.key, required this.movieId});

  void _launchUrl(BuildContext context, String url) async {
    final Uri uri = Uri.parse(url);

    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Could not open the URL')),
      );
    }
  }

  String formatRuntime(int runtime) {
    if (runtime < 60) {
      return '${runtime}m';
    } else {
      final hours = runtime ~/ 60;
      final minutes = runtime % 60;
      return minutes > 0 ? '${hours}h ${minutes}m' : '${hours}h';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
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
          return Stack(
            children: [
              // 포스터 이미지 배경
              Positioned.fill(
                child: Image.network(
                  'https://image.tmdb.org/t/p/w500${movie.posterPath}',
                  fit: BoxFit.cover,
                ),
              ),
              // 어두운 그라디언트 오버레이
              Positioned.fill(
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,
                        Colors.black.withAlpha(255),
                      ],
                      stops: [
                        0.2,
                        1,
                      ],
                    ),
                  ),
                ),
              ),
              // 상단 Back 버튼
              SafeArea(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16.0, vertical: 8.0),
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: Row(
                          children: [
                            Icon(Icons.arrow_back_ios_new,
                                color: Colors.white, size: 20),
                            SizedBox(width: 8),
                            Text(
                              'Back to list',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              // 영화 상세 정보 창 (하단 중앙 정렬)
              Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.transparent, // 약간 투명한 검정 배경
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(24),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // 제목
                      Text(
                        movie.title,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 30,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      SizedBox(height: 12),
                      // 별점과 장르
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: List.generate(5, (index) {
                                  double starRating = movie.voteAverage / 2;
                                  return Icon(
                                    index < starRating
                                        ? Icons.star
                                        : (index < starRating + 0.5
                                            ? Icons.star_half
                                            : Icons.star_border),
                                    color: Colors.amber,
                                    size: 20,
                                  );
                                }),
                              ),
                              SizedBox(height: 20),
                              Wrap(
                                spacing: 4, // 단어 간 가로 간격
                                runSpacing: 4, // 줄 간 간격
                                children: [
                                  Text(
                                    '${formatRuntime(movie.runtime)} |', // 런타임 포맷팅 적용
                                    style: TextStyle(
                                      color: Colors.white.withAlpha(220),
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  ...movie.genres.map(
                                    (g) => Text(
                                      g.name,
                                      style: TextStyle(
                                        color: Colors.white.withAlpha(220),
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                      SizedBox(height: 40),
                      // Storyline 제목
                      Text(
                        'Storyline',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 26,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      SizedBox(height: 12),
                      // Storyline 내용
                      Text(
                        movie.overview,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          height: 1.5,
                        ),
                      ),
                      SizedBox(
                        height: 60,
                      ),
                      // Buy Ticket 버튼
                      Center(
                        child: ElevatedButton(
                          onPressed: () {
                            if (movie.homepage.isNotEmpty) {
                              _launchUrl(context, movie.homepage);
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                      'No homepage available for this movie'),
                                ),
                              );
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.amber, // 꽉 찬 버튼 배경색
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15), // 둥근 모서리
                            ),
                            padding: EdgeInsets.symmetric(
                              horizontal: 80,
                              vertical: 16,
                            ), // 버튼 크기
                            elevation: 5, // 그림자 효과 추가
                          ),
                          child: Text(
                            'Go Homepage',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.black, // 텍스트 색상
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 22),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
