import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/api_service.dart';
import '../models/movie_model.dart';
import '../localization/localization.dart';
import 'detail_screen.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final ApiService _apiService = ApiService();
  List<Movie> _searchResults = [];
  String _query = '';
  bool _isLoading = false;
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
    _controller.addListener(_onSearchChanged);
  }

  void _onSearchChanged() {
    final query = _controller.text;

    if (query.isNotEmpty) {
      setState(() {
        _isLoading = true;
        _query = query;
      });

      // debounce logic
      Future.delayed(const Duration(milliseconds: 500), () {
        if (_controller.text == query) {
          _searchMovies(query);
        }
      });
    } else {
      setState(() {
        _searchResults.clear();
      });
    }
  }

  Future<void> _searchMovies(String query) async {
    try {
      final results = await _apiService.searchMovies(query);
      setState(() {
        _searchResults = results;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error searching for movies')),
      );
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final localizationProvider = Provider.of<LocalizationProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(localizationProvider.getString('search')),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            TextField(
              controller: _controller,
              decoration: InputDecoration(
                labelText: localizationProvider.getString('search_for_movies'),
                border: const OutlineInputBorder(),
                suffixIcon: _controller.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _controller.clear();
                        },
                      )
                    : null,
              ),
            ),
            const SizedBox(height: 8.0),
            _isLoading
                ? const CircularProgressIndicator()
                : Expanded(
                    child: ListView.builder(
                    itemCount: _searchResults.length,
                    itemBuilder: (context, index) {
                      final movie = _searchResults[index];
                      return ListTile(
                        leading: movie.posterPath.isNotEmpty
                            ? Hero(
                                tag: 'movie-${movie.id}',
                                child: CachedNetworkImage(
                                  imageUrl:
                                      'https://image.tmdb.org/t/p/w92${movie.posterPath}',
                                  fit: BoxFit.cover,
                                  width: 35,
                                  height: 138,
                                  placeholder: (context, url) => const SizedBox(
                                    width: 35,
                                    height: 138,
                                    child: Center(),
                                  ),
                                  errorWidget: (context, url, error) =>
                                      Container(
                                    width: 35,
                                    height: 138,
                                    color: Colors.grey,
                                    child: const Icon(Icons.error),
                                  ),
                                ),
                              )
                            : Container(
                                width: 35,
                                height: 138,
                                color: Colors.grey,
                              ),
                        title: Text(movie.title),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(movie.releaseYear),
                            Text(movie.cast != null && movie.cast!.isNotEmpty
                                ? movie.cast!
                                    .take(2)
                                    .map((cast) => cast.name)
                                    .join(', ')
                                : 'No cast available'),
                          ],
                        ),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => DetailScreen(movie: movie),
                            ),
                          );
                        },
                      );
                    },
                  )),
          ],
        ),
      ),
    );
  }
}
