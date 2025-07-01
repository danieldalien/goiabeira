import 'package:flutter/material.dart';

class CustomSnackBarClass {
  static void storageStateSnackBar({
    required BuildContext context,
    required bool isSuccess,
    required VoidCallback onDismiss,
    final String? successMessage,
    final String? errorMessage,
  }) {
    final snackBar = SnackBar(
      backgroundColor: isSuccess ? Colors.green : Colors.red,
      content: Row(
        children: [
          Icon(
            isSuccess ? Icons.check_circle_outline : Icons.error_outline,
            color: Colors.white,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              isSuccess
                  ? successMessage ?? 'Operation was successful!'
                  : errorMessage ?? 'Operation failed!',
              style: const TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
      behavior: SnackBarBehavior.fixed,
      //margin: const EdgeInsets.all(16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      duration: const Duration(seconds: 3),
    );

    // Show the SnackBar and listen for when it closes.
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(snackBar).closed.then((_) => onDismiss());
  }
}
