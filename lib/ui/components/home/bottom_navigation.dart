import 'package:flutter/material.dart';

import '../../../constants/constants.dart';
import '../components.dart';

class BottomNavigator extends StatelessWidget {
  const BottomNavigator({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: 0,
      backgroundColor: AppColors.white,
      elevation: 25,
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(
            icon: BottomNavigationImage(
              image: AppAssets.kHomeIcon,
              isCurrentIndex: false,
              imageType: ImageType.image,
            ),
            label: '',
            tooltip: 'fff'),
        BottomNavigationBarItem(
          icon: BottomNavigationImage(
              image: AppAssets.kAppointmentIcon,
              isCurrentIndex: true,
              imageType: ImageType.image),
          label: '',
        ),
        BottomNavigationBarItem(
          icon: BottomNavigationImage(
              image: AppAssets.kOfferIcon,
              isCurrentIndex: true,
              imageType: ImageType.image),
          label: '',
        ),
        BottomNavigationBarItem(
          icon: BottomNavigationImage(
              image: AppAssets.kProfileIcon,
              isCurrentIndex: true,
              imageType: ImageType.image),
          label: '',
        ),
      ],
    );
  }
}
