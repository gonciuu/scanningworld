import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../data/remote/providers/auth_provider.dart';
import '../common/big_title.dart';
import 'active_coupon_card.dart';

class ActiveCouponsBottomSheet extends StatelessWidget {
  const ActiveCouponsBottomSheet({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final activeCoupons =
        context.read<AuthProvider>().user?.dateActiveCoupons ?? [];
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 32),
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(16),
          topRight: Radius.circular(16),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const BigTitle(
            text: 'Aktywne kupony',
          ),
          const SizedBox(
            height: 20,
          ),
          SizedBox(
            height: 250,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: activeCoupons.length,
              padding: const EdgeInsets.symmetric(horizontal: 24),
              itemBuilder: (context, i) {
                return Container(
                  margin: const EdgeInsets.only(right: 12),
                  width: 180,
                  child: ActiveCouponCard(
                      activeCoupon: activeCoupons[i],
                      heroPrefix: 'active-coupon'),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
