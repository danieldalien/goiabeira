import 'package:flutter/material.dart';
import 'package:goiabeira/0_Core/Config/app_navigation_config.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _current = 0;
  late final screens =
      AppMenuConfig.appMenuConfig.map((e) => e.screen).toList();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _current, children: screens),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _current,
        onDestinationSelected: (i) => setState(() => _current = i),
        destinations: [
          for (final item in AppMenuConfig.appMenuConfig)
            NavigationDestination(icon: Icon(item.icon), label: item.title),
        ],
      ),
    );
  }
}
