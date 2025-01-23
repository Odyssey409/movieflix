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
        title: Text('MovieFlix'),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SectionTitle(title: 'Popular Movies'),
            MoviesSection(future: popularMovies),
            SectionTitle(title: 'Now Playing'),
            MoviesSection(future: nowPlayingMovies),
            SectionTitle(title: 'Coming Soon'),
            MoviesSection(future: comingSoonMovies),
          ],
        ),
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
      padding: const EdgeInsets.all(8.0),
      child: Text(
        title,
        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
    );
  }
}

class MoviesSection extends StatelessWidget {
  final Future<List<MoviesModel>> future;
  const MoviesSection({super.key, required this.future});

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
              return MovieCard(movie: movie);
            },
          ),
        );
      },
    );
  }
}

class MovieCard extends StatelessWidget {
  final MoviesModel movie;
  const MovieCard({super.key, required this.movie});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => MovieDetailScreen(movieId: movie.id),
          ),
        );
      },
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Image.network(
              'https://image.tmdb.org/t/p/w500${movie.poster}',
              height: 150,
              fit: BoxFit.cover,
            ),
            SizedBox(height: 8),
            Text(
              movie.title,
              style: TextStyle(fontSize: 14),
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
