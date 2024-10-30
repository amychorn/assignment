import 'package:flutter/material.dart';
import 'package:flutter_api_test/localization/localization.dart';
import 'package:provider/provider.dart';
import 'api_screen.dart';
import 'search_screen.dart';
import 'about_us_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    final localizationProvider = Provider.of<LocalizationProvider>(context);
    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: const [
          ApiScreen(),
          SearchScreen(),
          AboutUsScreen(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: [
          BottomNavigationBarItem(
            icon: const Icon(Icons.home),
            label: localizationProvider.getString('home'),
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.search),
            label: localizationProvider.getString('search'),
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.info),
            label: localizationProvider.getString('about_us'),
          ),
        ],
      ),
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }
}
