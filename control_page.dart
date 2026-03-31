import 'package:flutter/material.dart';
import '../firebase_service.dart';
import '../models/sensor_data_model.dart';
import '../services/notification_service.dart';

class ControlPage extends StatefulWidget {
  final VoidCallback onBackToHome;

  const ControlPage({
    super.key,
    required this.onBackToHome,
  });

  @override
  State<ControlPage> createState() => _ControlPageState();
}

class _ControlPageState extends State<ControlPage> {
  final FirebaseService _firebaseService = FirebaseService();

  void _toggleAutoMode(bool currentValue) {
    bool isAutoMode = !currentValue;
    _firebaseService.setControl('autoMode', isAutoMode);
    
    // إذا تم التبديل إلى الوضع اليدوي، نقوم بإيقاف جميع الأجهزة لتجنب استمرارها بالعمل
    if (!isAutoMode) {
      _firebaseService.setControl('fanTemp', false);
      _firebaseService.setControl('fanGas', false);
      _firebaseService.setControl('pump', false);
    }
  }

  void _toggleControl(String key, bool currentValue, String nameAr, String nameEn, bool isArabic) {
    final newValue = !currentValue;
    _firebaseService.setControl(key, newValue);

    NotificationService.showNotification(
      title: isArabic ? nameAr : nameEn,
      body: newValue
          ? (isArabic ? 'تم تشغيل $nameAr' : '$nameEn turned ON')
          : (isArabic ? 'تم إيقاف $nameAr' : '$nameEn turned OFF'),
    );
  }

