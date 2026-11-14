import 'package:flutter/material.dart';

class TableTrackerDialog extends StatefulWidget {
  final bool isArabic;
  final Function(String tableNumber) onConfirm;
  final VoidCallback onSkip;

  const TableTrackerDialog({
    super.key,
    required this.isArabic,
    required this.onConfirm,
    required this.onSkip,
  });

  @override
  State<TableTrackerDialog> createState() => _TableTrackerDialogState();
}

class _TableTrackerDialogState extends State<TableTrackerDialog> {
  String _digits = '';

  void _onKeyPress(String digit) {
    if (_digits.length < 3) {
      setState(() => _digits += digit);
    }
  }

  void _onBackspace() {
    if (_digits.isNotEmpty) {
      setState(() => _digits = _digits.substring(0, _digits.length - 1));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 420),
        child: Padding(
          padding: const EdgeInsets.all(28),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFF3E0),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.table_restaurant_rounded, size: 40, color: Color(0xFFFF5722)),
              ),
              const SizedBox(height: 16),
              Text(
                widget.isArabic ? 'أدخل رقم الطاولة أو البيدجر' : 'Enter Table or Pager Number',
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 6),
              Text(
                widget.isArabic
                    ? 'خذ بطاقة الطاولة بجانب الكشك وأدخل رقمها لخدمتك'
                    : 'Take a table tent next to the kiosk and enter its number',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 13, color: Colors.grey.shade600),
              ),
              const SizedBox(height: 20),

              // Display Area
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 14),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: const Color(0xFFFF5722), width: 1.5),
                ),
                alignment: Alignment.center,
                child: Text(
                  _digits.isEmpty ? (widget.isArabic ? '--' : '--') : _digits,
                  style: const TextStyle(
                    fontSize: 36,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 4,
                    color: Color(0xFF1E1E1E),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Numpad 1-9, 0
              GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: 3,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                childAspectRatio: 1.3,
                children: [
                  ...List.generate(9, (index) {
                    final num = '${index + 1}';
                    return _NumpadButton(text: num, onTap: () => _onKeyPress(num));
                  }),
                  _NumpadButton(
                    icon: Icons.clear_rounded,
                    color: Colors.red.shade700,
                    onTap: () => setState(() => _digits = ''),
                  ),
                  _NumpadButton(text: '0', onTap: () => _onKeyPress('0')),
                  _NumpadButton(
                    icon: Icons.backspace_outlined,
                    color: Colors.grey.shade800,
                    onTap: _onBackspace,
                  ),
                ],
              ),
              const SizedBox(height: 20),

              Row(
                children: [
                  Expanded(
                    child: TextButton(
                      onPressed: widget.onSkip,
                      child: Text(
                        widget.isArabic ? 'تخطي (استلام من الكاشير)' : 'Skip (Pickup Counter)',
                        style: TextStyle(color: Colors.grey.shade700, fontSize: 13),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _digits.isEmpty ? Colors.grey.shade400 : const Color(0xFFFF5722),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                      ),
                      onPressed: _digits.isEmpty
                          ? null
                          : () => widget.onConfirm(_digits),
                      child: Text(
                        widget.isArabic ? 'تأكيد' : 'Confirm',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NumpadButton extends StatelessWidget {
  final String? text;
  final IconData? icon;
  final Color? color;
  final VoidCallback onTap;

  const _NumpadButton({this.text, this.icon, this.color, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.white,
        foregroundColor: color ?? const Color(0xFF212121),
        elevation: 1,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
          side: BorderSide(color: Colors.grey.shade300),
        ),
        padding: EdgeInsets.zero,
      ),
      onPressed: onTap,
      child: icon != null
          ? Icon(icon, size: 24, color: color)
          : Text(
              text!,
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: color),
            ),
    );
  }
}
