import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';

class SettingsRow extends StatelessWidget {
  final String text;
  final IconData icon;
  final Function()? onTap;
  final bool canGoNext; //if true, show arrow icon
  final bool isRed; //if true, show red color

  const SettingsRow({
    Key? key,
    required this.text,
    required this.icon,
    this.onTap,
    this.canGoNext = true,
    this.isRed = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PlatformElevatedButton(
      onPressed: onTap,
      material: (_, __) => MaterialElevatedButtonData(
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(Colors.white),
          elevation: MaterialStateProperty.all(0),
          padding: MaterialStateProperty.all(
              const EdgeInsets.symmetric(horizontal: 16, vertical: 12)),
        ),
      ),
      color: Colors.white,
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      child: Row(
        children: [
          Icon(icon, color: isRed ? Colors.redAccent : Colors.black, size: 28),
          const SizedBox(width: 12),
          Expanded(
            child: Text(text,
                style:  TextStyle(
                  color: isRed ? Colors.redAccent : Colors.black,
                  fontSize: 18,
                )),
          ),
          if (canGoNext)
            Icon(
              context.platformIcon(
                material: Icons.arrow_forward_ios,
                cupertino: CupertinoIcons.forward,
              ),
              color: Colors.black,
              size: 24,
            ),
        ],
      ),
    );
  }
}
