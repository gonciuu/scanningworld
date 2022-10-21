import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:scanning_world/screens/order_coupon_screen.dart';

import '../common/custom_progress_indicator.dart';

class OrderCouponBottomSheet extends StatelessWidget {
  final OrderState orderState;
  final Function() onOrderCoupon;

  const OrderCouponBottomSheet({
    Key? key,
    required this.orderState,
    required this.onOrderCoupon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(16),
          topRight: Radius.circular(16),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(),
          const Text(
            'Zlealizuj kupon',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
          const Text(
            'Ważny 15 minut',
            style: TextStyle(fontSize: 14),
          ),
          const SizedBox(height: 12),
          AnimatedScale(
            scale: orderState == OrderState.loading ||
                    orderState == OrderState.active
                ? 1.2
                : 1,
            duration: const Duration(milliseconds: 300),
            child: AnimatedRotation(
              turns: orderState == OrderState.loading ? 1 : 0,
              duration: const Duration(milliseconds: 300),
              child: Icon(
                context.platformIcon(
                    material: orderState == OrderState.loading ||
                            orderState == OrderState.active
                        ? Icons.check_circle
                        : Icons.check_circle_outline,
                    cupertino: orderState == OrderState.loading ||
                            orderState == OrderState.active
                        ? CupertinoIcons.check_mark_circled_solid
                        : CupertinoIcons.check_mark_circled),
                color: Colors.green,
                size: 64,
              ),
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: PlatformElevatedButton(
                onPressed:
                    orderState == OrderState.loading ? null : onOrderCoupon,
                child: orderState == OrderState.loading
                    ? const CustomProgressIndicator()
                    : const Text(
                        'Odbierz',
                        style: TextStyle(color: Colors.white),
                      )),
          ),
          SizedBox(
            width: double.infinity,
            child: PlatformTextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Anuluj'),
            ),
          ),
        ],
      ),
    );
  }
}
