import 'package:flutter/material.dart';
import 'screens/water_tracker_screen.dart';

void main() {
  runApp(const SuuApp());
}

class SuuApp extends StatelessWidget {
  const SuuApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Suu',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const WaterTrackerScreen(),
    );
  }
}
