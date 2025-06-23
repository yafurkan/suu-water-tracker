import 'package:flutter/material.dart';
import '../main.dart'; // AppThemeMode için
import '../gen_l10n/app_localizations.dart'; // AppLocalizations için

class SettingsScreen extends StatelessWidget {
  final Locale currentLocale;
  final ValueChanged<Locale> onLocaleChanged;
  final AppThemeMode themeMode;
  final ValueChanged<AppThemeMode> onThemeChanged;
  final ReminderFrequency reminderFrequency;
  final ValueChanged<ReminderFrequency> onReminderChanged;

  const SettingsScreen({
    Key? key,
    required this.currentLocale,
    required this.onLocaleChanged,
    required this.themeMode,
    required this.onThemeChanged,
    required this.reminderFrequency,
    required this.onReminderChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(title: Text(loc.settings)),
      body: ListView(
        children: [
          ListTile(
            title: Text(loc.languageSelection),
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
          ListTile(
            title: Text(loc.theme),
            trailing: DropdownButton<AppThemeMode>(
              value: themeMode,
              items: [
                DropdownMenuItem(
                  value: AppThemeMode.system,
                  child: Text(loc.themeSystem),
                ),
                DropdownMenuItem(
                  value: AppThemeMode.light,
                  child: Text(loc.themeLight),
                ),
                DropdownMenuItem(
                  value: AppThemeMode.dark,
                  child: Text(loc.themeDark),
                ),
              ],
              onChanged: (mode) {
                if (mode != null) {
                  onThemeChanged(mode);
                }
              },
            ),
          ),
          ListTile(
            title: Text(loc.reminderFrequency),
            trailing: DropdownButton<ReminderFrequency>(
              value: reminderFrequency,
              items: [
                DropdownMenuItem(
                  value: ReminderFrequency.off,
                  child: Text(loc.reminderOff),
                ),
                DropdownMenuItem(
                  value: ReminderFrequency.every2h,
                  child: Text(loc.reminderEvery2Hours),
                ),
                DropdownMenuItem(
                  value: ReminderFrequency.every4h,
                  child: Text(loc.reminderEvery4Hours),
                ),
                DropdownMenuItem(
                  value: ReminderFrequency.onceNoon,
                  child: Text(loc.reminderOnceNoon),
                ),
              ],
              onChanged: (freq) {
                if (freq != null) {
                  onReminderChanged(freq);
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}