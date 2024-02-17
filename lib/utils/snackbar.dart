import 'package:flutter/material.dart';
import 'package:flutterapp/utils/theme.dart';

/// Shows a floating snackbar with the given [message].
void showSnackbar(BuildContext context, String message) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    content: Text(
      message,
      style: TextStyle(
        color: ThemeColors.textPrimary,
        fontSize: 16,
        fontWeight: FontWeight.w500,
      ),
    ),
    margin: const EdgeInsets.fromLTRB(16, 5, 16, 16),
    padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
    behavior: SnackBarBehavior.floating,
    dismissDirection: DismissDirection.horizontal,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
    backgroundColor: Colors.grey.shade700.withOpacity(0.95),
  ));
}
