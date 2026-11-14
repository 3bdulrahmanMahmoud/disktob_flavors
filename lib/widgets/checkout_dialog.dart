import 'package:flutter/material.dart';
import '../utils/app_strings.dart';

class CheckoutDialog extends StatefulWidget {
  final double totalAmount;
  final bool isArabic;
  final bool isDineIn;
  final String? tableNumber;
  final Function(String paymentMethod, String receiptCode) onPaymentSuccess;

  const CheckoutDialog({
    super.key,
    required this.totalAmount,
    required this.isArabic,
    required this.isDineIn,
    this.tableNumber,
    required this.onPaymentSuccess,
  });

  @override
  State<CheckoutDialog> createState() => _CheckoutDialogState();
}

class _CheckoutDialogState extends State<CheckoutDialog> with SingleTickerProviderStateMixin {
  String? _selectedMethod;
  bool _isProcessing = false;
  String _posStep = 'waiting'; // waiting, authorized, completed
  late AnimationController _pulseController;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  void _startPayment(String method) async {
    setState(() {
      _selectedMethod = method;
      _isProcessing = true;
      _posStep = 'reading';
    });

    // Step 1: Reading card / contactless
    await Future.delayed(const Duration(milliseconds: 1400));
    if (!mounted) return;
    setState(() => _posStep = 'authorized');

    // Step 2: Authorizing & printing
    await Future.delayed(const Duration(milliseconds: 1200));
    if (!mounted) return;

    widget.onPaymentSuccess(method, 'AUTH-${DateTime.now().millisecondsSinceEpoch.toString().substring(7)}');
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final isAr = widget.isArabic;
    final curr = AppStrings.currency(isAr);

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 520),
        child: Padding(
          padding: const EdgeInsets.all(28),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Header Indicator
              Container(
                padding: const EdgeInsets.all(16),
                decoration: const BoxDecoration(
                  color: Color(0xFFFFF3E0),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.point_of_sale_rounded,
                  color: Color(0xFFFF5722),
                  size: 40,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                isAr ? 'طريقة الدفع وإتمام الطلب' : 'Select Payment Method',
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1E1E1E),
                ),
              ),
              const SizedBox(height: 6),
              Text(
                '${isAr ? "المبلغ المطلوب:" : "Total Payable:"} ${widget.totalAmount.toStringAsFixed(0)} $curr',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w900,
                  color: Color(0xFFE65100),
                ),
              ),
              if (widget.isDineIn && widget.tableNumber != null)
                Padding(
                  padding: const EdgeInsets.only(top: 4),
                  child: Text(
                    isAr ? 'طاولة رقم #${widget.tableNumber}' : 'Table #${widget.tableNumber}',
                    style: TextStyle(fontSize: 13, color: Colors.grey.shade700, fontWeight: FontWeight.bold),
                  ),
                ),
              const SizedBox(height: 24),

              if (_isProcessing) ...[
                // Animated POS Card Terminal Simulation
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade900,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.25),
                        blurRadius: 15,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Container(
                                width: 10,
                                height: 10,
                                decoration: BoxDecoration(
                                  color: _posStep == 'authorized' ? Colors.greenAccent : Colors.orangeAccent,
                                  shape: BoxShape.circle,
                                ),
                              ),
                              const SizedBox(width: 8),
                              const Text(
                                'POS TERMINAL #01',
                                style: TextStyle(color: Colors.white70, fontSize: 11, fontFamily: 'monospace'),
                              ),
                            ],
                          ),
                          const Icon(Icons.contactless_rounded, color: Colors.white, size: 24),
                        ],
                      ),
                      const SizedBox(height: 24),
                      AnimatedBuilder(
                        animation: _pulseController,
                        builder: (context, child) {
                          return Transform.scale(
                            scale: 1.0 + (_pulseController.value * 0.08),
                            child: child,
                          );
                        },
                        child: Icon(
                          _posStep == 'authorized'
                              ? Icons.verified_rounded
                              : Icons.credit_card_rounded,
                          size: 64,
                          color: _posStep == 'authorized' ? Colors.greenAccent : const Color(0xFFFF9800),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        _posStep == 'authorized'
                            ? (isAr ? 'تمت الموافقة بنجاح! جاري طباعة الإيصال...' : 'Payment Approved! Printing Ticket...')
                            : (_selectedMethod == 'card'
                                ? (isAr
                                    ? 'يرجى تقريب البطاقة أو إدخالها في ماكينة الـ POS'
                                    : 'Please Tap or Insert your Card on the reader')
                                : (isAr
                                    ? 'جاري تأكيد حجز الطلب للدفع عند الخزينة...'
                                    : 'Confirming order for counter settlement...')),
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 12),
                      const SizedBox(
                        width: 140,
                        child: LinearProgressIndicator(
                          color: Color(0xFFFF5722),
                          backgroundColor: Colors.white24,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
              ] else ...[
                // Payment Method Option 1: Contactless Card POS
                _PaymentMethodTile(
                  title: isAr ? 'بطاقة بنكية / فيزا / ماستركارد / ميزة' : 'Credit / Debit Card / Contactless',
                  subtitle: isAr
                      ? 'الدفع بلمسة واحدة عبر ماكينة الكشك السريعة'
                      : 'Tap to pay with POS contactless reader or chip',
                  icon: Icons.credit_card_rounded,
                  badgeText: isAr ? 'فوري وسريع ⚡' : 'Fast & Contactless ⚡',
                  color: const Color(0xFF1565C0),
                  onTap: () => _startPayment('card'),
                ),
                const SizedBox(height: 14),

                // Payment Method Option 2: Cash at Counter
                _PaymentMethodTile(
                  title: isAr ? 'الدفع نقداً (كاش) عند الاستلام' : 'Pay Cash at Pickup Counter',
                  subtitle: isAr
                      ? 'خذ التذكرة وتوجه للمحاسب لدفع المبلغ'
                      : 'Take your ticket and pay at the designated cashier',
                  icon: Icons.attach_money_rounded,
                  color: const Color(0xFF2E7D32),
                  onTap: () => _startPayment('cash'),
                ),
                const SizedBox(height: 20),

                // Back Button
                SizedBox(
                  width: double.infinity,
                  child: TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text(
                      isAr ? 'العودة لتعديل الطلب' : 'Back to Order',
                      style: TextStyle(color: Colors.grey.shade700, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _PaymentMethodTile extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;
  final String? badgeText;
  final VoidCallback onTap;

  const _PaymentMethodTile({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
    this.badgeText,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade300, width: 1.5),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: color, size: 28),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Flexible(
                        child: Text(
                          title,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                        ),
                      ),
                      if (badgeText != null) ...[
                        const SizedBox(width: 6),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: Colors.green.shade100,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            badgeText!,
                            style: TextStyle(
                              color: Colors.green.shade900,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
                  ),
                ],
              ),
            ),
            const Icon(Icons.arrow_forward_ios_rounded, size: 16, color: Colors.grey),
          ],
        ),
      ),
    );
  }
}
