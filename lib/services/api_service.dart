import 'dart:convert';
import 'package:flutter_api_test/models/cast_model.dart';
import 'package:http/http.dart' as http;
import '../models/movie_model.dart';

class ApiService {
  final String _apiKey = 'bb52aa036d9b30deb41e49b38b474fe5';
  final String _baseUrl = 'https://api.themoviedb.org/3';

  Future<List<Movie>> _fetchMovies(String endpoint) async {
    final response = await http.get(
        Uri.parse('$_baseUrl/movie/$endpoint?api_key=$_apiKey&language=en-US'));

    if (response.statusCode == 200) {
      final List moviesData = json.decode(response.body)['results'];
      List<Movie> movies = await Future.wait(moviesData.map((data) async {
        Movie movie = Movie.fromJson(data);
        movie.cast = await _fetchMovieCast(movie.id);
        return movie;
      }).toList());

      return movies;
    } else {
      throw Exception('Failed to load popular movies');
    }
  }

  Future<List<Movie>> fetchPopularMovies() async {
    return await _fetchMovies('popular');
  }

  Future<List<Movie>> fetchTopRatedMovies() async {
    return await _fetchMovies('top_rated');
  }

  Future<List<Movie>> fetchUpcomingMovies() async {
    return await _fetchMovies('upcoming');
  }

  Future<List<Movie>> fetchNowPlayingMovies() async {
    return await _fetchMovies('now_playing');
  }

  Future<List<Movie>> searchMovies(String query) async {
    final response = await http.get(
      Uri.parse('$_baseUrl/search/movie?api_key=$_apiKey&query=$query'),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);

      final List<Movie> movies = await Future.wait(
        (data['results'] as List).map((movieJson) async {
          final movie = Movie.fromJson(movieJson);

          final cast = await _fetchMovieCast(movie.id);

          return Movie(
            id: movie.id,
            title: movie.title,
            overview: movie.overview,
            posterPath: movie.posterPath,
            backdropPath: movie.backdropPath,
            releaseDate: movie.releaseDate,
            rating: movie.rating,
            cast: cast,
          );
        }),
      );
      return movies;
    } else {
      throw Exception('Failed to load movies');
    }
  }

  Future<List<CastModel>> _fetchMovieCast(int movieId) async {
    final response = await http.get(
      Uri.parse('$_baseUrl/movie/$movieId/credits?api_key=$_apiKey'),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return (data['cast'] as List)
          .map((actorJson) => CastModel.fromJson(actorJson))
          .toList();
    } else {
      throw Exception('Failed to load cast: ${response.statusCode}');
    }
  }
}
