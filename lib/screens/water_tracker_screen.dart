import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_profile.dart';
import '../utils/profile_storage.dart';

class WaterTrackerScreen extends StatefulWidget {
  const WaterTrackerScreen({Key? key}) : super(key: key);

  @override
  State<WaterTrackerScreen> createState() => _WaterTrackerScreenState();
}

class _WaterTrackerScreenState extends State<WaterTrackerScreen> {
  int _waterConsumed = 0;
  int _dailyGoal = 2000;
  UserProfile? _userProfile;

  @override
  void initState() {
    super.initState();
    _loadUserProfileAndWaterData();
  }

  Future<void> _loadUserProfileAndWaterData() async {
    final prefs = await SharedPreferences.getInstance();
    final age = prefs.getInt('age') ?? 0;
    final weight = prefs.getDouble('weight') ?? 0.0;
    final gender = prefs.getString('gender') ?? 'male';

    double dailyGoal = 2000;
    if (weight > 0) {
      dailyGoal = gender == 'male' ? weight * 35 : weight * 31;
    }

    print('OKUNDU: age=$age, weight=$weight, gender=$gender, dailyGoal=$dailyGoal');

    setState(() {
      _dailyGoal = dailyGoal.round();
      _waterConsumed = prefs.getInt('waterConsumed') ?? 0;
    });
  }

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

  void _openProfileScreen() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ProfileScreen()),
    );
    if (result == true) {
      _loadUserProfileAndWaterData();
    }
  }

  @override
  Widget build(BuildContext context) {
    final double progress = _waterConsumed / _dailyGoal;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Su Takip'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.person),
            onPressed: _openProfileScreen,
          )
        ],
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
