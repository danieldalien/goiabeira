import 'package:flutter/material.dart';
import 'package:goiabeira/0_Core/Enums/app_screens.dart';
import 'package:goiabeira/1_UI_Layer/Screen/Analytics/analytics_screen.dart';
import 'package:goiabeira/1_UI_Layer/Screen/Inventory/inventory_screen.dart';
import 'package:goiabeira/1_UI_Layer/Screen/Settings/settings_screen.dart';
import 'package:goiabeira/1_UI_Layer/Screen/Sold_Inventory/sold_inventory_screen.dart';
import 'package:goiabeira/4_Data_Layer/Model/navigation_menu_model.dart';

class AppMenuConfig {
  static List<NavigationMenuModel> appMenuConfig = [
    NavigationMenuModel(
      title: 'Inventory',
      id: 0,
      icon: Icons.home,
      screen: const InventoryScreen(),
      onTap: () {
        return AppScreens.inventory;
      },
    ),
    NavigationMenuModel(
      title: 'Sold',
      id: 1,
      icon: Icons.home,
      screen: const SoldInventoryScreen(),
      onTap: () {
        return AppScreens.soldInventory;
      },
    ),
    NavigationMenuModel(
      title: 'Analytics',
      id: 2,
      icon: Icons.tab,
      screen: const AnalyticsScreen(),
      onTap: () {
        return AppScreens.analytics;
      },
    ),
    NavigationMenuModel(
      title: 'Settings',
      id: 3,
      icon: Icons.tab,
      screen: const SettingsScreen(),
      onTap: () {
        return AppScreens.settings;
      },
    ),
  ];
}
