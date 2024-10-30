import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import '../models/movie_model.dart';

class DetailScreen extends StatelessWidget {
  final Movie movie;
  final String? category;

  const DetailScreen({super.key, required this.movie, this.category});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(movie.title),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Stack(
              children: [
                movie.backdropPath.isNotEmpty
                    ? Stack(
                        children: [
                          CachedNetworkImage(
                            imageUrl:
                                'https://image.tmdb.org/t/p/w500${movie.backdropPath}',
                            height: 250,
                            width: double.infinity,
                            fit: BoxFit.cover,
                          ),
                          Container(
                            height: 250,
                            width: double.infinity,
                            color: Colors.black.withOpacity(0.4),
                          ),
                        ],
                      )
                    : Container(
                        height: 250,
                        color: Colors.grey,
                      ),
                Positioned(
                  bottom: 20,
                  left: 16,
                  child: Row(
                    children: [
                      movie.posterPath.isNotEmpty
                          ? Hero(
                              tag: category != null && category!.isNotEmpty
                                  ? 'movie-${movie.id}-$category'
                                  : 'movie-${movie.id}',
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
                            )
                          : Container(
                              width: 100,
                              height: 150,
                              color: Colors.grey,
                            ),
                      const SizedBox(width: 16),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            width: 250,
                            child: Text(
                              movie.title,
                              maxLines: 2,
                              overflow: TextOverflow.visible,
                              style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          Text(
                            'Release Date: ${movie.releaseDate}',
                            style: const TextStyle(color: Colors.white),
                          ),
                          Text(
                            'Rating: ${movie.rating.toStringAsFixed(1)}',
                            style: const TextStyle(color: Colors.white),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Overview',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8.0),
                  Text(movie.overview),
                  const SizedBox(height: 16.0),
                  const Text(
                    'Cast',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8.0),
                  if (movie.cast != null && movie.cast!.isNotEmpty)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: movie.cast!.map((actor) {
                        return Column(
                          children: [
                            Row(
                              children: [
                                actor.profilePath != null &&
                                        actor.profilePath!.isNotEmpty
                                    ? CircleAvatar(
                                        radius: 20,
                                        backgroundImage:
                                            CachedNetworkImageProvider(
                                          'https://image.tmdb.org/t/p/w500${actor.profilePath}',
                                        ),
                                      )
                                    : const CircleAvatar(
                                        radius: 20,
                                        backgroundImage:
                                            CachedNetworkImageProvider(
                                          'https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_1280.png',
                                        ),
                                      ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(actor.name),
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),
                          ],
                        );
                      }).toList(),
                    )
                  else
                    const Text('N/A')
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
