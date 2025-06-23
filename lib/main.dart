import 'package:flutter/material.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'screens/water_tracker_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 🔔 Awesome Notifications başlatma
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
    debug: true,
  );

  // 📲 İzin iste
  if (!await AwesomeNotifications().isNotificationAllowed()) {
    await AwesomeNotifications().requestPermissionToSendNotifications();
  }

  // ⏰ Saatlik periyodik bildirim planla
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

class SuuApp extends StatelessWidget {
  const SuuApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Suu',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const WaterTrackerScreen(),
    );
  }
}
