import 'package:flutter/material.dart';
import 'screens/welcome_screen.dart';
import 'screens/kiosk_order_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const RestaurantKioskApp());
}

class RestaurantKioskApp extends StatelessWidget {
  const RestaurantKioskApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Burger Kingdom - Kiosk System',
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
        fontFamily: 'Segoe UI', // Clean, crisp default font on Windows & Android
      ),
      builder: (context, child) {
        // Enforce Arabic RTL layout for the kiosk experience
        return Directionality(
          textDirection: TextDirection.rtl,
          child: child!,
        );
      },
      home: const KioskRoot(),
    );
  }
}

class KioskRoot extends StatefulWidget {
  const KioskRoot({super.key});

  @override
  State<KioskRoot> createState() => _KioskRootState();
}

class _KioskRootState extends State<KioskRoot> {
  bool _isInOrdering = false;
  bool _isDineIn = true;

  void _startOrder(bool isDineIn) {
    setState(() {
      _isDineIn = isDineIn;
      _isInOrdering = true;
    });
  }

  void _returnToWelcome() {
    setState(() {
      _isInOrdering = false;
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
              onCancelToWelcome: _returnToWelcome,
            )
          : WelcomeScreen(
              key: const ValueKey('WelcomeScreen'),
              onSelectOrderType: _startOrder,
            ),
    );
  }
}
