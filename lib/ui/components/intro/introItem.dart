import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../components.dart';

class IntroItem extends StatelessWidget {
  const IntroItem({
    Key? key,
    required this.item,
  }) : super(key: key);

  final List<String> item;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 1.h, horizontal: 2.5.w),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          LogoIntroScreen(
            image: item[0],
          ),
          TitleIntroScreen(
            title: item[1],
          ),
          // SubtitleIntroScreen(
          //   subtitle: item[2],
          // ),
        ],
      ),
    );
  }
}
