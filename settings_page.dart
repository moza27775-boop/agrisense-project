import 'package:flutter/material.dart';
import '../app.dart';
import '../firebase_service.dart';

class SettingsPage extends StatefulWidget {
  final VoidCallback onBackToHome;

  const SettingsPage({
    super.key,
    required this.onBackToHome,
  });

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final FirebaseService _firebaseService = FirebaseService();

  final TextEditingController gasController = TextEditingController(text: '500');
  final TextEditingController tempController = TextEditingController(text: '35');
  final TextEditingController soilController = TextEditingController(text: '40');

  bool autoControl = true;
  bool notifications = true;
  bool _loaded = false;

  @override
  void dispose() {
    gasController.dispose();
    tempController.dispose();
    soilController.dispose();
    super.dispose();
  }

  void _saveSettings(bool isArabic) {
    _firebaseService.saveSettings({
      'gasLimit': int.tryParse(gasController.text) ?? 500,
      'tempLimit': int.tryParse(tempController.text) ?? 35,
      'soilLimit': int.tryParse(soilController.text) ?? 40,
      'autoControl': autoControl,
      'notifications': notifications,
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          isArabic ? '✅ تم حفظ الإعدادات بنجاح' : '✅ Settings saved successfully',
        ),
        backgroundColor: Colors.green,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isArabic = Localizations.localeOf(context).languageCode == 'ar';

    return Directionality(
      textDirection: isArabic ? TextDirection.rtl : TextDirection.ltr,
      child: Scaffold(
        appBar: AppBar(
          title: Text(isArabic ? 'الإعدادات' : 'Settings'),
          centerTitle: true,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: widget.onBackToHome,
          ),
        ),
        body: StreamBuilder<Map<String, dynamic>>(
          stream: _firebaseService.getSettingsStream(),
          builder: (context, snapshot) {
            // تعبئة القيم من Firebase مرة واحدة فقط
            if (snapshot.hasData && !_loaded) {
              final data = snapshot.data!;
              gasController.text = (data['gasLimit'] ?? 500).toString();
              tempController.text = (data['tempLimit'] ?? 35).toString();
              soilController.text = (data['soilLimit'] ?? 40).toString();
              autoControl = data['autoControl'] ?? true;
              notifications = data['notifications'] ?? true;
              _loaded = true;
            }

            return ListView(
              padding: const EdgeInsets.all(18),
              children: [
                // قسم اللغة
                Text(
                  isArabic ? 'اللغة' : 'Language',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () {
                          MyApp.of(context)?.changeLanguage('ar');
                        },
                        icon: const Icon(Icons.language),
                        label: const Text('العربية'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: isArabic ? Colors.green : null,
                          foregroundColor: isArabic ? Colors.white : null,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () {
                          MyApp.of(context)?.changeLanguage('en');
                        },
                        icon: const Icon(Icons.language),
                        label: const Text('English'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: !isArabic ? Colors.green : null,
                          foregroundColor: !isArabic ? Colors.white : null,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 28),

                // قسم الحدود
                Text(
                  isArabic ? 'حدود الحساسات' : 'Sensor Thresholds',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  isArabic
                      ? 'عند تجاوز هذه القيم سيتم تفعيل التنبيهات والتحكم التلقائي'
                      : 'Alerts and auto-control will trigger when these values are exceeded',
                  style: const TextStyle(color: Colors.black54, fontSize: 13),
                ),
                const SizedBox(height: 14),
                _textField(
                  controller: gasController,
                  label: isArabic ? 'حد الغاز' : 'Gas Threshold',
                  icon: Icons.cloud_rounded,
                ),
                const SizedBox(height: 12),
                _textField(
                  controller: tempController,
                  label: isArabic ? 'حد الحرارة (°C)' : 'Temperature Threshold (°C)',
                  icon: Icons.thermostat_rounded,
                ),
                const SizedBox(height: 12),
                _textField(
                  controller: soilController,
                  label: isArabic ? 'حد رطوبة التربة (%)' : 'Soil Moisture Threshold (%)',
                  icon: Icons.grass_rounded,
                ),
                const SizedBox(height: 20),

                // مفاتيح التبديل
                SwitchListTile(
                  value: autoControl,
                  onChanged: (value) {
                    setState(() {
                      autoControl = value;
                    });
                  },
                  title: Text(
                    isArabic ? 'تفعيل التحكم التلقائي' : 'Enable Auto Control',
                  ),
                  subtitle: Text(
                    isArabic
                        ? 'التحكم بالأجهزة تلقائيًا حسب قراءات الحساسات'
                        : 'Automatically control devices based on sensor readings',
                    style: const TextStyle(fontSize: 12),
                  ),
                ),
                SwitchListTile(
                  value: notifications,
                  onChanged: (value) {
                    setState(() {
                      notifications = value;
                    });
                  },
                  title: Text(
                    isArabic ? 'تفعيل التنبيهات' : 'Enable Notifications',
                  ),
                  subtitle: Text(
                    isArabic
                        ? 'إرسال إشعارات عند وجود خطر أو تغيير'
                        : 'Send notifications on danger or state changes',
                    style: const TextStyle(fontSize: 12),
                  ),
                ),
                const SizedBox(height: 24),

                // زر الحفظ
                ElevatedButton.icon(
                  onPressed: () => _saveSettings(isArabic),
                  icon: const Icon(Icons.save_rounded),
                  label: Text(
                    isArabic ? 'حفظ الإعدادات' : 'Save Settings',
                    style: const TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _textField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
  }) {
    return TextField(
      controller: controller,
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, size: 22),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
        ),
        filled: true,
        fillColor: Colors.grey.shade50,
      ),
    );
  }
}
