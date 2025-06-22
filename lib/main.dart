import 'package:flutter/material.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'screens/water_tracker_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 🔔 Awesome Notifications başlatma (ikon=null olarak ayarlandı)
  await AwesomeNotifications().initialize(
    null, // artık null
    [
      NotificationChannel(
        channelKey: 'hourly_reminder',
        channelName: 'Saatlik Hatırlatmalar',
        channelDescription: 'Her saat başı su içmeyi unutma! 💧',
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

  // 🔔 Test bildirimi: uygulama açılır açılmaz bu mesaj gelsin
  await AwesomeNotifications().createNotification(
    content: NotificationContent(
      id: 999,
      channelKey: 'hourly_reminder',
      title: '🎉 Test Bildirimi',
      body: 'Awesome Notifications çalışıyor! 💧',
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
