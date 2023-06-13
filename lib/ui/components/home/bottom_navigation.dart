import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../constants/constants.dart';
import '../components.dart';

class BottomNavigator extends StatelessWidget {
  const BottomNavigator(
      {Key? key, required this.index, required this.onChanged})
      : super(key: key);
  final int index;
  final Function(int) onChanged;
  @override
  Widget build(BuildContext context) {
    return EmptyCard(
      shadow: true,
      color: AppColors.white,
      verticalMargin: 0,
      horizontalMargin: 0,
      verticalPadding: 1.h,
      borderRadius: const BorderRadius.only(
          topRight: Radius.circular(25.0), topLeft: Radius.circular(25.0)),
      child: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: index,
        onTap: onChanged,
        backgroundColor: AppColors.white,
        elevation: 0,
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: BottomNavigationImage(
              image: AppAssets.kHomeIcon,
              isCurrentIndex: index == 0,
            ),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: BottomNavigationImage(
              image: AppAssets.kAppointmentIcon,
              isCurrentIndex: index == 1,
            ),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: BottomNavigationImage(
              image: AppAssets.kOfferIcon,
              isCurrentIndex: index == 2,
            ),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: BottomNavigationImage(
              image: AppAssets.kProfileIcon,
              isCurrentIndex: index == 3,
            ),
            label: '',
          ),
        ],
      ),
    );
  }
}
