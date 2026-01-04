import 'package:flutter/material.dart';

enum SnackType { success, warning, error }

class AppSnackBar {
  static void show(
    BuildContext context, {
    required String message,
    SnackType type = SnackType.success,
    Duration duration = const Duration(seconds: 3),
  }) {
    final snackBarData = _getSnackBarData(type);

    final messenger = ScaffoldMessenger.of(context);
    messenger.clearSnackBars();

    messenger.showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(
              snackBarData.icon,
              color: Colors.white,
              size: 24,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                message,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
        backgroundColor: snackBarData.color,
        behavior: SnackBarBehavior.floating,
        duration: duration,
        elevation: 6,
        margin: const EdgeInsets.all(16),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }

  static _SnackBarStyle _getSnackBarData(SnackType type) {
    switch (type) {
      case SnackType.success:
        return _SnackBarStyle(
          color: Colors.green.shade600,
          icon: Icons.check_circle,
        );
      case SnackType.warning:
        return _SnackBarStyle(
          color: Colors.orange.shade600,
          icon: Icons.warning_amber_rounded,
        );
      case SnackType.error:
        return _SnackBarStyle(
          color: Colors.red.shade600,
          icon: Icons.error_outline,
        );
    }
  }
}

class _SnackBarStyle {
  final Color color;
  final IconData icon;

  _SnackBarStyle({required this.color, required this.icon});
}
