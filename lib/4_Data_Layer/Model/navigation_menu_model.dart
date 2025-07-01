import 'package:flutter/material.dart';

class NavigationMenuModel {
  final String title;
  final int id;
  final IconData icon;
  final Widget screen;
  final Function() onTap;

  NavigationMenuModel({
    required this.title,
    required this.id,
    required this.icon,
    required this.onTap,
    required this.screen,
  });
}
