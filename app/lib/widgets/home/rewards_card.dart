import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:scanning_world/data/remote/models/coupon.dart';
import 'package:scanning_world/widgets/common/white_wrapper.dart';

class RewardCard extends StatelessWidget {

  final Coupon coupon;

  const RewardCard({Key? key,required this.coupon}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WhiteWrapper(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Image.network(coupon.imageUri,fit: BoxFit.fill,),
            const SizedBox(height: 8),
            Text(
                coupon.name,
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: 16,
                    color: Colors.grey.shade900),maxLines: 4, overflow: TextOverflow.ellipsis,),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: PlatformElevatedButton(
                padding: const EdgeInsets.only(left: 8,right: 8),
                child:  FittedBox(
                  child: Text(
                    '${coupon.points} punktów',
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
                onPressed: () {},
              ),
            )
          ],
        ));
  }
}
