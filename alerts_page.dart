import 'package:flutter/material.dart';
import '../firebase_service.dart';
import '../models/sensor_data_model.dart';

class AlertsPage extends StatelessWidget {
  final VoidCallback onBackToHome;
  final FirebaseService _firebaseService = FirebaseService();

  AlertsPage({
    super.key,
    required this.onBackToHome,
  });

  Widget alertCard({
    required IconData icon,
    required Color color,
    required String title,
    required String subtitle,
    required bool isActive,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isActive ? color.withOpacity(0.08) : Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: isActive ? Border.all(color: color.withOpacity(0.3), width: 1.5) : null,
        boxShadow: const [
          BoxShadow(
            color: Color(0x12000000),
            blurRadius: 8,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: color.withOpacity(isActive ? 0.2 : 0.12),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(icon, color: color),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    if (isActive)
                      Container(
                        width: 8,
                        height: 8,
                        margin: const EdgeInsets.only(left: 6),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: color,
                          boxShadow: [BoxShadow(color: color.withOpacity(0.5), blurRadius: 4)],
                        ),
                      ),
                    if (isActive) const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        title,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: isActive ? color : Colors.black87,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: TextStyle(
                    color: isActive ? color.withOpacity(0.8) : Colors.black54,
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
        ],
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
          title: Text(isArabic ? 'التنبيهات' : 'Alerts'),
          centerTitle: true,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: onBackToHome,
          ),
        ),
        body: StreamBuilder<Map<String, dynamic>>(
          stream: _firebaseService.getSensorStream(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            final data = snapshot.data ?? {};
            final sensor = SensorDataModel.fromMap(data);

            final bool highTemp = sensor.temp > 35;
            final bool highGas = sensor.gas > 500;
            final bool lowSoil = sensor.soil < 40;
            final bool lowLight = sensor.light < 20;
            final int activeAlerts = [highTemp, highGas, lowSoil, lowLight].where((a) => a).length;

            return ListView(
              padding: const EdgeInsets.all(18),
              children: [
                // ملخص التنبيهات
                Container(
                  padding: const EdgeInsets.all(16),
                  margin: const EdgeInsets.only(bottom: 18),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: activeAlerts > 0
                          ? [Colors.red.shade400, Colors.red.shade700]
                          : [Colors.green.shade400, Colors.green.shade700],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        activeAlerts > 0 ? Icons.warning_amber_rounded : Icons.check_circle_rounded,
                        color: Colors.white,
                        size: 36,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              activeAlerts > 0
                                  ? (isArabic ? '$activeAlerts تنبيهات نشطة' : '$activeAlerts Active Alerts')
                                  : (isArabic ? 'كل شيء طبيعي' : 'Everything is Normal'),
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              activeAlerts > 0
                                  ? (isArabic ? 'يرجى مراجعة التنبيهات أدناه' : 'Please review alerts below')
                                  : (isArabic ? 'جميع القراءات ضمن المعدل الطبيعي' : 'All readings within normal range'),
                              style: const TextStyle(color: Colors.white70, fontSize: 13),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                alertCard(
                  icon: Icons.thermostat_rounded,
                  color: Colors.red,
                  title: isArabic ? 'ارتفاع درجة الحرارة' : 'High Temperature',
                  subtitle: highTemp
                      ? (isArabic
                          ? 'الحرارة ${sensor.temp.toStringAsFixed(1)}°C — أعلى من الحد (35°C)!'
                          : 'Temperature ${sensor.temp.toStringAsFixed(1)}°C — exceeds limit (35°C)!')
                      : (isArabic
                          ? 'الحرارة ${sensor.temp.toStringAsFixed(1)}°C — طبيعي ✓'
                          : 'Temperature ${sensor.temp.toStringAsFixed(1)}°C — Normal ✓'),
                  isActive: highTemp,
                ),
                alertCard(
                  icon: Icons.warning_amber_rounded,
                  color: Colors.orange,
                  title: isArabic ? 'ارتفاع مستوى الغاز' : 'High Gas Level',
                  subtitle: highGas
                      ? (isArabic
                          ? 'مستوى الغاز ${sensor.gas} — تم تفعيل المراوح تلقائيًا!'
                          : 'Gas level ${sensor.gas} — Fans activated automatically!')
                      : (isArabic
                          ? 'مستوى الغاز ${sensor.gas} — طبيعي ✓'
                          : 'Gas level ${sensor.gas} — Normal ✓'),
                  isActive: highGas,
                ),
                alertCard(
                  icon: Icons.opacity_rounded,
                  color: Colors.blue,
                  title: isArabic ? 'انخفاض رطوبة التربة' : 'Low Soil Moisture',
                  subtitle: lowSoil
                      ? (isArabic
                          ? 'رطوبة التربة ${sensor.soil}% — تم تشغيل المضخة!'
                          : 'Soil moisture ${sensor.soil}% — Pump activated!')
                      : (isArabic
                          ? 'رطوبة التربة ${sensor.soil}% — طبيعي ✓'
                          : 'Soil moisture ${sensor.soil}% — Normal ✓'),
                  isActive: lowSoil,
                ),
                alertCard(
                  icon: Icons.wb_sunny_rounded,
                  color: Colors.amber,
                  title: isArabic ? 'انخفاض الإضاءة' : 'Low Light',
                  subtitle: lowLight
                      ? (isArabic
                          ? 'الإضاءة ${sensor.light}% — غير كافية لنمو النباتات'
                          : 'Light ${sensor.light}% — Insufficient for plant growth')
                      : (isArabic
                          ? 'الإضاءة ${sensor.light}% — كافية ✓'
                          : 'Light ${sensor.light}% — Sufficient ✓'),
                  isActive: lowLight,
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
