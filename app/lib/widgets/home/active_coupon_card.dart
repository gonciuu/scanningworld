import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:scanning_world/data/remote/models/coupon.dart';
import 'package:scanning_world/screens/order_coupon_screen.dart';
import 'package:scanning_world/widgets/common/white_wrapper.dart';
import '../common/cached_placeholder_image.dart';

class ActiveCouponCard extends StatelessWidget {
  final ActiveCoupon activeCoupon;
  final String heroPrefix;

  const ActiveCouponCard(
      {Key? key, required this.activeCoupon, required this.heroPrefix})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WhiteWrapper(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Hero(
              tag: '$heroPrefix-${activeCoupon.id}',
              child: CachedPlaceholderImage(
                imageUrl: activeCoupon.coupon.imageUri,
                height: 30,
                fit: BoxFit.scaleDown,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              activeCoupon.coupon.name,
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontWeight: FontWeight.w400,
                  fontSize: 16,
                  color: Colors.grey.shade900),
              maxLines: 4,
              overflow: TextOverflow.ellipsis,
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: PlatformElevatedButton(
                padding: const EdgeInsets.only(left: 8, right: 8),
                onPressed: () => Navigator.of(context)
                    .pushNamed(OrderCouponScreen.routeName, arguments: {
                  'coupon': activeCoupon,
                  'heroPrefix': heroPrefix,
                  "isActivated": true,
                }),
                child: FittedBox(
                  child: Text(
                    'Ważny do ${activeCoupon.formattedValidUntil}',
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
              ),
            )
          ],
        ));
  }
}
