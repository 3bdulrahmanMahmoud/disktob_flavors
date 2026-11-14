import 'package:flutter/material.dart';
import 'screens/welcome_screen.dart';
import 'screens/kiosk_order_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const RestaurantKioskApp());
}

class RestaurantKioskApp extends StatefulWidget {
  const RestaurantKioskApp({super.key});

  @override
  State<RestaurantKioskApp> createState() => _RestaurantKioskAppState();
}

class _RestaurantKioskAppState extends State<RestaurantKioskApp> {
  bool _isArabic = true;

  void _toggleLanguage() {
    setState(() {
      _isArabic = !_isArabic;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: _isArabic ? 'برجر كينجدوم - كشك الخدمة الذاتية' : 'Burger Kingdom Kiosk',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFFFF5722),
          primary: const Color(0xFFFF5722),
          secondary: const Color(0xFFFF9800),
          surface: Colors.white,
        ),
        scaffoldBackgroundColor: const Color(0xFFF8F9FA),
        fontFamily: 'Segoe UI',
      ),
      builder: (context, child) {
        return Directionality(
          textDirection: _isArabic ? TextDirection.rtl : TextDirection.ltr,
          child: child!,
        );
      },
      home: KioskRoot(
        isArabic: _isArabic,
        onToggleLanguage: _toggleLanguage,
      ),
    );
  }
}

class KioskRoot extends StatefulWidget {
  final bool isArabic;
  final VoidCallback onToggleLanguage;

  const KioskRoot({
    super.key,
    required this.isArabic,
    required this.onToggleLanguage,
  });

  @override
  State<KioskRoot> createState() => _KioskRootState();
}

class _KioskRootState extends State<KioskRoot> {
  bool _isInOrdering = false;
  bool _isDineIn = true;
  String? _tableNumber;

  void _startOrder(bool isDineIn, String? tableNumber) {
    setState(() {
      _isDineIn = isDineIn;
      _tableNumber = tableNumber;
      _isInOrdering = true;
    });
  }

  void _returnToWelcome() {
    setState(() {
      _isInOrdering = false;
      _tableNumber = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 350),
      transitionBuilder: (child, animation) {
        return FadeTransition(opacity: animation, child: child);
      },
      child: _isInOrdering
          ? KioskOrderScreen(
              key: const ValueKey('OrderScreen'),
              initialIsDineIn: _isDineIn,
              initialTableNumber: _tableNumber,
              initialIsArabic: widget.isArabic,
              onCancelToWelcome: _returnToWelcome,
            )
          : WelcomeScreen(
              key: const ValueKey('WelcomeScreen'),
              isArabic: widget.isArabic,
              onToggleLanguage: widget.onToggleLanguage,
              onSelectOrderType: _startOrder,
            ),
    );
  }
}
