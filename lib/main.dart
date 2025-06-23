import 'package:flutter/material.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
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
        channelKey: 'hourly_reminder',
        channelName: 'Saatlik Hatırlatmalar',
        channelDescription: 'Her saat başı su içmeyi hatırlatır',
        importance: NotificationImportance.Max,
        channelShowBadge: true,
      ),
    ],
  );

  if (!await AwesomeNotifications().isNotificationAllowed()) {
    await AwesomeNotifications().requestPermissionToSendNotifications();
  }

  await AwesomeNotifications().createNotification(
    content: NotificationContent(
      id: 1,
      channelKey: 'hourly_reminder',
      title: 'Suu Hatırlatma',
      body: 'Şimdi 1 bardak su içmeyi unutma! 💧',
    ),
    schedule: NotificationInterval(
      interval: const Duration(minutes: 60),
      timeZone: await AwesomeNotifications().getLocalTimeZoneIdentifier(),
      repeats: true,
    ),
  );

  runApp(const SuuApp());
}

class SuuApp extends StatefulWidget {
  const SuuApp({Key? key}) : super(key: key);

  @override
  State<SuuApp> createState() => _SuuAppState();
}

class _SuuAppState extends State<SuuApp> {
  Locale _selectedLocale = const Locale('tr');

  void _changeLocale(Locale locale) {
    setState(() {
      _selectedLocale = locale;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Suu',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.blue),
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
