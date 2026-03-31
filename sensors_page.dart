import 'package:flutter/material.dart';
import '../firebase_service.dart';
import '../models/sensor_data_model.dart';

class SensorsPage extends StatelessWidget {
  final VoidCallback onBackToHome;
  final FirebaseService _firebaseService = FirebaseService();

  SensorsPage({
    super.key,
    required this.onBackToHome,
  });

  Widget sensorCard({
    required IconData icon,
    required String title,
    required String value,
    required String status,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        boxShadow: const [
          BoxShadow(
            color: Color(0x14000000),
            blurRadius: 10,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 54,
            height: 54,
            decoration: BoxDecoration(
              color: color.withOpacity(0.12),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(icon, color: color, size: 28),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  status,
                  style: const TextStyle(color: Colors.black54),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _tempStatus(double temp, bool isArabic) {
    if (temp > 35) return isArabic ? '⚠️ مرتفعة - خطر!' : '⚠️ High - Danger!';
    if (temp > 30) return isArabic ? 'مرتفعة قليلًا' : 'Slightly high';
    if (temp < 15) return isArabic ? 'منخفضة' : 'Low';
    return isArabic ? 'ضمن المعدل' : 'Normal';
  }

  String _humStatus(double hum, bool isArabic) {
    if (hum > 80) return isArabic ? 'مرتفعة جدًا' : 'Very high';
    if (hum < 30) return isArabic ? 'منخفضة' : 'Low';
    return isArabic ? 'ضمن المعدل' : 'Normal';
  }

  String _soilStatus(int soil, bool isArabic) {
    if (soil < 30) return isArabic ? '⚠️ جافة جدًا' : '⚠️ Very dry';
    if (soil < 40) return isArabic ? 'منخفضة - تحتاج ري' : 'Low - needs watering';
    if (soil > 80) return isArabic ? 'مشبعة' : 'Saturated';
    return isArabic ? 'ضمن المعدل' : 'Normal';
  }

  String _gasStatus(int gas, bool isArabic) {
    if (gas > 500) return isArabic ? '⚠️ مرتفع - تم تفعيل المراوح' : '⚠️ High - Fans activated';
    if (gas > 300) return isArabic ? 'متوسط' : 'Medium';
    return isArabic ? 'طبيعي' : 'Normal';
  }

  String _lightStatus(int light, bool isArabic) {
    if (light < 20) return isArabic ? 'منخفض جدًا' : 'Very low';
    if (light < 40) return isArabic ? 'منخفض' : 'Low';
    if (light > 80) return isArabic ? 'ساطع' : 'Bright';
    return isArabic ? 'جيد' : 'Good';
  }

  @override
  Widget build(BuildContext context) {
    final isArabic = Localizations.localeOf(context).languageCode == 'ar';

    return Directionality(
      textDirection: isArabic ? TextDirection.rtl : TextDirection.ltr,
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text(isArabic ? 'السينسورات' : 'Sensors'),
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

            return ListView(
              padding: const EdgeInsets.all(18),
              children: [
                // شريط الاتصال
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                  margin: const EdgeInsets.only(bottom: 14),
                  decoration: BoxDecoration(
                    color: snapshot.hasData ? Colors.green.shade50 : Colors.red.shade50,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        snapshot.hasData ? Icons.wifi : Icons.wifi_off,
                        color: snapshot.hasData ? Colors.green : Colors.red,
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        snapshot.hasData
                            ? (isArabic ? '🟢 متصل - بيانات حية' : '🟢 Connected - Live data')
                            : (isArabic ? '🔴 غير متصل' : '🔴 Disconnected'),
                        style: TextStyle(
                          color: snapshot.hasData ? Colors.green.shade700 : Colors.red.shade700,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                sensorCard(
                  icon: Icons.thermostat_rounded,
                  title: isArabic ? 'درجة الحرارة' : 'Temperature',
                  value: '${sensor.temp.toStringAsFixed(1)}°C',
                  status: _tempStatus(sensor.temp, isArabic),
                  color: sensor.temp > 35 ? Colors.red : Colors.orange,
                ),
                const SizedBox(height: 14),
                sensorCard(
                  icon: Icons.water_drop_rounded,
                  title: isArabic ? 'رطوبة الجو' : 'Air Humidity',
                  value: '${sensor.hum.toStringAsFixed(1)}%',
                  status: _humStatus(sensor.hum, isArabic),
                  color: Colors.blue,
                ),
                const SizedBox(height: 14),
                sensorCard(
                  icon: Icons.grass_rounded,
                  title: isArabic ? 'رطوبة التربة' : 'Soil Moisture',
                  value: '${sensor.soil}%',
                  status: _soilStatus(sensor.soil, isArabic),
                  color: sensor.soil < 40 ? Colors.orange : Colors.green,
                ),
                const SizedBox(height: 14),
                sensorCard(
                  icon: Icons.wb_sunny_rounded,
                  title: isArabic ? 'الضوء' : 'Light',
                  value: '${sensor.light}%',
                  status: _lightStatus(sensor.light, isArabic),
                  color: Colors.amber,
                ),
                const SizedBox(height: 14),
                sensorCard(
                  icon: Icons.cloud_rounded,
                  title: isArabic ? 'الغاز' : 'Gas',
                  value: '${sensor.gas}',
                  status: _gasStatus(sensor.gas, isArabic),
                  color: sensor.gas > 500 ? Colors.red : Colors.redAccent,
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
