import 'package:flutter_api_test/models/cast_model.dart';

class Movie {
  final int id;
  final String title;
  final String overview;
  final String posterPath;
  final String backdropPath;
  final String? releaseDate;
  final double rating;
  List<CastModel>? cast;

  Movie({
    required this.id,
    required this.title,
    required this.overview,
    required this.posterPath,
    required this.backdropPath,
    this.releaseDate,
    required this.rating,
    this.cast,
  });

  factory Movie.fromJson(Map<String, dynamic> json) {
    return Movie(
      id: json['id'],
      title: json['title'],
      overview: json['overview'],
      posterPath: json['poster_path'] ?? '',
      backdropPath: json['backdrop_path'] ?? '',
      releaseDate: json['release_date'],
      rating: (json['vote_average'] as num?)?.toDouble() ??
          0.0, // Handle the rating field
      cast: json['credits'] != null && json['credits']['cast'] != null
          ? (json['credits']['cast'] as List)
              .map((item) => CastModel.fromJson(item))
              .toList()
          : null,
    );
  }

// extract only the year
  String get releaseYear {
    if (releaseDate != null) {
      return releaseDate!.split('-')[0];
    }
    return 'Unknown';
  }
}
