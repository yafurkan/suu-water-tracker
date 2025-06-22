import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class WaterTrackerScreen extends StatefulWidget {
  const WaterTrackerScreen({Key? key}) : super(key: key);

  @override
  State<WaterTrackerScreen> createState() => _WaterTrackerScreenState();
}

class _WaterTrackerScreenState extends State<WaterTrackerScreen> {
  int _waterConsumed = 0;
  final int _dailyGoal = 2000;

  @override
  void initState() {
    super.initState();
    _loadWaterData();
  }

  // Cihazdan önceki su verisini yükler
  Future<void> _loadWaterData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _waterConsumed = prefs.getInt('waterConsumed') ?? 0;
    });
  }

  // Güncel su verisini cihazda saklar
  Future<void> _saveWaterData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('waterConsumed', _waterConsumed);
  }

  void _addWater() {
    setState(() {
      _waterConsumed += 200;
      if (_waterConsumed > _dailyGoal) _waterConsumed = _dailyGoal;
    });
    _saveWaterData();
  }

  @override
  Widget build(BuildContext context) {
    final double progress = _waterConsumed / _dailyGoal;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Su Takip'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            const SizedBox(height: 20),
            const Text(
              'Günlük Su Hedefi',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            SizedBox(
              height: 200,
              width: 200,
              child: Stack(
                alignment: Alignment.center,
                children: <Widget>[
                  CircularProgressIndicator(
                    value: progress,
                    strokeWidth: 12,
                  ),
                  Text('$_waterConsumed / $_dailyGoal ml'),
                ],
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _addWater,
              child: const Text('200 ml Ekle'),
            ),
          ],
        ),
      ),
    );
  }
}
