import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:scanning_world/theme/theme.dart';
import 'package:scanning_world/widgets/common/big_title.dart';
import 'package:scanning_world/widgets/home/rewards_card.dart';

class RewardsScreen extends StatelessWidget {
  const RewardsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(),
              const BigTitle(text: 'Nagrody'),
              RichText(
                text: TextSpan(
                  text: 'Masz ',
                  style: DefaultTextStyle.of(context)
                      .style
                      .copyWith(color: Colors.black, fontSize: 17),
                  children: <TextSpan>[
                    TextSpan(
                        text: '142 punkty',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            decoration: TextDecoration.underline,
                            decorationColor: primary[700]!.withOpacity(0.5),
                            decorationThickness: 2,
                            decorationStyle: TextDecorationStyle.wavy)),
                  ],
                ),
              ),
              const SizedBox(height: 28),
              GridView.builder(
                gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                    maxCrossAxisExtent: 200,
                    childAspectRatio: 3 / 4,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16),
                scrollDirection: Axis.vertical,
                itemBuilder: (context, i) =>
                    const RewardCard(),
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: 20,
              )
            ],
          ),
        ),
      ),
    );
  }
}
