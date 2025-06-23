import 'package:flutter/material.dart';
import '../models/user_profile.dart';
import '../utils/profile_storage.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  int _age = 18;
  double _weight = 70;
  String _gender = 'other';

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    final profile = await ProfileStorage.loadProfile();
    if (profile != null) {
      setState(() {
        _age = profile.age;
        _weight = profile.weight;
        _gender = profile.gender;
      });
    }
  }

  Future<void> _saveProfile() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      final profile = UserProfile(
        age: _age,
        weight: _weight,
        gender: _gender,
      );
      await ProfileStorage.saveProfile(profile);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Profil kaydedildi!')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Profil')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                initialValue: _age.toString(),
                decoration: const InputDecoration(labelText: 'Yaş'),
                keyboardType: TextInputType.number,
                onSaved: (val) => _age = int.tryParse(val ?? '') ?? 18,
              ),
              TextFormField(
                initialValue: _weight.toString(),
                decoration: const InputDecoration(labelText: 'Kilo (kg)'),
                keyboardType: TextInputType.number,
                onSaved: (val) => _weight = double.tryParse(val ?? '') ?? 70,
              ),
              DropdownButtonFormField<String>(
                value: _gender,
                decoration: const InputDecoration(labelText: 'Cinsiyet'),
                items: const [
                  DropdownMenuItem(value: 'male', child: Text('Erkek')),
                  DropdownMenuItem(value: 'female', child: Text('Kadın')),
                  DropdownMenuItem(value: 'other', child: Text('Diğer')),
                ],
                onChanged: (val) => setState(() => _gender = val ?? 'other'),
                onSaved: (val) => _gender = val ?? 'other',
              ),
              const SizedBox(height: 24),
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