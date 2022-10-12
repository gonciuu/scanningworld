import 'package:flutter/material.dart';
import 'package:scanning_world/widgets/common/white_wrapper.dart';

class RewardCard extends StatelessWidget {
  const RewardCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        width: 170,
        margin: EdgeInsets.only(right: 16),
        child: WhiteWrapper(child: Container()));
  }
}
