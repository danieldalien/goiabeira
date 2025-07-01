import 'package:flutter/material.dart';
import 'package:goiabeira/0_Core/Config/app_colors.dart';

class AppTextStyle {
  static TextStyle myAppMenuTextStyle({bool selected = false}) {
    return TextStyle(
      color:
          selected
              ? AppColors.selectedNavigationItem
              : AppColors.unselectedNavigationItem,
      fontSize: selected ? 16 : 12,
    );
  }

  static TextStyle gaugeTitleTextStyle() {
    return const TextStyle(
      color: AppColors.primaryBlack,
      fontSize: 16,
      fontWeight: FontWeight.bold,
    );
  }

  static const TextStyle dialogTitle = TextStyle(
    color: AppColors.primaryBlack,
    fontWeight: FontWeight.bold,
    fontSize: 24,
    fontFamily: 'Neuropolitical',
  );

  static const TextStyle dialogMessage = TextStyle(
    color: AppColors.primaryBlack,
    fontWeight: FontWeight.normal,
    fontSize: 20,
  );

  static const TextStyle iconTextButton = TextStyle(
    color: AppColors.generalButtonText,
    fontSize: 12,
    fontWeight: FontWeight.bold,
  );

  static const TextStyle heading1 = TextStyle(
    color: AppColors.cardText,
    fontSize: 18,
    fontWeight: FontWeight.bold,
  );

  static const TextStyle heading2 = TextStyle(
    color: AppColors.cardText,
    fontSize: 16,
    fontWeight: FontWeight.bold,
  );

  static const TextStyle defaultText = TextStyle(
    color: AppColors.cardText,
    fontSize: 14,
    fontWeight: FontWeight.normal,
  );

  static const TextStyle hintText = TextStyle(
    color: AppColors.hintText,
    fontSize: 14,
    fontWeight: FontWeight.normal,
  );

  static TextStyle containerHeader = TextStyle(
    color: Colors.grey[700],
    fontSize: 18,
    fontWeight: FontWeight.w600,
  );

  static const TextStyle subTitle = TextStyle(
    color: Colors.black54,
    fontSize: 16,
  );

  static const TextStyle loadingDialog = TextStyle(
    fontSize: 16,
    color: AppColors.loadingDialog,
  );

  static const TextStyle buttonTextStyle = TextStyle(
    fontSize: 14,
    color: AppColors.generalButtonText,
  );

  static const TextStyle cardHeader = TextStyle(
    fontSize: 16,
    color: AppColors.cardText,
  );
  static const TextStyle cardSubHeader = TextStyle(
    fontSize: 14,
    color: AppColors.cardText,
  );
  static const TextStyle cardBody = TextStyle(
    fontSize: 12,
    color: AppColors.cardText,
  );
}
