import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:scanning_world/widgets/common/white_wrapper.dart';

class RewardCard extends StatelessWidget {
  const RewardCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        width: 180,
        margin: const EdgeInsets.only(right: 16),
        child: WhiteWrapper(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                SvgPicture.asset('assets/sample_logo.svg'),
                const SizedBox(height: 8),
                Text(
                    'Darmowa wejściówka na basen',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: 16,
                        color: Colors.grey.shade900),maxLines: 4, overflow: TextOverflow.ellipsis,),
                const Spacer(),
                SizedBox(
                  width: double.infinity,
                  child: PlatformElevatedButton(
                    padding: EdgeInsets.zero,
                    child: const Text(
                      'Zobacz',
                      style: TextStyle(color: Colors.white),
                    ),
                    onPressed: () {},
                  ),
                )
              ],
            )));
  }
}
