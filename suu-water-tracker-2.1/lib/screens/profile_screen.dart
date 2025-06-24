import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:permission_handler/permission_handler.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final _ageCtrl = TextEditingController();
  final _weightCtrl = TextEditingController();
  String? _gender;
  String? _photoPath;

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _ageCtrl.text = prefs.getInt('age')?.toString() ?? '';
      _weightCtrl.text = prefs.getDouble('weight')?.toString() ?? '';
      _gender = prefs.getString('gender');
      _photoPath = prefs.getString('photoPath');
    });
  }

  Future<void> _pickPhoto() async {
    // Android 12 ve öncesi için storage izni iste
    var status = await Permission.storage.request();
    if (!status.isGranted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Fotoğraf seçmek için izin gerekli!')),
      );
      return;
    }

    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery);
    if (picked != null) {
      final cropped = await ImageCropper().cropImage(
        sourcePath: picked.path,
        aspectRatio: const CropAspectRatio(ratioX: 1, ratioY: 1),
        uiSettings: [
          AndroidUiSettings(
            toolbarTitle: 'Kırp',
            hideBottomControls: true,
          ),
          IOSUiSettings(
            title: 'Crop',
          ),
        ],
      );
      if (cropped != null) {
        setState(() {
          _photoPath = cropped.path;
        });
      }
    }
  }

  Future<void> _saveProfile() async {
    if (!_formKey.currentState!.validate() || _gender == null) {
      if (_gender == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Lütfen cinsiyet seçin.')),
        );
      }
      return;
    }
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('age', int.parse(_ageCtrl.text));
    await prefs.setDouble('weight', double.parse(_weightCtrl.text));
    await prefs.setString('gender', _gender ?? 'male');
    print('KAYDEDİLDİ: age=${_ageCtrl.text}, weight=${_weightCtrl.text}, gender=$_gender');
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
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              GestureDetector(
                onTap: _pickPhoto,
                child: Container(
                  width: 96,
                  height: 96,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: _photoPath != null && _photoPath!.isNotEmpty
                        ? DecorationImage(
                            image: FileImage(File(_photoPath!)),
                            fit: BoxFit.cover,
                          )
                        : null,
                    color: Colors.grey[300],
                  ),
                  child: _photoPath == null || _photoPath!.isEmpty
                      ? const Icon(Icons.add_a_photo, size: 40)
                      : null,
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _ageCtrl,
                decoration: const InputDecoration(
                  labelText: 'Yaş',
                  hintText: 'Örn. 30',
                ),
                keyboardType: TextInputType.number,
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
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
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
                validator: (v) => v == null ? 'Lütfen cinsiyet seçin' : null,
              ),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: _saveProfile,
                child: const Text('Kaydet', style: TextStyle(fontSize: 16)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

