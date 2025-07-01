import 'package:flutter/material.dart';

class AppColors {
  // Backgrounds
  static const Color primaryBackground = Color.fromARGB(
    255,
    255,
    245,
    240,
  ); // Warm cream
  static const Color secondaryBackground = Color.fromARGB(
    255,
    233,
    233,
    233,
  ); // Soft beige
  static const Color tertiaryBackground = Color(
    0xFFFFFFFF,
  ); // Pure white for contrast

  static const Color primaryTextColor = Color(0xFF3E3E3E); // Dark brownish gray
  static const Color secondaryTextColor = Color(0xFF7F7F7F); // Soft gray
  static const Color tertiaryTextColor = Color(0xFFB3A394); // Warm gray

  // Text Colors
  static const Color primaryWhite = Color(0xFFFFFFFF);
  static const Color primaryBlack = Color(
    0xFF3E3E3E,
  ); // Dark brownish gray for softer contrast

  // Blue Palette (muted for a warm feel)
  static const Color primaryBlue = Color(0xFF6D9EC1); // Soft, muted blue
  static const Color secondaryBlue = Color(0xFF92B7D0);
  static const Color tertiaryBlue = Color(0xFFB7CCE0);

  // Green Palette (earthy tones)
  static const Color primaryGreen = Color(0xFF6BA292);
  static const Color secondaryGreen = Color(0xFF9DC4A1);
  static const Color tertiaryGreen = Color(0xFFB7D9B5);

  // Purple/Indigo Palette (warm mauves)
  static const Color primaryIndigo = Color(0xFF8E7CC3);
  static const Color secondaryIndigo = Color(0xFFA39AD6);
  static const Color tertiaryIndigo = Color(0xFFB7B8E8);

  static const Color hintText = Color.fromARGB(255, 179, 179, 179);

  // Buttons
  static const Color generalButtonBackground = Color(
    0xFFB0A99F,
  ); // Warm grey-beige
  static const Color generalButtonText = Color(0xFFFFFFFF);
  static const Color generalButtonIcon = Color(0xFFFFFFFF);

  // Card Styling
  static const Color cardBorder = Color(0xFFE0D5C5); // Subtle warm border
  static const Color cardBackground = Color(0xFFF8F1DE); // Warm cream tone
  static const Color cardText = primaryBlack;

  // Status Colors
  static const Color errorRed = Color(0xFFE74C3C); // Softer red
  static const Color warningColor = Color(0xFFF39C12); // Warm amber
  static const Color successColor = Color(0xFF27AE60); // Vibrant green
  static const Color infoColor = Color(0xFF2980B9); // Rich blue

  // Navigation Colors
  static const Color selectedNavigationItem = Color(0xFFFFC258); // Warm amber
  static const Color unselectedNavigationItem = Color(0xFF7F7F7F); // Soft gray

  static const Color navigationItemBackground = Color(0xFFFFFFFF);
  static const Color navigationBackground = primaryBackground;

  // Miscellaneous
  static const Color loadingDialog = Color(0xFFFFFFFF);
  static const Color focusedBorderColor = Color(
    0xFFF8F1DE,
  ); // Matches card background
  static const Color unfocusedBorderColor = Color(0xFFD8D8D8);

  static const Color analyzeIconColor = Color(0xFFB3A394); // Warm gray

  static const Color editButtonBackground = Color(
    0xFFFDF6EC,
  ); // Light warm neutral
  static const Color editButtonText = primaryBlack;

  static const Color sellButtonBackground = Color(
    0xFFFDF6EC,
  ); // Same as edit button for consistency
  static const Color sellButtonText = primaryBlack;

  static const Color floatingTextLabel = Color.fromARGB(
    255,
    141,
    127,
    115,
  ); // Warm gray
}
