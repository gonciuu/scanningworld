import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:scanning_world/data/remote/providers/auth_provider.dart';
import 'package:scanning_world/screens/home/map_screen.dart';
import 'package:scanning_world/screens/home/profile_screen.dart';
import 'package:scanning_world/screens/home/rewards_screen.dart';
import 'package:scanning_world/widgets/home/bottom_nav_items.dart';

import '../home/home_screen.dart';

class HomeWrapper extends StatefulWidget {
  const HomeWrapper({Key? key}) : super(key: key);

  static const String routeName = '/home-wrapper';

  @override
  State<HomeWrapper> createState() => _HomeWrapperState();
}

class _HomeWrapperState extends State<HomeWrapper> {
  int _selectedIndex = 0;

  //create function to change the tab index
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  final List<Widget> _widgetOptions = <Widget>[
    const HomeScreen(),
    const RewardsScreen(),
    const MapScreen(),
    const ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    final user = context.watch<AuthProvider>().user;
    return PlatformScaffold(
      iosContentBottomPadding: true,
      iosContentPadding: true,
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
      body: IndexedStack(
        index: _selectedIndex,
        children: _widgetOptions,
      ),
    );
  }
}
