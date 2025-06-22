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

  int _caffeineConsumed = 0;
  final int _dailyCaffeineLimit = 400;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _waterConsumed = prefs.getInt('waterConsumed') ?? 0;
      _caffeineConsumed = prefs.getInt('caffeineConsumed') ?? 0;
    });
  }

  Future<void> _saveData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('waterConsumed', _waterConsumed);
    await prefs.setInt('caffeineConsumed', _caffeineConsumed);
  }

  void _addWater() {
    setState(() {
      _waterConsumed += 200;
      if (_waterConsumed > _dailyGoal) _waterConsumed = _dailyGoal;
    });
    _saveData();
  }

  void _addDrink(String type) {
    int addedWater = 0;
    int addedCaffeine = 0;
    if (type == 'coffee') {
      addedWater = 200;
      addedCaffeine = 95;
    } else if (type == 'tea') {
      addedWater = 200;
      addedCaffeine = 47;
    }
    setState(() {
      _waterConsumed += addedWater;
      if (_waterConsumed > _dailyGoal) _waterConsumed = _dailyGoal;
      _caffeineConsumed += addedCaffeine;
      if (_caffeineConsumed > _dailyCaffeineLimit) {
        _caffeineConsumed = _dailyCaffeineLimit;
      }
    });
    _saveData();
    if (_caffeineConsumed >= _dailyCaffeineLimit) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('⚠️ Günlük kafein sınırını aştınız!'),
        ),
      );
    }
  }

  void _showDrinkOptions() {
    showModalBottomSheet<void>(
      context: context,
      builder: (_) => Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          ListTile(
            leading: const Icon(Icons.local_cafe),
            title: const Text('Kahve (200 ml)'),
            onTap: () {
              Navigator.pop(context);
              _addDrink('coffee');
            },
          ),
          ListTile(
            leading: const Icon(Icons.emoji_food_beverage),
            title: const Text('Çay (200 ml)'),
            onTap: () {
              Navigator.pop(context);
              _addDrink('tea');
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final double waterProgress = _waterConsumed / _dailyGoal;
    final double caffeineProgress = _caffeineConsumed / _dailyCaffeineLimit;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Su ve Kafein Takip'),
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
                    value: waterProgress,
                    strokeWidth: 12,
                  ),
                  Text('$_waterConsumed / $_dailyGoal ml'),
                ],
              ),
            ),
            const SizedBox(height: 30),
            const Text(
              'Günlük Kafein Takip',
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
                    value: caffeineProgress,
                    strokeWidth: 12,
                    color: Colors.brown,
                  ),
                  Text('$_caffeineConsumed / $_dailyCaffeineLimit mg'),
                ],
              ),
            ),
            const SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                ElevatedButton(
                  onPressed: _addWater,
                  child: const Text('200 ml Su Ekle'),
                ),
                ElevatedButton(
                  onPressed: _showDrinkOptions,
                  child: const Text('İçecek Ekle'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
