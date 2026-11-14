import 'package:flutter/material.dart';
import '../utils/app_strings.dart';
import '../widgets/table_tracker_dialog.dart';

class WelcomeScreen extends StatefulWidget {
  final bool isArabic;
  final VoidCallback onToggleLanguage;
  final Function(bool isDineIn, String? tableNumber) onSelectOrderType;

  const WelcomeScreen({
    super.key,
    required this.isArabic,
    required this.onToggleLanguage,
    required this.onSelectOrderType,
  });

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  void _handleDineIn() {
    showDialog(
      context: context,
      builder: (ctx) => TableTrackerDialog(
        isArabic: widget.isArabic,
        onConfirm: (tableNum) {
          Navigator.pop(ctx);
          widget.onSelectOrderType(true, tableNum);
        },
        onSkip: () {
          Navigator.pop(ctx);
          widget.onSelectOrderType(true, null);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isAr = widget.isArabic;

    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Background food image with overlay gradient
          Image.network(
            'https://images.unsplash.com/photo-1550547660-d9450f859349?w=1600&auto=format&fit=crop&q=80',
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) => Container(
              color: const Color(0xFF1E1E1E),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.black.withValues(alpha: 0.88),
                  Colors.black.withValues(alpha: 0.65),
                  Colors.black.withValues(alpha: 0.92),
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),

          // Top Language Toggle
          Positioned(
            top: 24,
            left: isAr ? 24 : null,
            right: isAr ? null : 24,
            child: InkWell(
              onTap: widget.onToggleLanguage,
              borderRadius: BorderRadius.circular(30),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(30),
                  border: Border.all(color: Colors.white38),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(isAr ? '🇬🇧' : '🇪🇬', style: const TextStyle(fontSize: 20)),
                    const SizedBox(width: 8),
                    Text(
                      isAr ? 'English' : 'عربي',
                      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Main Kiosk Content
          Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Restaurant Brand Emblem
                  Container(
                    padding: const EdgeInsets.all(22),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFFFF5722), Color(0xFFFF9800)],
                      ),
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFFFF5722).withValues(alpha: 0.5),
                          blurRadius: 36,
                          spreadRadius: 6,
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.lunch_dining_rounded,
                      size: 68,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 24),

                  Text(
                    isAr ? 'برجر كينجدوم' : 'BURGER KINGDOM',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 46,
                      fontWeight: FontWeight.w900,
                      color: Colors.white,
                      letterSpacing: 2,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    isAr
                        ? 'طعم اللحم المشوي على اللهب • خدمة ذاتية فائقة السرعة'
                        : 'Flame-Grilled Gourmet Burgers • Instant Self-Service',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 18,
                      color: Color(0xFFFFCC80),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 48),

                  Text(
                    isAr
                        ? 'من فضلك اختر طريقة استلام الطلب للبدء'
                        : 'Please choose dining option to begin',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 28),

                  // Dine In vs Takeaway Cards
                  Wrap(
                    spacing: 32,
                    runSpacing: 24,
                    alignment: WrapAlignment.center,
                    children: [
                      // Dine In Card
                      _OrderTypeCard(
                        title: AppStrings.dineIn(isAr),
                        subtitle: isAr
                            ? 'Dine In • استمتع بوجبتك الساخنة في صالتنا'
                            : 'Enjoy your hot meal inside our lounge',
                        icon: Icons.restaurant_rounded,
                        color: const Color(0xFFFF5722),
                        buttonText: isAr ? 'تناول بالصالة' : 'Dine In Here',
                        onTap: _handleDineIn,
                      ),

                      // Takeaway Card
                      _OrderTypeCard(
                        title: AppStrings.takeaway(isAr),
                        subtitle: isAr
                            ? 'Takeaway • استلم وجبتك مغلفة ومعبأة للسفر'
                            : 'Pick up your packaged order to go',
                        icon: Icons.shopping_bag_rounded,
                        color: const Color(0xFF2E7D32),
                        buttonText: isAr ? 'طلب تيك أواي' : 'Order Takeaway',
                        onTap: () => widget.onSelectOrderType(false, null),
                      ),
                    ],
                  ),

                  const SizedBox(height: 48),

                  // Subtle Touch to Order Footer Bar
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(30),
                      border: Border.all(color: Colors.white24),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.touch_app_rounded, color: Colors.white70, size: 18),
                        const SizedBox(width: 8),
                        Flexible(
                          child: Text(
                            isAr
                                ? 'المس الشاشة في أي وقت للبدء | Touch to Start'
                                : 'Touch any option to start your order',
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(color: Colors.white70, fontSize: 13),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _OrderTypeCard extends StatefulWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;
  final String buttonText;
  final VoidCallback onTap;

  const _OrderTypeCard({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
    required this.buttonText,
    required this.onTap,
  });

  @override
  State<_OrderTypeCard> createState() => _OrderTypeCardState();
}

class _OrderTypeCardState extends State<_OrderTypeCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedScale(
        scale: _isHovered ? 1.04 : 1.0,
        duration: const Duration(milliseconds: 200),
        child: InkWell(
          onTap: widget.onTap,
          borderRadius: BorderRadius.circular(24),
          child: Container(
            width: 320,
            padding: const EdgeInsets.all(32),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: widget.color.withValues(alpha: _isHovered ? 0.45 : 0.22),
                  blurRadius: _isHovered ? 28 : 16,
                  offset: const Offset(0, 10),
                ),
              ],
              border: Border.all(
                color: _isHovered ? widget.color : Colors.transparent,
                width: 2.5,
              ),
            ),
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(22),
                  decoration: BoxDecoration(
                    color: widget.color.withValues(alpha: 0.12),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(widget.icon, size: 54, color: widget.color),
                ),
                const SizedBox(height: 20),
                Text(
                  widget.title,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1E1E1E),
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  widget.subtitle,
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 13, color: Colors.grey.shade600),
                ),
                const SizedBox(height: 20),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 13),
                  decoration: BoxDecoration(
                    color: widget.color,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  alignment: Alignment.center,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        widget.buttonText,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(width: 6),
                      const Icon(Icons.arrow_forward_rounded, color: Colors.white, size: 18),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
