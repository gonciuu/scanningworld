import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:flutter_svg/svg.dart';
import 'package:scanning_world/widgets/home/bottom_nav_items.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  static const String routeName = '/home';

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  //create function to change the tab index
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return PlatformScaffold(
      bottomNavBar: PlatformNavBar(
        material: (_, __) => MaterialNavBarData(
          showSelectedLabels: false,
          showUnselectedLabels: false,
          type: BottomNavigationBarType.fixed,
          elevation: 1,
        ),
        cupertino: (context, platform) => CupertinoTabBarData(
          activeColor: Colors.black,
          inactiveColor: Colors.grey.shade400,
          border: Border(
            top: BorderSide(
              color: Colors.grey.shade400,
              width: 0.0, // One physical pixel.
              style: BorderStyle.solid,
            ),
          ),
        ),
        backgroundColor: Colors.white,
        currentIndex: _selectedIndex,
        itemChanged: _onItemTapped,
        items: bottomNavItems(_selectedIndex),
      ),
      body: SafeArea(
        child: IndexedStack(
          index: _selectedIndex,
          children: const [
            Center(child: Text('Home')),
            Center(child: Text('Search')),
            Center(child: Text('Profile')),
            Center(child: Text('Prize')),
          ],
        ),
      ),
    );
  }
}
