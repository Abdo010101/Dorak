import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../constants/constants.dart';
import '../components.dart';

class BottomNavigator extends StatelessWidget {
  const BottomNavigator({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return EmptyCard(
      color: AppColors.white,
      verticalMargin: 0,
      horizontalMargin: 0,
      verticalPadding: 1.h,
      borderRadius: const BorderRadius.only(
          topRight: Radius.circular(25.0), topLeft: Radius.circular(25.0)),
      child: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: 1,
        backgroundColor: AppColors.white,
        elevation: 0,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: BottomNavigationImage(
              image: AppAssets.kHomeIcon,
              isCurrentIndex: false,
            ),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: BottomNavigationImage(
              image: AppAssets.kAppointmentIcon,
              isCurrentIndex: false,
            ),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: BottomNavigationImage(
              image: AppAssets.kOfferIcon,
              isCurrentIndex: false,
            ),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: BottomNavigationImage(
              image: AppAssets.kProfileIcon,
              isCurrentIndex: false,
            ),
            label: '',
          ),
        ],
      ),
    );
  }
}
