import 'package:flutter/material.dart';

import '../../../constants/constants.dart';
import '../components.dart';

class BottomNavigator extends StatelessWidget {
  const BottomNavigator({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: 1,
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
        ),
        BottomNavigationBarItem(
          icon: BottomNavigationImage(
              image: AppAssets.kAppointmentIcon,
              isCurrentIndex: true,
              imageType: ImageType.svg),
          label: '',
        ),
        BottomNavigationBarItem(
          icon: BottomNavigationImage(
              image: AppAssets.kOfferIcon,
              isCurrentIndex: true,
              imageType: ImageType.svg),
          label: '',
        ),
        BottomNavigationBarItem(
          icon: BottomNavigationImage(
              image: AppAssets.kProfileIcon,
              isCurrentIndex: true,
              imageType: ImageType.svg),
          label: '',
        ),
      ],
    );
    //
    //   StyleProvider(
    //   style: Style(),
    //   child: ConvexAppBar(
    //     style: TabStyle.fixed,
    //     // activeColor: primaryColor,
    //     color: const Color(0xffd3d3d3),
    //     items: [
    //       TabItem(
    //           icon: Image.asset(
    //             AppAssets.kHomeIcon,
    //             color: AppColors.blue,
    //             // : AppColors.grey,
    //           ),
    //           title: " "),
    //       const TabItem(
    //           icon: BottomNavigationImage(
    //               image: AppAssets.kOfferIcon, isCurrentIndex: true),
    //           title: " "),
    //       const TabItem(
    //           icon: BottomNavigationImage(
    //               image: AppAssets.kAppointmentIcon,
    //               isCurrentIndex: true,
    //               isAppointment: true),
    //           title: " "),
    //       const TabItem(
    //           icon: BottomNavigationImage(
    //               image: AppAssets.kReportIcon, isCurrentIndex: true),
    //           title: " "),
    //       const TabItem(
    //           icon: BottomNavigationImage(
    //               image: AppAssets.kProfileIcon, isCurrentIndex: true),
    //           title: " "),
    //     ],
    //     initialActiveIndex: 0,
    //     cornerRadius: 0,
    //     height: 9.h,
    //     curveSize: 100,
    //     top: -25,
    //     onTap: (index) => () {},
    //     backgroundColor: AppColors.white,
    //   ),
    // );
  }
}
