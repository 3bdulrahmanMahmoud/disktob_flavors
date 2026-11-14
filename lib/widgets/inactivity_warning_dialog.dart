import 'dart:async';
import 'package:flutter/material.dart';
import '../utils/app_strings.dart';

class InactivityWarningDialog extends StatefulWidget {
  final bool isArabic;
  final VoidCallback onContinue;
  final VoidCallback onTimeout;

  const InactivityWarningDialog({
    super.key,
    required this.isArabic,
    required this.onContinue,
    required this.onTimeout,
  });

  @override
  State<InactivityWarningDialog> createState() => _InactivityWarningDialogState();
}

class _InactivityWarningDialogState extends State<InactivityWarningDialog> {
  int _secondsRemaining = 20;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) return;
      if (_secondsRemaining > 1) {
        setState(() => _secondsRemaining--);
      } else {
        timer.cancel();
        widget.onTimeout();
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final progress = _secondsRemaining / 20.0;

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 440),
        child: Padding(
          padding: const EdgeInsets.all(28),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Circular countdown timer
              Stack(
                alignment: Alignment.center,
                children: [
                  SizedBox(
                    width: 84,
                    height: 84,
                    child: CircularProgressIndicator(
                      value: progress,
                      strokeWidth: 6,
                      backgroundColor: Colors.grey.shade200,
                      color: const Color(0xFFFF5722),
                    ),
                  ),
                  Text(
                    '$_secondsRemaining',
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.w900,
                      color: Color(0xFFFF5722),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Text(
                AppStrings.areYouThere(widget.isArabic),
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1E1E1E),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                '${AppStrings.timeoutPrompt(widget.isArabic)} $_secondsRemaining ${widget.isArabic ? "ثانية" : "seconds"}',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
              ),
              const SizedBox(height: 28),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF2E7D32),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  ),
                  onPressed: () {
                    _timer?.cancel();
                    widget.onContinue();
                  },
                  child: Text(
                    AppStrings.keepOrdering(widget.isArabic),
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              TextButton(
                onPressed: () {
                  _timer?.cancel();
                  widget.onTimeout();
                },
                child: Text(
                  AppStrings.resetNow(widget.isArabic),
                  style: TextStyle(color: Colors.red.shade700, fontWeight: FontWeight.w600),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
