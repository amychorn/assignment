import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_api_test/localization/localization.dart';
import 'package:provider/provider.dart';
import '../services/api_service.dart';
import '../models/movie_model.dart';
import 'detail_screen.dart';

class ApiScreen extends StatefulWidget {
  const ApiScreen({super.key});

  @override
  State<ApiScreen> createState() => _ApiScreenState();
}

class _ApiScreenState extends State<ApiScreen> {
  final ApiService apiService = ApiService();

  late Future<List<Movie>> popularMovies;
  late Future<List<Movie>> topRatedMovies;
  late Future<List<Movie>> upcomingMovies;
  late Future<List<Movie>> nowPlayingMovies;

  @override
  void initState() {
    super.initState();
    popularMovies = apiService.fetchPopularMovies();
    topRatedMovies = apiService.fetchTopRatedMovies();
    upcomingMovies = apiService.fetchUpcomingMovies();
    nowPlayingMovies = apiService.fetchNowPlayingMovies();
  }

  Widget buildMovieList(Future<List<Movie>> moviesFuture, String title) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
          child: Text(
            title,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
        FutureBuilder<List<Movie>>(
          future: moviesFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else {
              final movies = snapshot.data!;

              return SizedBox(
                height: 200,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: movies.length,
                  itemBuilder: (context, index) {
                    final movie = movies[index];

                    return GestureDetector(
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              DetailScreen(movie: movie, category: title),
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Column(
                          children: [
                            Hero(
                              tag: 'movie-${movie.id}-$title',
                              child: Container(
                                width: 120,
                                height: 160,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8.0),
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(8.0),
                                  child: CachedNetworkImage(
                                    imageUrl:
                                        'https://image.tmdb.org/t/p/w500${movie.posterPath}',
                                    fit: BoxFit.cover,
                                    placeholder: (context, url) => const Center(
                                        child:
                                            CircularProgressIndicator()), // Loading indicator
                                    errorWidget: (context, url, error) =>
                                        const Icon(
                                            Icons.error), // Error handling
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 8),
                            SizedBox(
                              width: 120,
                              child: Text(
                                movie.title,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(fontSize: 14),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              );
            }
          },
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final localizationProvider = Provider.of<LocalizationProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(localizationProvider.getString("home")),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            buildMovieList(popularMovies,
                localizationProvider.getString("popular_movies")),
            buildMovieList(topRatedMovies,
                localizationProvider.getString("top_rated_movies")),
            buildMovieList(upcomingMovies,
                localizationProvider.getString("upcoming_movies")),
            buildMovieList(nowPlayingMovies,
                localizationProvider.getString("now_playing")),
          ],
        ),
      ),
    );
  }
}
