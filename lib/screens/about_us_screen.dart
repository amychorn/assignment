import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../theme/theme_provider.dart';
import '../localization/localization.dart';

class AboutUsScreen extends StatelessWidget {
  const AboutUsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final localizationProvider = Provider.of<LocalizationProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(localizationProvider.getString("about_us")),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            Card(
              elevation: 2,
              margin: const EdgeInsets.symmetric(vertical: 8.0),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      localizationProvider.getString("switch_theme"),
                      style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.w600),
                    ),
                    Switch(
                      value: themeProvider.isDarkMode,
                      onChanged: (value) {
                        themeProvider.toggleTheme();
                      },
                    ),
                  ],
                ),
              ),
            ),
            Card(
              elevation: 2,
              margin: const EdgeInsets.symmetric(vertical: 8.0),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      localizationProvider.getString("change_language"),
                      style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.w600),
                    ),
                    DropdownButton<String>(
                      value: localizationProvider.currentLanguage,
                      items: const [
                        DropdownMenuItem(
                          value: 'en',
                          child: Text(
                            'English',
                            style: TextStyle(color: Colors.purple),
                          ),
                        ),
                        DropdownMenuItem(
                          value: 'km',
                          child: Text(
                            'ខ្មែរ',
                            style: TextStyle(color: Colors.purple),
                          ),
                        ),
                      ],
                      onChanged: (String? newLanguage) {
                        if (newLanguage != null) {
                          localizationProvider.setLanguage(newLanguage);
                        }
                      },
                      underline: Container(),
                      style: TextStyle(
                        color: Theme.of(context).primaryColor,
                      ),
                      icon: const Icon(Icons.arrow_drop_down),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
