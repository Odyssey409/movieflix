import 'package:flutter/material.dart';
import 'package:movieflix/screens/movieDetail_screen.dart';
import 'package:movieflix/services/api_service.dart';
import 'package:movieflix/models/movies_model.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});

  final Future<List<MoviesModel>> popularMovies =
      ApiService.fetchPopularMovies();
  final Future<List<MoviesModel>> nowPlayingMovies =
      ApiService.fetchNowPlayingMovies();
  final Future<List<MoviesModel>> comingSoonMovies =
      ApiService.fetchComingSoonMovies();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'MovieFlix',
          style: TextStyle(
            color: Colors.red.shade900,
            fontFamily: "BebasNeue",
            fontSize: 50,
            letterSpacing: 6,
          ),
        ),
        backgroundColor: Colors.black.withAlpha(245),
      ),
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.black.withAlpha(245),
                  Colors.red.shade900,
                ],
                stops: [
                  0.6,
                  1.0,
                ],
              ),
            ),
          ),
          SingleChildScrollView(
            child: SafeArea(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SectionTitle(title: 'Popular Movies'),
                  PopularMoviesSection(future: popularMovies),
                  SizedBox(height: 12),
                  SectionTitle(title: 'Now in Cinemas'),
                  NowPlayingMoviesSection(future: nowPlayingMovies),
                  SizedBox(height: 12),
                  SectionTitle(title: 'Coming Soon'),
                  ComingSoonMoviesSection(future: comingSoonMovies),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class SectionTitle extends StatelessWidget {
  final String title;
  const SectionTitle({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 16.0,
        vertical: 8.0,
      ),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 21,
          fontWeight: FontWeight.w800,
          color: Colors.white,
        ),
      ),
    );
  }
}

// Popular Movies Section
class PopularMoviesSection extends StatelessWidget {
  final Future<List<MoviesModel>> future;
  const PopularMoviesSection({super.key, required this.future});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<MoviesModel>>(
      future: future,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(child: Text('No movies available.'));
        }

        final movies = snapshot.data!;
        return SizedBox(
          height: 200,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: movies.length,
            itemBuilder: (context, index) {
              final movie = movies[index];
              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          MovieDetailScreen(movieId: movie.id),
                    ),
                  );
                },
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(14),
                    child: Image.network(
                      'https://image.tmdb.org/t/p/w500${movie.poster}',
                      width: 280,
                      fit: BoxFit.fill,
                    ),
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}

// Now Playing Section
class NowPlayingMoviesSection extends StatelessWidget {
  final Future<List<MoviesModel>> future;
  const NowPlayingMoviesSection({super.key, required this.future});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<MoviesModel>>(
      future: future,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(child: Text('No movies available.'));
        }

        final movies = snapshot.data!;
        return SizedBox(
          height: 220,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: movies.length,
            itemBuilder: (context, index) {
              final movie = movies[index];
              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          MovieDetailScreen(movieId: movie.id),
                    ),
                  );
                },
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.network(
                          'https://image.tmdb.org/t/p/w500${movie.poster}',
                          height: 150,
                          width: 140,
                          fit: BoxFit.cover,
                        ),
                      ),
                      SizedBox(height: 8),
                      SizedBox(
                        width: 120,
                        child: Text(
                          movie.title,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                          textAlign: TextAlign.start,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}

// Coming Soon Section
class ComingSoonMoviesSection extends StatelessWidget {
  final Future<List<MoviesModel>> future;
  const ComingSoonMoviesSection({super.key, required this.future});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<MoviesModel>>(
      future: future,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(child: Text('No movies available.'));
        }

        final movies = snapshot.data!;
        return SizedBox(
          height: 220,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: movies.length,
            itemBuilder: (context, index) {
              final movie = movies[index];
              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          MovieDetailScreen(movieId: movie.id),
                    ),
                  );
                },
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.network(
                          'https://image.tmdb.org/t/p/w500${movie.poster}',
                          height: 180,
                          width: 130,
                          fit: BoxFit.cover,
                        ),
                      ),
                      SizedBox(height: 8),
                      SizedBox(
                        width: 100,
                        child: Text(
                          movie.title,
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                          textAlign: TextAlign.start,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}
