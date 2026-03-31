import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'main_navigation_page.dart';
import 'dart:ui' as ui;
import '../app.dart';

class SplashPage extends StatelessWidget {
  const SplashPage({super.key});

  @override
  Widget build(BuildContext context) {
    final isArabic = Localizations.localeOf(context).languageCode == 'ar';
    final now = DateTime.now();

    final String dayName = isArabic
        ? DateFormat('EEEE', 'ar').format(now)
        : DateFormat('EEEE', 'en').format(now);

    final String dateText = isArabic
        ? DateFormat('d MMMM yyyy', 'ar').format(now)
        : DateFormat('d MMMM yyyy', 'en').format(now);

    final String timeText =
        DateFormat('hh:mm a', isArabic ? 'ar' : 'en').format(now);

    return Directionality(
      textDirection: isArabic ? ui.TextDirection.rtl : ui.TextDirection.ltr,
      child: Scaffold(
        body: Stack(
          children: [
            SizedBox.expand(
              child: Image.network(
                'https://images.unsplash.com/photo-1500937386664-56d1dfef3854?auto=format&fit=crop&w=1200&q=80',
                fit: BoxFit.cover,
              ),
            ),
            Container(
              color: Colors.black.withOpacity(0.45),
            ),
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(22),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Align(
                      alignment:
                          isArabic ? Alignment.topLeft : Alignment.topRight,
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.16),
                          borderRadius: BorderRadius.circular(18),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            _langButton(
                              text: 'AR',
                              selected: isArabic,
                              onTap: () {
                                MyApp.of(context)?.changeLanguage('ar');
                              },
                            ),
                            _langButton(
                              text: 'EN',
                              selected: !isArabic,
                              onTap: () {
                                MyApp.of(context)?.changeLanguage('en');
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                    const Spacer(),
                    const Text(
                      'AgriSense',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 38,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1,
                      ),
                    ),
                    const SizedBox(height: 14),
                    Text(
                      isArabic
                          ? 'راقب مزرعتك بذكاء، وتحكم ببيئتها بثقة.'
                          : 'Monitor your farm smartly, and control its environment with confidence.',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        height: 1.6,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 24),
                    Container(
                      padding: const EdgeInsets.all(18),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.14),
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(
                          color: Colors.white.withOpacity(0.18),
                        ),
                      ),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.calendar_month_rounded,
                            color: Colors.white,
                            size: 28,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  isArabic
                                      ? 'معلومات اليوم'
                                      : 'Today information',
                                  style: const TextStyle(
                                    color: Colors.white70,
                                    fontSize: 14,
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  '$dayName - $dateText',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  timeText,
                                  style: const TextStyle(
                                    color: Colors.white70,
                                    fontSize: 15,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 28),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const MainNavigationPage(),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF43A047),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 18),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          elevation: 8,
                        ),
                        child: Text(
                          isArabic ? 'تفقد المزرعة' : 'Inspect the Farm',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      isArabic
                          ? 'نظام ذكي لمراقبة الحساسات والتحكم بالأجهزة والتنبيهات.'
                          : 'A smart system for monitoring sensors, controlling devices, and receiving alerts.',
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 13,
                        height: 1.6,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _langButton({
    required String text,
    required bool selected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: selected ? Colors.white : Colors.transparent,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Text(
          text,
          style: TextStyle(
            color: selected ? Colors.green[800] : Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
