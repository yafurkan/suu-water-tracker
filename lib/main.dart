import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'gen_l10n/app_localizations.dart';
import 'screens/water_tracker_screen.dart';
import 'screens/settings_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await AwesomeNotifications().initialize(
    null,
    [
      NotificationChannel(
        channelKey: 'basic_channel',
        channelName: 'Basic Notifications',
        channelDescription: 'Su içme hatırlatıcıları',
        defaultColor: Colors.blue,
        importance: NotificationImportance.High,
        channelShowBadge: true,
      ),
    ],
  );
  runApp(const SuuApp());
}

enum AppThemeMode { system, light, dark }

enum ReminderFrequency {
  off,
  every2h,
  every4h,
  onceNoon,
}

class SuuApp extends StatefulWidget {
  const SuuApp({Key? key}) : super(key: key);

  @override
  State<SuuApp> createState() => _SuuAppState();
}

class _SuuAppState extends State<SuuApp> {
  Locale _selectedLocale = const Locale('tr');
  AppThemeMode _themeMode = AppThemeMode.system;
  ReminderFrequency _reminderFrequency = ReminderFrequency.off;

  void _changeLocale(Locale locale) {
    setState(() {
      _selectedLocale = locale;
    });
  }

  void _changeTheme(AppThemeMode mode) {
    setState(() {
      _themeMode = mode;
    });
  }

  void _changeReminder(ReminderFrequency freq) {
    setState(() {
      _reminderFrequency = freq;
    });
    scheduleReminder(context, freq);
  }

  @override
  Widget build(BuildContext context) {
    ThemeMode themeMode;
    switch (_themeMode) {
      case AppThemeMode.light:
        themeMode = ThemeMode.light;
        break;
      case AppThemeMode.dark:
        themeMode = ThemeMode.dark;
        break;
      default:
        themeMode = ThemeMode.system;
    }

    return MaterialApp(
      title: 'Suu',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      themeMode: themeMode,
      home: Builder(
        builder: (context) => WaterTrackerScreen(
          onSettingsPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => SettingsScreen(
                  currentLocale: _selectedLocale,
                  onLocaleChanged: (locale) {
                    _changeLocale(locale);
                    Navigator.pop(context);
                  },
                  themeMode: _themeMode,
                  onThemeChanged: (mode) {
                    _changeTheme(mode);
                  },
                  reminderFrequency: _reminderFrequency,
                  onReminderChanged: (freq) {
                    _changeReminder(freq);
                    Navigator.pop(context);
                  },
                ),
              ),
            );
          },
        ),
      ),
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('tr'),
        Locale('en'),
      ],
      locale: _selectedLocale,
      localeResolutionCallback: (locale, supportedLocales) {
        for (var supportedLocale in supportedLocales) {
          if (supportedLocale.languageCode == locale?.languageCode) {
            return supportedLocale;
          }
        }
        return supportedLocales.first;
      },
    );
  }
}

Future<void> showDrinkWaterNotification(BuildContext context) async {
  final loc = AppLocalizations.of(context)!;
  await AwesomeNotifications().createNotification(
    content: NotificationContent(
      id: 1,
      channelKey: 'basic_channel',
      title: loc.drinkWaterNotificationTitle,
      body: loc.drinkWaterNotificationBody,
      notificationLayout: NotificationLayout.Default,
    ),
  );
}

Future<void> scheduleReminder(BuildContext context, ReminderFrequency freq) async {
  await AwesomeNotifications().cancelAll();

  final loc = AppLocalizations.of(context)!;

  if (freq == ReminderFrequency.off) return;

  if (freq == ReminderFrequency.every2h) {
    await AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: 1,
        channelKey: 'basic_channel',
        title: loc.drinkWaterNotificationTitle,
        body: loc.drinkWaterNotificationBody,
      ),
      schedule: NotificationInterval(interval: Duration(hours: 2), repeats: true),
    );
  } else if (freq == ReminderFrequency.every4h) {
    await AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: 2,
        channelKey: 'basic_channel',
        title: loc.drinkWaterNotificationTitle,
        body: loc.drinkWaterNotificationBody,
      ),
      schedule: NotificationInterval(interval: Duration(hours: 4), repeats: true),
    );
  } else if (freq == ReminderFrequency.onceNoon) {
    await AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: 3,
        channelKey: 'basic_channel',
        title: loc.drinkWaterNotificationTitle,
        body: loc.drinkWaterNotificationBody,
      ),
      schedule: NotificationCalendar(hour: 12, minute: 0, repeats: true),
    );
  }
}
