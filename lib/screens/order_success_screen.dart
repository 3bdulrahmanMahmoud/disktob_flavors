import 'dart:async';
import 'package:flutter/material.dart';
import '../models/cart_item.dart';
import '../utils/app_strings.dart';

class OrderSuccessScreen extends StatefulWidget {
  final int orderNumber;
  final bool isArabic;
  final bool isDineIn;
  final String? tableNumber;
  final String paymentMethod;
  final String authCode;
  final List<CartItem> orderedItems;
  final double grandTotal;
  final VoidCallback onFinish;

  const OrderSuccessScreen({
    super.key,
    required this.orderNumber,
    required this.isArabic,
    required this.isDineIn,
    this.tableNumber,
    required this.paymentMethod,
    required this.authCode,
    required this.orderedItems,
    required this.grandTotal,
    required this.onFinish,
  });

  @override
  State<OrderSuccessScreen> createState() => _OrderSuccessScreenState();
}

class _OrderSuccessScreenState extends State<OrderSuccessScreen> {
  int _secondsRemaining = 15;
  Timer? _countdownTimer;

  @override
  void initState() {
    super.initState();
    _countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) return;
      if (_secondsRemaining > 1) {
        setState(() => _secondsRemaining--);
      } else {
        timer.cancel();
        widget.onFinish();
      }
    });
  }

  @override
  void dispose() {
    _countdownTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isAr = widget.isArabic;
    final curr = AppStrings.currency(isAr);

    return Scaffold(
      backgroundColor: const Color(0xFFF3F4F6),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 580),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Top Success Indicator
                Container(
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: const Color(0xFFE8F5E9),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.green.withValues(alpha: 0.2),
                        blurRadius: 16,
                        spreadRadius: 4,
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.check_circle_rounded,
                    color: Color(0xFF2E7D32),
                    size: 68,
                  ),
                ),
                const SizedBox(height: 16),

                Text(
                  isAr ? 'تم تأكيد طلبك بنجاح! 🎉' : 'Order Confirmed Successfully! 🎉',
                  style: const TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.w900,
                    color: Color(0xFF1E1E1E),
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  widget.paymentMethod == 'card'
                      ? (isAr
                          ? 'تم الدفع بالبطاقة. برجاء استلام الإيصال ومتابعة شاشة الاستدعاء.'
                          : 'Card Payment Approved. Please take your printed receipt.')
                      : (isAr
                          ? 'يرجى التوجه لخزينة الكاشير لدفع الحساب برقم الطلب واستلام الوجبة.'
                          : 'Please proceed to cashier counter to settle payment and pick up your meal.'),
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 14, color: Colors.grey.shade700),
                ),
                const SizedBox(height: 24),

                // Realistic Thermal Paper Receipt Card
                Container(
                  padding: const EdgeInsets.all(28),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.08),
                        blurRadius: 20,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      // Restaurant Header on Receipt
                      Text(
                        isAr ? 'برجر كينجدوم - فرع النيل' : 'BURGER KINGDOM - NILE',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.2,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Tax ID: 648-291-503 • Kiosk #03',
                        style: TextStyle(fontSize: 11, color: Colors.grey.shade600, fontFamily: 'monospace'),
                      ),
                      const SizedBox(height: 16),

                      // Order Number
                      Text(
                        isAr ? 'رقم الطلب للاستدعاء' : 'CALL ORDER NUMBER',
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey,
                          letterSpacing: 1.1,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '#B-${widget.orderNumber}',
                        style: const TextStyle(
                          fontSize: 54,
                          fontWeight: FontWeight.w900,
                          color: Color(0xFFFF5722),
                          letterSpacing: 3,
                        ),
                      ),
                      const SizedBox(height: 10),

                      // Badges: Dine-In / Takeaway & Table
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: const Color(0xFFFFF3E0),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  widget.isDineIn ? Icons.restaurant : Icons.shopping_bag,
                                  size: 15,
                                  color: const Color(0xFFE65100),
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  widget.isDineIn
                                      ? (widget.tableNumber != null
                                          ? '${AppStrings.dineIn(isAr)} (طاولة #${widget.tableNumber})'
                                          : AppStrings.dineIn(isAr))
                                      : AppStrings.takeaway(isAr),
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12,
                                    color: Color(0xFFE65100),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 10),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: widget.paymentMethod == 'card'
                                  ? const Color(0xFFE3F2FD)
                                  : const Color(0xFFE8F5E9),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              widget.paymentMethod == 'card'
                                  ? (isAr ? '💳 بطاقة بنكية' : '💳 Card POS')
                                  : (isAr ? '💵 كاش بالخزينة' : '💵 Cash at Counter'),
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                                color: widget.paymentMethod == 'card'
                                    ? const Color(0xFF1565C0)
                                    : const Color(0xFF2E7D32),
                              ),
                            ),
                          ),
                        ],
                      ),

                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 18),
                        child: Divider(thickness: 1.2),
                      ),

                      // Itemized List
                      ...widget.orderedItems.map((cartItem) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    '${cartItem.quantity}x ${cartItem.item.name(isAr)}',
                                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                                  ),
                                  Text(
                                    '${cartItem.totalPrice.toStringAsFixed(0)} $curr',
                                    style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14),
                                  ),
                                ],
                              ),
                              if (cartItem.isCombo || cartItem.selectedSize.extraPrice > 0)
                                Padding(
                                  padding: const EdgeInsets.only(top: 1),
                                  child: Text(
                                    '• ${cartItem.selectedSize.name(isAr)} ${cartItem.isCombo ? (isAr ? "+ وجبة كومبو" : "+ Combo Meal") : ""}',
                                    style: TextStyle(fontSize: 11, color: Colors.grey.shade600),
                                  ),
                                ),
                            ],
                          ),
                        );
                      }),

                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 14),
                        child: Divider(thickness: 1.2),
                      ),

                      // Total Paid
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            isAr ? 'الإجمالي النهائي:' : 'Grand Total:',
                            style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                          ),
                          Text(
                            '${widget.grandTotal.toStringAsFixed(0)} $curr',
                            style: const TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.w900,
                              color: Color(0xFF2E7D32),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),

                      // Simulated Barcode / QR Code Graphic
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade100,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(Icons.qr_code_2_rounded, size: 40, color: Colors.black87),
                                const SizedBox(width: 12),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'TRACK: ${widget.authCode}',
                                      style: const TextStyle(
                                        fontFamily: 'monospace',
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(
                                      isAr ? 'امسح الباركود عند شاشة الاستلام' : 'Scan for Live Pickup Status',
                                      style: TextStyle(fontSize: 10, color: Colors.grey.shade600),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // Reset Button & Countdown Notice
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFFF5722),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 36, vertical: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    elevation: 3,
                  ),
                  onPressed: () {
                    _countdownTimer?.cancel();
                    widget.onFinish();
                  },
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.touch_app_rounded, size: 22),
                      const SizedBox(width: 8),
                      Text(
                        isAr
                            ? 'بدء طلب جديد الآن ($_secondsRemaining)'
                            : 'Start New Order Now ($_secondsRemaining)',
                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  isAr
                      ? 'سيتم إعادة ضبط الشاشة تلقائياً للعميل التالي خلال $_secondsRemaining ثانية'
                      : 'Screen will automatically reset for the next guest in $_secondsRemaining seconds',
                  style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
