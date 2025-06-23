// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Turkish (`tr`).
class AppLocalizationsTr extends AppLocalizations {
  AppLocalizationsTr([String locale = 'tr']) : super(locale);

  @override
  String get appTitle => 'Suu';

  @override
  String get waterTracker => 'Su Takip';

  @override
  String get dailyGoal => 'Günlük Su Hedefi';

  @override
  String get addWater => '200 ml Su Ekle';

  @override
  String get addDrink => 'İçecek Ekle';

  @override
  String get statistics => 'İstatistikler';

  @override
  String get profile => 'Profil';

  @override
  String get reset => 'Günlük Verileri Sıfırla';

  @override
  String get coffee => 'Kahve (200 ml)';

  @override
  String get tea => 'Çay (200 ml)';

  @override
  String get caffeineLimitWarning => '⚠️ Günlük kafein sınırını aştınız!';

  @override
  String get addDrinkButton => 'İçecek Ekle';

  @override
  String get dailyCaffeine => 'Günlük Kafein Takip';

  @override
  String get settings => 'Ayarlar';

  @override
  String get languageSelection => 'Dil Seçimi';

  @override
  String get age => 'Yaş';

  @override
  String get weight => 'Kilo';

  @override
  String get gender => 'Cinsiyet';

  @override
  String get theme => 'Tema';

  @override
  String get themeSystem => 'Sistem Varsayılanı';

  @override
  String get themeLight => 'Açık';

  @override
  String get themeDark => 'Koyu';

  @override
  String get drinkWaterNotificationTitle => 'Su içme zamanı!';

  @override
  String get drinkWaterNotificationBody =>
      'Sağlığınız için su içmeyi unutmayın.';

  @override
  String get reminder => 'Hatırlatıcı';

  @override
  String get reminderFrequency => 'Hatırlatma Sıklığı';

  @override
  String get reminderOff => 'Kapalı';

  @override
  String get reminderEvery2Hours => 'Her 2 saatte bir';

  @override
  String get reminderEvery4Hours => 'Her 4 saatte bir';

  @override
  String get reminderOnceNoon => 'Günde 1 kez (Öğlen)';
}
