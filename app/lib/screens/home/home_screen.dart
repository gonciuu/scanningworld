import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:provider/provider.dart';
import 'package:scanning_world/data/remote/providers/auth_provider.dart';
import 'package:scanning_world/theme/theme.dart';
import 'package:scanning_world/widgets/common/small_subtitle.dart';
import 'package:scanning_world/widgets/common/white_wrapper.dart';
import 'package:scanning_world/widgets/home/rewards_card.dart';

import '../../data/remote/models/user/user.dart';
import '../../widgets/common/big_title.dart';

class HomeScreen extends StatelessWidget {
  static const String routeName = '/home';

  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final User? user = context.watch<AuthProvider>().user;
    return Stack(
      children: [
        SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(24, 36, 24, 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            BigTitle(
                                text: 'Cześć, ${user?.name ?? 'Użytkowniku'}!',style: const TextStyle(fontSize: 22),),
                            RichText(
                              text: TextSpan(
                                text: 'Masz ',
                                style: DefaultTextStyle.of(context)
                                    .style
                                    .copyWith(color: Colors.black, fontSize: 17),
                                children: const <TextSpan>[
                                  TextSpan(
                                      text: '142 punkty',
                                      style:
                                          TextStyle(fontWeight: FontWeight.bold)),
                                ],

                              ),
                            )
                          ],
                        ),
                      ),
                      CircleAvatar(
                        radius: 30,
                        backgroundColor: Colors.grey.shade200,
                        backgroundImage: const NetworkImage(
                            "https://cdn.pixabay.com/photo/2022/10/08/18/13/dog-7507541_960_720.jpg"),
                      ),
                    ],
                  ),
                ),
                WhiteWrapper(
                    margin: const EdgeInsets.fromLTRB(24, 16, 24, 8),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 16),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            BigTitle(
                                text:
                                    "${user != null ? user.scannedPlaces.length : 0}/100"),
                            const SmallSubtitle(text: "Zwiedzonych miejsc"),
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
                          builder: (context, value, _) =>
                              LinearProgressIndicator(
                            value: value,
                            backgroundColor: primary[100],
                            valueColor:
                                AlwaysStoppedAnimation<Color>(primary[700]!),
                          ),
                        ),
                      ],
                    )),
                WhiteWrapper(
                  margin: const EdgeInsets.fromLTRB(24, 8, 24, 8),
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
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Row(
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
                ),
                const SizedBox(height: 12),
                SizedBox(
                  height: 240,
                  child: ListView.builder(
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    scrollDirection: Axis.horizontal,
                    itemCount: 10,
                    itemBuilder: (context, index) => const RewardCard(),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 24, 20, 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const BigTitle(text: "Zostań partnerem"),
                      const SmallSubtitle(
                        text:
                            'Chcesz, aby twoja firma znalazła się w naszej aplikacji? Skontaktuj się klikając poniższy przycisk.',
                        style: TextStyle(fontSize: 13),
                      ),
                      Container(
                        width: double.infinity,
                        margin: const EdgeInsets.only(top: 16, bottom: 20),
                        child: PlatformElevatedButton(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          child: const Text(
                            "Zostań partnerem",
                            style: TextStyle(color: Colors.white),
                          ),
                          onPressed: () {},
                        ),
                      ),
                      const Center(
                        child: SmallSubtitle(
                          text: 'lub napisz maila na adres:',
                          style: TextStyle(fontSize: 13),
                        ),
                      ),
                      Container(
                        width: double.infinity,
                        margin: const EdgeInsets.only(top: 4),
                        child: PlatformTextButton(
                            onPressed: () {},
                            padding: EdgeInsets.zero,
                            child: const Text(
                              "xyz@gmail.com",
                              textAlign: TextAlign.center,
                              style: TextStyle(fontWeight: FontWeight.bold),
                            )),
                      )
                    ],
                  ),
                ),
                const SizedBox(height: 64),
              ],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: Align(
              alignment: Alignment.bottomCenter,
              child: SizedBox(
                width: 65,
                height: 65,
                child: PlatformElevatedButton(
                  cupertino: (_, __) => CupertinoElevatedButtonData(
                    borderRadius: BorderRadius.circular(50),
                  ),
                  material: (_, __) => MaterialElevatedButtonData(
                    style: ButtonStyle(
                      fixedSize:
                          MaterialStateProperty.all(const Size.square(65)),
                      backgroundColor: MaterialStateProperty.all(primary[700]),
                      shape: MaterialStateProperty.all(
                        const CircleBorder(),
                      ),
                    ),
                  ),
                  color: primary[700],
                  padding: EdgeInsets.zero,
                  onPressed: () {
                    debugPrint("Scan QR");
                  },
                  child: Platform.isIOS
                      ? const Icon(
                          CupertinoIcons.qrcode_viewfinder,
                          color: Colors.white,
                          size: 40,
                        )
                      : const Icon(
                          Icons.qr_code_scanner_rounded,
                          color: Colors.white,
                          size: 35,
                        ),
                ),
              )),
        ),
      ],
    );
  }
}
