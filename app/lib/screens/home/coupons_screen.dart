import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:provider/provider.dart';
import 'package:scanning_world/data/remote/providers/auth_provider.dart';
import 'package:scanning_world/data/remote/providers/coupons_provider.dart';
import 'package:scanning_world/theme/theme.dart';
import 'package:scanning_world/widgets/common/big_title.dart';
import 'package:scanning_world/widgets/home/active_coupons_bottom_sheet.dart';
import 'package:scanning_world/widgets/home/rewards_card.dart';

class RewardsScreen extends StatelessWidget {
  const RewardsScreen({Key? key}) : super(key: key);

  void _showActiveCouponsBottomSheet(BuildContext context) =>
      showPlatformModalSheet(
        context: context,
        builder: (context) {
          return const ActiveCouponsBottomSheet();
        },
      );

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SizedBox(
          height: MediaQuery.of(context).size.height -
              MediaQuery.of(context).padding.top -
              MediaQuery.of(context).padding.bottom,
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(12, 28, 12, 64),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const BigTitle(text: 'Nagrody'),
                    Consumer<AuthProvider>(
                      builder: (context, authProvider, child) => RichText(
                        text: TextSpan(
                          text: 'Masz ',
                          style: DefaultTextStyle.of(context)
                              .style
                              .copyWith(color: Colors.black, fontSize: 17),
                          children: <TextSpan>[
                            TextSpan(
                                text:
                                    '${authProvider.user?.pointsInRegion ?? 0} punktów',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    decoration: TextDecoration.underline,
                                    decorationColor:
                                        primary[700]!.withOpacity(0.5),
                                    decorationThickness: 2,
                                    decorationStyle: TextDecorationStyle.wavy)),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 28),
                    Consumer<CouponsProvider>(
                      builder: (context, couponsProvider, child) {
                        final coupons = couponsProvider.coupons;
                        return coupons.isNotEmpty
                            ? GridView.builder(
                                gridDelegate:
                                    const SliverGridDelegateWithMaxCrossAxisExtent(
                                        maxCrossAxisExtent: 200,
                                        childAspectRatio: 3 / 4.1,
                                        crossAxisSpacing: 12,
                                        mainAxisSpacing: 12),
                                scrollDirection: Axis.vertical,
                                itemBuilder: (context, i) => RewardCard(
                                  coupon: coupons[i],
                                  heroPrefix: 'coupon',
                                ),
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: coupons.length,
                              )
                            : const Center(
                                child: Text('Brak dostępnych nagród 🙁'));
                      },
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
        Consumer<AuthProvider>(
          builder: (context, authProvider, child) {
            final activeCoupons = authProvider.user?.dateActiveCoupons ?? [];
            if (activeCoupons.isNotEmpty) {
              return child!;
            }
            return const SizedBox.shrink();
          },
          child: Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: GestureDetector(
                onTap: () => _showActiveCouponsBottomSheet(context),
                child: ClipRect(
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                    child: Container(
                        padding: const EdgeInsets.only(top: 16, bottom: 16),
                        color: Colors.white38,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              context.platformIcon(
                                  material: Icons.check_circle_outline,
                                  cupertino: CupertinoIcons.check_mark_circled),
                              color: Colors.green,
                              size: 28,
                            ),
                            const SizedBox(width: 8),
                            const Text(
                              'Aktywne nagrody',
                              style: TextStyle(fontSize: 18),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        )),
                  ),
                ),
              )),
        )
      ],
    );
  }
}
