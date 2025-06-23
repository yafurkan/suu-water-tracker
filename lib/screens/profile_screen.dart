import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final _ageCtrl = TextEditingController();
  final _weightCtrl = TextEditingController();
  String? _gender; // "male" veya "female"

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    final prefs = await SharedPreferences.getInstance();

    final savedAge = prefs.getInt('age');
    final savedWeight = prefs.getDouble('weight');
    final savedGender = prefs.getString('gender');

    setState(() {
      _ageCtrl.text = savedAge?.toString() ?? '';
      _weightCtrl.text = savedWeight?.toString() ?? '';
      _gender = savedGender;
    });
  }

  Future<void> _saveProfile() async {
    if (!_formKey.currentState!.validate()) return;
    if (_gender == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Lütfen cinsiyet seçin.')),
      );
      return;
    }

    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('age', int.parse(_ageCtrl.text));
    await prefs.setDouble('weight', double.parse(_weightCtrl.text));
    await prefs.setString('gender', _gender!);

    // Geri dönerken "true" döndürelim ki diğer ekranda yeniden yükleme tetiklensin
    Navigator.pop(context, true);
  }

  @override
  void dispose() {
    _ageCtrl.dispose();
    _weightCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Profil Ayarları')),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  TextFormField(
                    controller: _ageCtrl,
                    decoration: const InputDecoration(
                      labelText: 'Yaş',
                      hintText: 'Örn. 30',
                    ),
                    keyboardType: TextInputType.number,
                    textInputAction: TextInputAction.next,
                    validator: (v) {
                      if (v == null || v.isEmpty) return 'Yaş girin';
                      final a = int.tryParse(v);
                      if (a == null || a < 1) return 'Geçersiz yaş';
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _weightCtrl,
                    decoration: const InputDecoration(
                      labelText: 'Kilo (kg)',
                      hintText: 'Örn. 70.5',
                    ),
                    keyboardType:
                        const TextInputType.numberWithOptions(decimal: true),
                    textInputAction: TextInputAction.done,
                    validator: (v) {
                      if (v == null || v.isEmpty) return 'Kilo girin';
                      final w = double.tryParse(v);
                      if (w == null || w < 1) return 'Geçersiz kilo';
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  DropdownButtonFormField<String>(
                    value: _gender,
                    decoration: const InputDecoration(labelText: 'Cinsiyet'),
                    items: const [
                      DropdownMenuItem(value: 'male', child: Text('Erkek')),
                      DropdownMenuItem(value: 'female', child: Text('Kadın')),
                    ],
                    onChanged: (v) => setState(() => _gender = v),
                    validator: (v) =>
                        v == null ? 'Lütfen cinsiyet seçin' : null,
                  ),
                  const SizedBox(height: 32),
                  ElevatedButton(
                    onPressed: _saveProfile,
                    child: const Padding(
                      padding: EdgeInsets.symmetric(vertical: 12),
                      child: Text('Kaydet', style: TextStyle(fontSize: 16)),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
