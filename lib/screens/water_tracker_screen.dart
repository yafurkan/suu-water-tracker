import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'profile_screen.dart';
import 'statistics_screen.dart';

class WaterTrackerScreen extends StatefulWidget {
  const WaterTrackerScreen({Key? key}) : super(key: key);

  @override
  State<WaterTrackerScreen> createState() => _WaterTrackerScreenState();
}

class _WaterTrackerScreenState extends State<WaterTrackerScreen> {
  int _waterConsumed = 0;
  int _dailyGoal = 2000;               // artık dinamik
  int _caffeineConsumed = 0;
  final int _dailyCaffeineLimit = 400;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final prefs = await SharedPreferences.getInstance();
    final weight = prefs.getDouble('weight') ?? 60.0; // default 60kg
    setState(() {
      _waterConsumed = prefs.getInt('waterConsumed') ?? 0;
      _caffeineConsumed = prefs.getInt('caffeineConsumed') ?? 0;
      // Formül: 0.035 × kilo(kg) × 1000 = ml
      _dailyGoal = (0.035 * weight * 1000).toInt();
    });
  }

  Future<void> _saveData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('waterConsumed', _waterConsumed);
    await prefs.setInt('caffeineConsumed', _caffeineConsumed);
  }

  void _addWater() {
    setState(() {
      _waterConsumed = (_waterConsumed + 200).clamp(0, _dailyGoal);
    });
    _saveData();
  }

  void _addDrink(String type) {
    int addedWater = 0, addedCaffeine = 0;
    if (type == 'coffee') {
      addedWater = 200;
      addedCaffeine = 95;
    } else if (type == 'tea') {
      addedWater = 200;
      addedCaffeine = 47;
    }
    setState(() {
      _waterConsumed = (_waterConsumed + addedWater).clamp(0, _dailyGoal);
      _caffeineConsumed = (_caffeineConsumed + addedCaffeine).clamp(0, _dailyCaffeineLimit);
    });
    _saveData();
    if (_caffeineConsumed >= _dailyCaffeineLimit) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('⚠️ Günlük kafein sınırını aştınız!')),
      );
    }
  }

  void _showDrinkOptions() {
    showModalBottomSheet(
      context: context,
      builder: (_) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
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
    final waterProgress = _waterConsumed / _dailyGoal;
    final caffeineProgress = _caffeineConsumed / _dailyCaffeineLimit;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Su ve Kafein Takip'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.person),
            tooltip: 'Profil',
            onPressed: () async {
              final updated = await Navigator.push<bool>(
                context,
                MaterialPageRoute(builder: (_) => const ProfileScreen()),
              );
              if (updated == true) {
                _loadData(); // Profil değişti, hedefi ve verileri tekrar yükle
              }
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
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
                children: [
                  CircularProgressIndicator(value: waterProgress, strokeWidth: 12),
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
                children: [
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
            // ── Kaydırılabilir buton satırı ──
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  ElevatedButton(onPressed: _addWater, child: const Text('200 ml Su Ekle')),
                  const SizedBox(width: 12),
                  ElevatedButton(onPressed: _showDrinkOptions, child: const Text('İçecek Ekle')),
                  const SizedBox(width: 12),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const StatisticsScreen()),
                      );
                    },
                    child: const Text('İstatistikler'),
                  ),
                ],
              ),
            ),
            // ───────────────────────────
          ],
        ),
      ),
    );
  }
}
