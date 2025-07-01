import 'package:flutter/material.dart';
import 'package:goiabeira/0_Core/Config/app_text_style.dart';

class CustomDialogClass {
  /// Displays a dialog with a title, content, a close icon in the top-right, and an "OK" button.
  ///
  /// The close icon dismisses the dialog and returns null, while the OK button calls the [onOk] callback
  /// and returns its value.
  static Future<T?> showCustomDialog<T>({
    required BuildContext context,
    required String title,
    required Widget content,
    required T Function() onOk,
  }) {
    return showDialog<T>(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          // The title is a row with the title text and a close icon button.
          title: Row(
            //mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(child: Text(title, style: AppTextStyle.dialogTitle)),
              Positioned(
                right: 0,
                top: 0,
                child: IconButton(
                  icon: const Icon(Icons.close),
                  color: Colors.red,
                  onPressed: () => Navigator.of(dialogContext).pop(null),
                  tooltip: 'Close',
                ),
              ),
            ],
          ),
          content: (content),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                final T result = onOk();
                Navigator.of(dialogContext).pop(result);
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }
}
