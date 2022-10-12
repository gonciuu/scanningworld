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
        ),
        label: Platform.isIOS ? null : 'Home',
      ),
      BottomNavigationBarItem(
        icon: SvgPicture.asset(
          'assets/icons/prize_icon.svg',
          color: selectedIndex == 1 ? Colors.black : Colors.grey.shade400,
        ),
        label: Platform.isIOS ? null : 'Nagrody',
      ),
      BottomNavigationBarItem(
        icon: SvgPicture.asset(
          'assets/icons/map_icon.svg',
          color: selectedIndex == 2 ? Colors.black : Colors.grey.shade400,
        ),
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
//   Widget build(BuildContext context) {
//     final _bottomNavItems = <BottomNavigationBarItem>[
//       BottomNavigationBarItem(
//         label: 'Home',
//         icon: Padding(
//           padding: const EdgeInsets.only(top: 8.0),
//           child: SvgPicture.asset(
//               height: 30,
//               color: selectedIndex == 0 ? Colors.black : Colors.grey.shade400,
//               'assets/icons/home_icon.svg',
//               semanticsLabel: 'A red up arrow'),
//         ),
//       ),
//       BottomNavigationBarItem(
//         icon: Padding(
//           padding: const EdgeInsets.only(top: 8.0),
//           child: SvgPicture.asset(
//               height: 30,
//               color: selectedIndex == 1 ? Colors.black : Colors.grey.shade400,
//               'assets/icons/map_icon.svg',
//               semanticsLabel: 'A red up arrow'),
//         ),
//       ),
//       BottomNavigationBarItem(
//         icon: Padding(
//           padding: const EdgeInsets.only(top: 8.0),
//           child: SvgPicture.asset(
//               height: 30,
//               color: selectedIndex == 2 ? Colors.black : Colors.grey.shade400,
//               'assets/icons/profile_icon.svg',
//               semanticsLabel: 'A red up arrow'),
//         ),
//       ),
//     ];
//
//     return PlatformNavBar(
//       material: (_, __) => MaterialNavBarData(
//         showSelectedLabels: false,
//         showUnselectedLabels: false,
//         type: BottomNavigationBarType.fixed,
//         elevation: 1,
//       ),
//       cupertino: (context, platform) => CupertinoTabBarData(
//         activeColor: Colors.black,
//         inactiveColor: Colors.grey.shade400,
//         items: [
//           BottomNavigationBarItem(
//               icon: Padding(
//                 padding: const EdgeInsets.only(top: 4.0),
//                 child: SvgPicture.asset(
//                     height: 26,
//                     color: selectedIndex == 0
//                         ? Colors.black
//                         : Colors.grey.shade400,
//                     'assets/icons/home_icon.svg',
//                     semanticsLabel: 'A red up arrow'),
//               ),
//               label: 'Home'),
//           BottomNavigationBarItem(
//               icon: Padding(
//                 padding: const EdgeInsets.only(top: 4.0),
//                 child: SvgPicture.asset(
//                     height: 26,
//                     color: selectedIndex == 1
//                         ? Colors.black
//                         : Colors.grey.shade400,
//                     'assets/icons/map_icon.svg',
//                     semanticsLabel: 'A red up arrow'),
//               ),
//               label: 'Search'),
//           BottomNavigationBarItem(
//               icon: Padding(
//                 padding: const EdgeInsets.only(top: 4.0),
//                 child: SvgPicture.asset(
//                     height: 26,
//                     color: selectedIndex == 2
//                         ? Colors.black
//                         : Colors.grey.shade400,
//                     'assets/icons/profile_icon.svg',
//                     semanticsLabel: 'A red up arrow'),
//               ),
//               label: 'Profile'),
//           BottomNavigationBarItem(
//               icon: Padding(
//                 padding: const EdgeInsets.only(top: 4.0),
//                 child: SvgPicture.asset(
//                     height: 26,
//                     color: selectedIndex == 3
//                         ? Colors.black
//                         : Colors.grey.shade400,
//                     'assets/icons/prize_icon.svg',
//                     semanticsLabel: 'A red up arrow'),
//               ),
//               label: 'Profile'),
//         ],
//         border: const Border(
//           top: BorderSide(
//             color: CupertinoColors.systemGrey4,
//             width: 0.0, // One physical pixel.
//             style: BorderStyle.solid,
//           ),
//         ),
//       ),
//       backgroundColor: Colors.white,
//       currentIndex: selectedIndex,
//       itemChanged: onItemTapped,
//       items: [
//         BottomNavigationBarItem(
//             icon: Padding(
//               padding: const EdgeInsets.only(top: 4.0),
//               child: SvgPicture.asset(
//                   height: 26,
//                   color:
//                       selectedIndex == 0 ? Colors.black : Colors.grey.shade400,
//                   'assets/icons/home_icon.svg',
//                   semanticsLabel: 'A red up arrow'),
//             ),
//             label: 'Home'),
//         BottomNavigationBarItem(
//             icon: Padding(
//               padding: const EdgeInsets.only(top: 4.0),
//               child: SvgPicture.asset(
//                   height: 26,
//                   color:
//                       selectedIndex == 1 ? Colors.black : Colors.grey.shade400,
//                   'assets/icons/map_icon.svg',
//                   semanticsLabel: 'A red up arrow'),
//             ),
//             label: 'Search'),
//         BottomNavigationBarItem(
//             icon: Padding(
//               padding: const EdgeInsets.only(top: 4.0),
//               child: SvgPicture.asset(
//                   height: 26,
//                   color:
//                       selectedIndex == 2 ? Colors.black : Colors.grey.shade400,
//                   'assets/icons/profile_icon.svg',
//                   semanticsLabel: 'A red up arrow'),
//             ),
//             label: 'Profile'),
//         BottomNavigationBarItem(
//             icon: Padding(
//               padding: const EdgeInsets.only(top: 4.0),
//               child: SvgPicture.asset(
//                   height: 26,
//                   color:
//                       selectedIndex == 3 ? Colors.black : Colors.grey.shade400,
//                   'assets/icons/prize_icon.svg',
//                   semanticsLabel: 'A red up arrow'),
//             ),
//             label: 'Profile'),
//       ],
//     );
//   }
// }
