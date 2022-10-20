import 'dart:async';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:provider/provider.dart';
import 'package:scanning_world/data/remote/providers/auth_provider.dart';
import 'package:scanning_world/data/remote/providers/regions_provider.dart';
import 'package:scanning_world/screens/scan_qr_code_screen.dart';
import 'package:scanning_world/theme/theme.dart';
import 'package:scanning_world/utils/helpers.dart';
import 'package:scanning_world/widgets/common/small_subtitle.dart';
import 'package:scanning_world/widgets/common/white_wrapper.dart';
import 'package:scanning_world/widgets/home/rewards_card.dart';

import '../../data/remote/models/user/user.dart';
import '../../data/remote/providers/coupons_provider.dart';
import '../../widgets/common/big_title.dart';
import '../../widgets/common/custom_progress_indicator.dart';

class HomeScreen extends StatelessWidget {
  static const String routeName = '/home';
  final Function navigateToTab;

  const HomeScreen({Key? key, required this.navigateToTab}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final User? user = context.watch<AuthProvider>().user;

    final tooltipKey = GlobalKey<State<Tooltip>>();

    void showTooltip() {
      final tooltip = tooltipKey.currentState as TooltipState;
      tooltip.ensureTooltipVisible();
      Timer(const Duration(seconds: 2), () => tooltip.deactivate());
    }

    final email = user?.region.email ?? 'xyz@gmail.com';

    double scannedPlacesPercent =
        (user?.scannedPlacesFromRegion ?? 0).toDouble() /
            (user?.region.placeCount ?? 1).toDouble();

    if (scannedPlacesPercent.isNaN || scannedPlacesPercent.isInfinite) {
      scannedPlacesPercent = 0;
    }

    return PlatformScaffold(
      body: Stack(
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
                                text: 'Cześć, ${user?.name ?? 'Użytkowniku'}!',
                                style: const TextStyle(fontSize: 22),
                              ),
                              RichText(
                                text: TextSpan(
                                  text: 'Masz ',
                                  style: DefaultTextStyle.of(context)
                                      .style
                                      .copyWith(
                                          color: Colors.black, fontSize: 17),
                                  children: <TextSpan>[
                                    TextSpan(
                                        text:
                                            '${user?.pointsInRegion ?? 0} punktów',
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold)),
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                        GestureDetector(
                          onTap: () => navigateToTab(3),
                          child: CircleAvatar(
                            radius: 30,
                            backgroundColor: Colors.grey.shade200,
                            backgroundImage: AssetImage(user != null
                                ? 'assets/avatars/${user.avatar}.png'
                                : 'assets/avatars/male2.png'),
                          ),
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
                                      "${user != null ? user.scannedPlacesFromRegion : 0}/${user?.region.placeCount ?? 0}"),
                              const SmallSubtitle(text: "Zwiedzonych miejsc"),
                            ],
                          ),
                          const SizedBox(height: 6),
                          TweenAnimationBuilder<double>(
                            duration: const Duration(milliseconds: 1500),
                            curve: Curves.easeInOut,
                            tween: Tween<double>(
                                begin: 0, end: scannedPlacesPercent),
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
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 16),
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
                          onPressed: () => navigateToTab(2),
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
                          onPressed: () => navigateToTab(1),
                        )
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  Consumer<CouponsProvider>(
                    builder: (context, couponsProvider, child) {
                      final coupons = couponsProvider.coupons.take(6).toList();
                      return coupons.isNotEmpty
                          ? SizedBox(
                              height: 240,
                              child: ListView.builder(
                                physics: const BouncingScrollPhysics(),
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 24),
                                scrollDirection: Axis.horizontal,
                                itemCount: coupons.length,
                                itemBuilder: (context, index) => Container(
                                  margin: const EdgeInsets.only(right: 16),
                                  width: 180,
                                  child: RewardCard(
                                      coupon: coupons[index],
                                      heroPrefix: 'home-coupon'),
                                ),
                              ),
                            )
                          : const Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 8),
                              child: Center(
                                  child: Text(
                                "Brak dostępnych nagród 🙁",
                                textAlign: TextAlign.center,
                              )),
                            );
                    },
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
                            onPressed: () async {
                              try {
                                await sendEmail(
                                    email,
                                    'Chciałbym aby moja firma znalazła się w aplikacji',
                                    'Witam,\n\nChciałbym aby moja firma znalazła się w aplikacji. Proszę o kontakt.\n\nPozdrawiam,\n\n');
                              } catch (e) {
                                showTooltip();
                              }
                            },
                          ),
                        ),
                        const Center(
                          child: SmallSubtitle(
                            text: 'lub napisz maila na adres:',
                            style: TextStyle(fontSize: 13),
                          ),
                        ),
                        Tooltip(
                          key: tooltipKey,
                          preferBelow: true,
                          message: 'Email skopiowany do schowka',
                          child: Container(
                            width: double.infinity,
                            margin: const EdgeInsets.only(top: 4),
                            child: PlatformTextButton(
                                onPressed: () {
                                  Clipboard.setData(ClipboardData(text: email));
                                  showTooltip();
                                },
                                padding: EdgeInsets.zero,
                                child: Text(
                                  email,
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold),
                                )),
                          ),
                        ),
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
                        backgroundColor:
                            MaterialStateProperty.all(primary[700]),
                        shape: MaterialStateProperty.all(
                          const CircleBorder(),
                        ),
                      ),
                    ),
                    color: primary[700],
                    padding: EdgeInsets.zero,
                    onPressed: () {
                      Navigator.of(context)
                          .pushNamed(ScanQrCodeScreen.routeName);
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
      ),
    );
  }
}
