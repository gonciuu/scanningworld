import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:scanning_world/widgets/common/white_wrapper.dart';

class RewardCard extends StatelessWidget {


  const RewardCard({Key? key}) : super(key: key);



  @override
  Widget build(BuildContext context) {
    return WhiteWrapper(
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
                padding: EdgeInsets.only(left: 8,right: 8),
                child: const FittedBox(
                  child: Text(
                    '100 punktów',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                onPressed: () {},
              ),
            )
          ],
        ));
  }
}
