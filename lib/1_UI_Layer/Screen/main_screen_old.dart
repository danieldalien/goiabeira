import 'package:flutter/material.dart';
import 'package:goiabeira/0_Core/Config/app_colors.dart';
import 'package:goiabeira/0_Core/Config/app_navigation_config.dart';
import 'package:goiabeira/0_Core/Config/app_text_style.dart';

class MainScreenOld extends StatefulWidget {
  const MainScreenOld({super.key});

  @override
  State<MainScreenOld> createState() => _MainScreenOldState();
}

class _MainScreenOldState extends State<MainScreenOld> {
  int _currentIndex = 0;
  late final List<Widget> _screens;

  @override
  void initState() {
    super.initState();
    // Initialize the screens list from your configuration.
    _screens = AppMenuConfig.appMenuConfig.map((item) => item.screen).toList();
    print('MainScreen initialized with ${_screens.length} screens.');
  }

  void _onItemMenuTap(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // The body displays the current screen using an IndexedStack to preserve state.
      body: IndexedStack(index: _currentIndex, children: _screens),
      // The bottom navigation bar is decorated and clipped for rounded corners.
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          color: AppColors.navigationBackground,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(30),
            topRight: Radius.circular(30),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 10,
              offset: Offset(0, -2),
            ),
          ],
        ),
        child: SafeArea(
          child: ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(30),
              topRight: Radius.circular(30),
            ),
            child: BottomNavigationBar(
              type: BottomNavigationBarType.fixed,
              currentIndex: _currentIndex,
              onTap: _onItemMenuTap,
              backgroundColor: AppColors.navigationBackground,
              selectedItemColor: AppColors.selectedNavigationItem,
              unselectedItemColor: AppColors.unselectedNavigationItem,
              selectedLabelStyle: AppTextStyle.myAppMenuTextStyle(
                selected: true,
              ),
              unselectedLabelStyle: AppTextStyle.myAppMenuTextStyle(
                selected: false,
              ),
              items: [
                for (var item in AppMenuConfig.appMenuConfig)
                  BottomNavigationBarItem(
                    icon: Icon(item.icon),
                    label: item.title,
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
