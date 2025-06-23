import 'package:flutter/material.dart';

class SettingsScreen extends StatelessWidget {
  final Locale currentLocale;
  final ValueChanged<Locale> onLocaleChanged;

  const SettingsScreen({
    Key? key,
    required this.currentLocale,
    required this.onLocaleChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Ayarlar')),
      body: ListView(
        children: [
          ListTile(
            title: const Text('Dil Seçimi'),
            trailing: DropdownButton<Locale>(
              value: currentLocale,
              items: const [
                DropdownMenuItem(
                  value: Locale('tr'),
                  child: Text('Türkçe'),
                ),
                DropdownMenuItem(
                  value: Locale('en'),
                  child: Text('English'),
                ),
              ],
              onChanged: (locale) {
                if (locale != null) {
                  onLocaleChanged(locale);
                }
              },
            ),
          ),
          // Buraya ileride tema/giriş ayarları ekleyebilirsin
        ],
      ),
    );
  }
}