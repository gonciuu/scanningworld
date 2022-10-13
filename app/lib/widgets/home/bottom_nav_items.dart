import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';

List<BottomNavigationBarItem> bottomNavItems(int selectedIndex) => [
      BottomNavigationBarItem(
        icon: SvgPicture.asset(
          'assets/icons/home_icon.svg',
          color: selectedIndex == 0 ? Colors.black : Colors.grey.shade400,
          semanticsLabel: 'Home',
        ),
        label: Platform.isIOS ? null : 'Home',
      ),
      BottomNavigationBarItem(
        icon: SvgPicture.asset(
          'assets/icons/prize_icon.svg',
          color: selectedIndex == 1 ? Colors.black : Colors.grey.shade400,
          semanticsLabel: 'Prize',
        ),
        label: Platform.isIOS ? null : 'Nagrody',
      ),
      BottomNavigationBarItem(
        icon: SvgPicture.asset('assets/icons/map_icon.svg',
            color: selectedIndex == 2 ? Colors.black : Colors.grey.shade400,
            semanticsLabel: 'Map'),
        label: Platform.isIOS ? null : 'Mapa',
      ),
      BottomNavigationBarItem(
        icon: SvgPicture.asset(
            color: selectedIndex == 3 ? Colors.black : Colors.grey.shade400,
            'assets/icons/profile_icon.svg',
            semanticsLabel: 'Profile'),
        label: Platform.isIOS ? null : 'Profil',
      ),
    ];

//   @override
