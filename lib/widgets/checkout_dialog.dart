import 'package:flutter/material.dart';

class CheckoutDialog extends StatefulWidget {
  final double totalAmount;
  final bool isDineIn;
  final Function(String paymentMethod) onPaymentSuccess;

  const CheckoutDialog({
    super.key,
    required this.totalAmount,
    required this.isDineIn,
    required this.onPaymentSuccess,
  });

  @override
  State<CheckoutDialog> createState() => _CheckoutDialogState();
}

class _CheckoutDialogState extends State<CheckoutDialog> {
  String? _selectedMethod;
  bool _isProcessing = false;

  void _startPayment(String method) async {
    setState(() {
      _selectedMethod = method;
      _isProcessing = true;
    });

    // Simulate POS terminal processing
    await Future.delayed(const Duration(milliseconds: 1800));

    if (mounted) {
      widget.onPaymentSuccess(method);
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 500),
        child: Padding(
          padding: const EdgeInsets.all(28),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Icon & Title
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFF3E0),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.point_of_sale_rounded,
                  color: Color(0xFFFF5722),
                  size: 44,
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'اختر طريقة الدفع',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1E1E1E),
                ),
              ),
              const SizedBox(height: 6),
              Text(
                'المبلغ المطلوب: ${widget.totalAmount.toStringAsFixed(0)} ج.م (${widget.isDineIn ? "داخل المطعم" : "تيك أواي"})',
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFFE65100),
                ),
              ),
              const SizedBox(height: 24),

              if (_isProcessing) ...[
                const SizedBox(height: 20),
                const CircularProgressIndicator(color: Color(0xFFFF5722), strokeWidth: 3),
                const SizedBox(height: 20),
                Text(
                  _selectedMethod == 'card'
                      ? '💳 يرجى تقريب البطاقة أو إدخالها في الماكينة...'
                      : '💵 جاري تسجيل الطلب للدفع عند الكاشير...',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2E7D32),
                  ),
                ),
                const SizedBox(height: 20),
              ] else ...[
                // Payment Method Option 1: Card / POS
                _PaymentMethodCard(
                  title: 'بطاقة بنكية / فيزا / ماستركارد',
                  subtitle: 'ادفع مباشرة عبر ماكينة الدفع المرفقة بالكشك',
                  icon: Icons.credit_card_rounded,
                  badgeText: 'موصى به ⚡',
                  color: const Color(0xFF1565C0),
                  onTap: () => _startPayment('card'),
                ),
                const SizedBox(height: 14),

                // Payment Method Option 2: Cash at Counter
                _PaymentMethodCard(
                  title: 'الدفع نقداً (كاش) عند الاستلام',
                  subtitle: 'استلم إيصالك وتوجه للخزينة لدفع المبلغ واستلام الوجبة',
                  icon: Icons.attach_money_rounded,
                  color: const Color(0xFF2E7D32),
                  onTap: () => _startPayment('cash'),
                ),
                const SizedBox(height: 20),

                // Back / Cancel button
                SizedBox(
                  width: double.infinity,
                  child: TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('العودة للطلب', style: TextStyle(color: Colors.grey)),
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

class _PaymentMethodCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;
  final String? badgeText;
  final VoidCallback onTap;

  const _PaymentMethodCard({
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
                      Text(
                        title,
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                      ),
                      if (badgeText != null) ...[
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: Colors.green.shade100,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            badgeText!,
                            style: TextStyle(
                              color: Colors.green.shade800,
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