  Widget _modeToggleCard({
    required bool isAutoMode,
    required bool isArabic,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: isAutoMode
              ? [const Color(0xFF2E7D32), const Color(0xFF1B5E20)]
              : [const Color(0xFF1565C0), const Color(0xFF0D47A1)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: (isAutoMode ? Colors.green : Colors.blue).withOpacity(0.3),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Icon(
                  isAutoMode ? Icons.smart_toy_rounded : Icons.touch_app_rounded,
                  color: Colors.white,
                  size: 30,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      isAutoMode
                          ? (isArabic ? 'الوضع التلقائي' : 'Automatic Mode')
                          : (isArabic ? 'الوضع اليدوي' : 'Manual Mode'),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      isAutoMode
                          ? (isArabic
                              ? 'ESP32 يتحكم تلقائيًا حسب الحساسات'
                              : 'ESP32 controls devices automatically')
                          : (isArabic
                              ? 'تحكم يدوي من الجوال'
                              : 'Manual control from phone'),
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    if (!isAutoMode) _toggleAutoMode(false);
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    decoration: BoxDecoration(
                      color: isAutoMode ? Colors.white : Colors.white.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.smart_toy_rounded,
                          size: 18,
                          color: isAutoMode ? Colors.green.shade700 : Colors.white70,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          isArabic ? 'تلقائي' : 'Auto',
                          style: TextStyle(
                            color: isAutoMode ? Colors.green.shade700 : Colors.white70,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    if (isAutoMode) _toggleAutoMode(true);
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    decoration: BoxDecoration(
                      color: !isAutoMode ? Colors.white : Colors.white.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.touch_app_rounded,
                          size: 18,
                          color: !isAutoMode ? Colors.blue.shade700 : Colors.white70,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          isArabic ? 'يدوي' : 'Manual',
                          style: TextStyle(
                            color: !isAutoMode ? Colors.blue.shade700 : Colors.white70,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget controlCard({
    required String title,
    required bool isOn,
    required IconData icon,
    required Color color,
    required VoidCallback onToggle,
    required bool isArabic,
    required bool enabled,
  }) {
    return Opacity(
      opacity: enabled ? 1.0 : 0.55,
      child: Container(
        padding: const EdgeInsets.all(20),
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
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
              width: 58,
              height: 58,
              decoration: BoxDecoration(
                color: (isOn ? color : Colors.grey).withOpacity(0.12),
                borderRadius: BorderRadius.circular(18),
              ),
              child: Icon(icon, color: isOn ? color : Colors.grey, size: 30),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      Container(
                        width: 10,
                        height: 10,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: isOn ? Colors.green : Colors.red,
                          boxShadow: isOn
                              ? [BoxShadow(color: Colors.green.withOpacity(0.5), blurRadius: 6)]
                              : [],
                        ),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        isOn
                            ? (isArabic ? 'قيد التشغيل' : 'Running')
                            : (isArabic ? 'متوقفة' : 'Stopped'),
                        style: TextStyle(
                          color: isOn ? Colors.green : Colors.red,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      if (!enabled) ...[
                        const SizedBox(width: 8),
                        Text(
                          isArabic ? '(تلقائي)' : '(Auto)',
                          style: const TextStyle(color: Colors.black38, fontSize: 12),
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),
            Switch(
              value: isOn,
              onChanged: enabled ? (_) => onToggle() : null,
              activeColor: color,
            ),
          ],
        ),
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
          title: Text(isArabic ? 'التحكم' : 'Control'),
          centerTitle: true,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: widget.onBackToHome,
          ),
        ),
        body: StreamBuilder<Map<String, dynamic>>(
          stream: _firebaseService.getControlStream(),
          builder: (context, controlSnapshot) {
            return StreamBuilder<Map<String, dynamic>>(
              stream: _firebaseService.getSensorStream(),
              builder: (context, sensorSnapshot) {
                if (controlSnapshot.connectionState == ConnectionState.waiting &&
                    sensorSnapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                final controlData = controlSnapshot.data ?? {};
                final sensorData = sensorSnapshot.data ?? {};
                final sensor = SensorDataModel.fromMap(sensorData);

                final bool isAutoMode = controlData['autoMode'] != false; // افتراضي: تلقائي

                // في الوضع التلقائي: عرض حالة الأجهزة من الحساسات (ما يفعله ESP32)
                // في الوضع اليدوي: عرض حالة الأجهزة من /control
                final bool fanTemp = isAutoMode ? sensor.fanTemp : (controlData['fanTemp'] == true);
                final bool fanGas = isAutoMode ? sensor.fanGas : (controlData['fanGas'] == true);
                final bool pump = isAutoMode ? sensor.pump : (controlData['pump'] == true);

                return ListView(
                  padding: const EdgeInsets.all(18),
                  children: [
                    // بطاقة تبديل الوضع
                    _modeToggleCard(isAutoMode: isAutoMode, isArabic: isArabic),

                    // رسالة توضيحية
                    if (isAutoMode)
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                        margin: const EdgeInsets.only(bottom: 14),
                        decoration: BoxDecoration(
                          color: Colors.amber.shade50,
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(color: Colors.amber.shade200),
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.info_outline, color: Colors.amber.shade700, size: 20),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                isArabic
                                    ? 'الوضع التلقائي مُفعّل — ESP32 يتحكم بالأجهزة. للتحكم يدويًا اختر "يدوي"'
                                    : 'Auto mode is ON — ESP32 controls devices. Switch to "Manual" for phone control',
                                style: TextStyle(
                                  color: Colors.amber.shade900,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                    controlCard(
                      title: isArabic ? 'مروحة الحرارة' : 'Temperature Fan',
                      isOn: fanTemp,
                      icon: Icons.air_rounded,
                      color: Colors.deepOrange,
                      onToggle: () => _toggleControl('fanTemp', fanTemp, 'مروحة الحرارة', 'Temperature Fan', isArabic),
                      isArabic: isArabic,
                      enabled: !isAutoMode,
                    ),
                    controlCard(
                      title: isArabic ? 'مروحة الغاز' : 'Gas Fan',
                      isOn: fanGas,
                      icon: Icons.air_rounded,
                      color: Colors.amber.shade700,
                      onToggle: () => _toggleControl('fanGas', fanGas, 'مروحة الغاز', 'Gas Fan', isArabic),
                      isArabic: isArabic,
                      enabled: !isAutoMode,
                    ),
                    controlCard(
                      title: isArabic ? 'المضخة' : 'Water Pump',
                      isOn: pump,
                      icon: Icons.water_rounded,
                      color: Colors.blue,
                      onToggle: () => _toggleControl('pump', pump, 'المضخة', 'Water Pump', isArabic),
                      isArabic: isArabic,
                      enabled: !isAutoMode,
                    ),
                  ],
                );
              },
            );
          },
        ),
      ),
    );
  }
}
