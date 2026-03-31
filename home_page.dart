import 'package:flutter/material.dart';
import '../firebase_service.dart';
import '../models/sensor_data_model.dart';

class HomePage extends StatelessWidget {
  final FirebaseService _firebaseService = FirebaseService();

  HomePage({super.key});

  Widget featureCard({
    required IconData icon,
    required String title,
    required String subtitle,
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
            offset: Offset(0, 4),
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
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: const TextStyle(
                    color: Colors.black54,
                    fontSize: 13,
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

  Widget _miniSensorTile({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return Column(
      children: [
        Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: color.withOpacity(0.12),
            borderRadius: BorderRadius.circular(14),
          ),
          child: Icon(icon, color: color, size: 24),
        ),
        const SizedBox(height: 6),
        Text(
          value,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: const TextStyle(
            color: Colors.black45,
            fontSize: 11,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final isArabic = Localizations.localeOf(context).languageCode == 'ar';

    return Directionality(
      textDirection: isArabic ? TextDirection.rtl : TextDirection.ltr,
      child: Scaffold(
        appBar: AppBar(
          title: Text(isArabic ? 'الرئيسية' : 'Home'),
          centerTitle: true,
        ),
        body: StreamBuilder<Map<String, dynamic>>(
          stream: _firebaseService.getSensorStream(),
          builder: (context, snapshot) {
            final data = snapshot.data ?? {};
            final sensor = SensorDataModel.fromMap(data);
            final hasData = snapshot.hasData;

            return ListView(
              padding: const EdgeInsets.all(18),
              children: [
                // البانر الرئيسي
                Container(
                  height: 180,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(28),
                    gradient: const LinearGradient(
                      colors: [Color(0xFF2E7D32), Color(0xFF1B5E20)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                  child: Container(
                    padding: const EdgeInsets.all(22),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Row(
                          children: [
                            Container(
                              width: 10,
                              height: 10,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: hasData ? Colors.greenAccent : Colors.red,
                                boxShadow: [
                                  BoxShadow(
                                    color: (hasData ? Colors.greenAccent : Colors.red).withOpacity(0.5),
                                    blurRadius: 6,
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              hasData
                                  ? (isArabic ? 'متصل' : 'Connected')
                                  : (isArabic ? 'غير متصل' : 'Disconnected'),
                              style: const TextStyle(
                                color: Colors.white70,
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          isArabic
                              ? 'لوحة التحكم الزراعية الذكية'
                              : 'Smart Farm Dashboard',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          isArabic ? 'AgriSense — نظام ذكي للزراعة' : 'AgriSense — Smart Farming System',
                          style: const TextStyle(color: Colors.white60, fontSize: 13),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // القراءات السريعة
                Container(
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(22),
                    boxShadow: const [
                      BoxShadow(
                        color: Color(0x14000000),
                        blurRadius: 10,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        isArabic ? '📊 القراءات الحالية' : '📊 Current Readings',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          _miniSensorTile(
                            icon: Icons.thermostat_rounded,
                            label: isArabic ? 'حرارة' : 'Temp',
                            value: '${sensor.temp.toStringAsFixed(1)}°',
                            color: sensor.temp > 35 ? Colors.red : Colors.orange,
                          ),
                          _miniSensorTile(
                            icon: Icons.water_drop_rounded,
                            label: isArabic ? 'رطوبة' : 'Humidity',
                            value: '${sensor.hum.toStringAsFixed(0)}%',
                            color: Colors.blue,
                          ),
                          _miniSensorTile(
                            icon: Icons.grass_rounded,
                            label: isArabic ? 'تربة' : 'Soil',
                            value: '${sensor.soil}%',
                            color: sensor.soil < 40 ? Colors.orange : Colors.green,
                          ),
                          _miniSensorTile(
                            icon: Icons.cloud_rounded,
                            label: isArabic ? 'غاز' : 'Gas',
                            value: '${sensor.gas}',
                            color: sensor.gas > 500 ? Colors.red : Colors.grey,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                // بطاقات الميزات
                featureCard(
                  icon: Icons.sensors_rounded,
                  title: isArabic ? 'مراقبة شاملة' : 'Full Monitoring',
                  subtitle: isArabic
                      ? 'قراءة الحرارة، الضوء، الغاز، رطوبة الجو، ورطوبة التربة.'
                      : 'Monitor temperature, light, gas, air humidity, and soil moisture.',
                  color: Colors.green,
                ),
                const SizedBox(height: 14),
                featureCard(
                  icon: Icons.air_rounded,
                  title: isArabic ? 'تحكم ذكي' : 'Smart Control',
                  subtitle: isArabic
                      ? 'تشغيل المراوح عند ارتفاع الغاز وتشغيل المضخة حسب الحاجة.'
                      : 'Automatically control fans and pump based on sensor conditions.',
                  color: Colors.blue,
                ),
                const SizedBox(height: 14),
                featureCard(
                  icon: Icons.notifications_active_rounded,
                  title: isArabic ? 'تنبيهات فورية' : 'Instant Alerts',
                  subtitle: isArabic
                      ? 'تنبيهات عند وجود خطر أو تغيير حالة الأجهزة.'
                      : 'Receive alerts when risks appear or device states change.',
                  color: Colors.redAccent,
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
