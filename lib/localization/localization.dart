import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocalizationProvider extends ChangeNotifier {
  String _currentLanguage = 'en';
  String get currentLanguage => _currentLanguage;

  LocalizationProvider() {
    _loadLanguage();
  }

  final Map<String, Map<String, String>> _localizedStrings = {
    'en': {
      'home': 'Home',
      'details': 'Details',
      'search': 'Search',
      'about_us': 'About Us',
      'switch_theme': 'Switch Theme',
      'change_language': 'Change Language',
      'popular_movies': 'Popular Movies',
      'top_rated_movies': 'Top Rated Movies',
      'upcoming_movies': 'Upcoming Movies',
      'now_playing': 'Now Playing',
      'search_for_movies': 'Search for movies'
    },
    'km': {
      'home': 'ទំព័រដើម',
      'details': 'ព័ត៌មានលម្អិត',
      'search': 'ស្វែងរក',
      'about_us': 'អំពីយើង',
      'switch_theme': 'ប្តូរទឹកភ្លើង',
      'change_language': 'ប្តូរភាសា',
      'popular_movies': 'ភាពយន្តពេញនិយម',
      'top_rated_movies': 'ភាពយន្តដែលបានវាយតម្លៃកំពូល',
      'upcoming_movies': 'ភាពយន្តដែលកំពុងមកដល់',
      'now_playing': 'កំពុងបង្ហាញឥឡូវនេះ',
      'search_for_movies': 'ស្វែងរកភាពយន្ត'
    },
  };

  Future<void> _loadLanguage() async {
    final prefs = await SharedPreferences.getInstance();
    _currentLanguage = prefs.getString('currentLanguage') ?? 'en';
    notifyListeners();
  }

  // Function to get localized strings
  String getString(String key) {
    return _localizedStrings[_currentLanguage]?[key] ?? key;
  }

  // Function to change the language
  Future<void> setLanguage(String language) async {
    _currentLanguage = language;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('currentLanguage', language);
    notifyListeners();
  }
}
