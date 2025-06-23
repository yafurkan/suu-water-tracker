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
    setState(() {
      _ageCtrl.text = (prefs.getInt('age') ?? '').toString();
      _weightCtrl.text = (prefs.getDouble('weight') ?? '').toString();
      _gender = prefs.getString('gender');
    });
  }

  Future<void> _saveProfile() async {
    if (!_formKey.currentState!.validate() || _gender == null) return;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('age', int.parse(_ageCtrl.text));
    await prefs.setDouble('weight', double.parse(_weightCtrl.text));
    await prefs.setString('gender', _gender!);
    Navigator.pop(context, true); // geri dönerken "güncellendi" sinyali
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
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _ageCtrl,
                decoration: const InputDecoration(
                  labelText: 'Yaş',
                  hintText: 'Örn. 30',
                ),
                keyboardType: TextInputType.number,
                validator: (v) {
                  if (v==null || v.isEmpty) return 'Yaş girin';
                  final a = int.tryParse(v);
                  if (a==null || a<1) return 'Geçersiz yaş';
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
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                validator: (v) {
                  if (v==null || v.isEmpty) return 'Kilo girin';
                  final w = double.tryParse(v);
                  if (w==null || w<1) return 'Geçersiz kilo';
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
                validator: (v) => v==null ? 'Seçin' : null,
              ),
              const Spacer(),
              ElevatedButton(
                onPressed: _saveProfile,
                child: const Text('Kaydet'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
