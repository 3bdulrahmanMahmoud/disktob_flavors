import 'dart:async';
import 'package:flutter/material.dart';
import '../utils/app_strings.dart';

class KioskHeader extends StatefulWidget {
  final bool isArabic;
  final bool isDineIn;
  final String? tableNumber;
  final VoidCallback onToggleLanguage;
  final VoidCallback onToggleOrderType;
  final VoidCallback onCancelOrder;

  const KioskHeader({
    super.key,
    required this.isArabic,
    required this.isDineIn,
    this.tableNumber,
    required this.onToggleLanguage,
    required this.onToggleOrderType,
    required this.onCancelOrder,
  });

  @override
  State<KioskHeader> createState() => _KioskHeaderState();
}

class _KioskHeaderState extends State<KioskHeader> {
  late DateTime _currentTime;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _currentTime = DateTime.now();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (mounted) {
        setState(() => _currentTime = DateTime.now());
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  String _formatTime(DateTime time) {
    final hour = time.hour > 12 ? time.hour - 12 : (time.hour == 0 ? 12 : time.hour);
    final minute = time.minute.toString().padLeft(2, '0');
    final period = time.hour >= 12
        ? (widget.isArabic ? 'م' : 'PM')
        : (widget.isArabic ? 'ص' : 'AM');
    return '$hour:$minute $period';
  }

  @override
  Widget build(BuildContext context) {
    final isAr = widget.isArabic;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 14,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          // Restaurant Brand & Branch
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFFFF5722), Color(0xFFFF9800)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(14),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFFFF5722).withValues(alpha: 0.3),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: const Icon(Icons.lunch_dining_rounded, color: Colors.white, size: 28),
          ),
          const SizedBox(width: 14),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                isAr ? 'برجر كينجدوم' : 'BURGER KINGDOM',
                style: const TextStyle(
                  fontWeight: FontWeight.w900,
                  fontSize: 20,
                  letterSpacing: 1.1,
                  color: Color(0xFF1E1E1E),
                ),
              ),
              Row(
                children: [
                  Container(
                    width: 8,
                    height: 8,
                    decoration: const BoxDecoration(
                      color: Color(0xFF2E7D32),
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 6),
                  Text(
                    AppStrings.branchName(isAr),
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
            ],
          ),

          const Spacer(),

          // Language Switcher (Instant AR / EN)
          InkWell(
            onTap: widget.onToggleLanguage,
            borderRadius: BorderRadius.circular(20),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: Row(
                children: [
                  Text(isAr ? '🇬🇧' : '🇪🇬', style: const TextStyle(fontSize: 18)),
                  const SizedBox(width: 6),
                  Text(
                    isAr ? 'English' : 'عربي',
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(width: 14),

          // Order Type Selector with Table Tracker
          InkWell(
            onTap: widget.onToggleOrderType,
            borderRadius: BorderRadius.circular(30),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: const Color(0xFFFFF3E0),
                border: Border.all(color: const Color(0xFFFF9800), width: 1.5),
                borderRadius: BorderRadius.circular(30),
              ),
              child: Row(
                children: [
                  Icon(
                    widget.isDineIn ? Icons.restaurant_rounded : Icons.shopping_bag_rounded,
                    color: const Color(0xFFE65100),
                    size: 19,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    widget.isDineIn
                        ? (widget.tableNumber != null
                            ? '${AppStrings.dineIn(isAr)} (طاولة #${widget.tableNumber})'
                            : AppStrings.dineIn(isAr))
                        : AppStrings.takeaway(isAr),
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                      color: Color(0xFFE65100),
                    ),
                  ),
                  const SizedBox(width: 6),
                  const Icon(Icons.sync_alt_rounded, size: 15, color: Color(0xFFE65100)),
                ],
              ),
            ),
          ),

          const SizedBox(width: 14),

          // Digital Live Clock
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Icon(Icons.access_time_rounded, size: 16, color: Colors.grey.shade700),
                const SizedBox(width: 6),
                Text(
                  _formatTime(_currentTime),
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                    color: Colors.grey.shade800,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(width: 14),

          // Cancel / Reset Order Button
          OutlinedButton.icon(
            onPressed: widget.onCancelOrder,
            style: OutlinedButton.styleFrom(
              foregroundColor: Colors.red.shade700,
              side: BorderSide(color: Colors.red.shade200),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            icon: const Icon(Icons.restart_alt_rounded, size: 18),
            label: Text(
              AppStrings.cancelOrder(isAr),
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
            ),
          ),
        ],
      ),
    );
  }
}
