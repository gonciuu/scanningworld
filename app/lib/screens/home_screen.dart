import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:scanning_world/theme/theme.dart';
import 'package:scanning_world/widgets/common/small_subtitle.dart';
import 'package:scanning_world/widgets/common/white_wrapper.dart';
import 'package:scanning_world/widgets/home/rewards_card.dart';

import '../widgets/common/big_title.dart';

class HomeScreen extends StatelessWidget {
  static const String routeName = '/home';

  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 36, 24, 36),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const BigTitle(text: 'Cześć, Maciej!'),
                      RichText(
                        text: TextSpan(
                          text: 'Masz ',
                          style: DefaultTextStyle.of(context)
                              .style
                              .copyWith(color: Colors.black, fontSize: 17),
                          children: const <TextSpan>[
                            TextSpan(
                                text: '142 punkty',
                                style: TextStyle(fontWeight: FontWeight.bold)),
                          ],
                        ),
                      )
                    ],
                  ),
                  CircleAvatar(
                    radius: 30,
                    backgroundColor: Colors.grey.shade200,
                    backgroundImage: const NetworkImage(
                        "https://cdn.pixabay.com/photo/2022/10/08/18/13/dog-7507541_960_720.jpg"),
                  ),
                ],
              ),
              const SizedBox(height: 32),
              WhiteWrapper(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: const [
                          BigTitle(text: '24/100'),
                          SmallSubtitle(text: "Zwiedzonych miejsc"),
                        ],
                      ),
                      const SizedBox(height: 6),
                      TweenAnimationBuilder<double>(
                        duration: const Duration(milliseconds: 1500),
                        curve: Curves.easeInOut,
                        tween: Tween<double>(
                          begin: 0,
                          end: 0.24,
                        ),
                        builder: (context, value, _) => LinearProgressIndicator(
                          value: value,
                          backgroundColor: primary[100],
                          valueColor:
                              AlwaysStoppedAnimation<Color>(primary[700]!),
                        ),
                      ),
                    ],
                  )),
              const SizedBox(height: 20),
              WhiteWrapper(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const BigTitle(
                      text: "Poznaj naszą gminę",
                      style: TextStyle(fontSize: 20),
                    ),
                    const SizedBox(height: 4),
                    const SmallSubtitle(
                        text:
                            "Znajduj kody QR w wyznaczonych na mapie miejscach i zdobywaj punkty"),
                    const SizedBox(height: 8),
                    PlatformElevatedButton(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                      child: const Text(
                        "Mapa kodów QR",
                        style: TextStyle(color: Colors.white),
                      ),
                      onPressed: () {},
                    )
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        BigTitle(text: "Nagrody"),
                        SmallSubtitle(
                          text: 'Wymieniaj punkty na nagrody',
                          style: TextStyle(fontSize: 13),
                        ),
                      ],
                    ),
                  ),
                  PlatformTextButton(
                    padding: EdgeInsets.zero,
                    child: const Text(
                      "Wszystkie",
                      style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w100,
                          letterSpacing: 0),
                    ),
                    onPressed: () {},
                  )
                ],
              ),
              const SizedBox(height: 16),
              MediaQuery.removePadding(
                context: context,
                removeTop: true,
                removeBottom: true,
                removeLeft:   true,
                removeRight:  true,
                child: SizedBox(
                  height: 250,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: 10,
                    itemBuilder: (context, index) => RewardCard(),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
