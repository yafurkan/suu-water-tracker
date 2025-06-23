// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Suu';

  @override
  String get waterTracker => 'Water Tracker';

  @override
  String get dailyGoal => 'Daily Water Goal';

  @override
  String get addWater => 'Add 200 ml Water';

  @override
  String get addDrink => 'Add Drink';

  @override
  String get statistics => 'Statistics';

  @override
  String get profile => 'Profile';

  @override
  String get reset => 'Reset Daily Data';

  @override
  String get coffee => 'Coffee (200 ml)';

  @override
  String get tea => 'Tea (200 ml)';

  @override
  String get caffeineLimitWarning =>
      '⚠️ You have exceeded your daily caffeine limit!';

  @override
  String get addDrinkButton => 'Add Drink';

  @override
  String get dailyCaffeine => 'Daily Caffeine Tracker';

  @override
  String get settings => 'Settings';

  @override
  String get languageSelection => 'Language Selection';

  @override
  String get age => 'Age';

  @override
  String get weight => 'Weight';

  @override
  String get gender => 'Gender';

  @override
  String get theme => 'Theme';

  @override
  String get themeSystem => 'System Default';

  @override
  String get themeLight => 'Light';

  @override
  String get themeDark => 'Dark';

  @override
  String get drinkWaterNotificationTitle => 'Time to drink water!';

  @override
  String get drinkWaterNotificationBody => 'Stay hydrated for your health.';

  @override
  String get reminder => 'Reminder';

  @override
  String get reminderFrequency => 'Reminder Frequency';

  @override
  String get reminderOff => 'Off';

  @override
  String get reminderEvery2Hours => 'Every 2 hours';

  @override
  String get reminderEvery4Hours => 'Every 4 hours';

  @override
  String get reminderOnceNoon => 'Once at noon';
}
