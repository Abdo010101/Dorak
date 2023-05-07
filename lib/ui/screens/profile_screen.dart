import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../constants/constants.dart';
import '../../routes/dorak_routes.dart';
import '../../utis/util.dart';
import '../components/components.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.liteWight,
      body: EmptyCard(
        color: AppColors.transparent,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextBuilder(
              text: 'Welcome to Dorak',
              color: AppColors.navyBlue,
              verticalPadding: 2.h,
              bold: true,
            ),
            ListTileBuilder(
              title: 'User name',
              subTitle: '00123456789',
              trailing: 'example@mail.com',
              horizontalMargin: 0,
              verticalMargin: 1.h,
              onTap: () {},
            ),
            EmptyCard(
              verticalMargin: 1.h,
              horizontalMargin: 0,
              verticalPadding: 1.h,
              horizontalPadding: 5.w,
              color: AppColors.white,
              child: Column(
                children: [
                  RowMenuCard(
                    title: AppStrings.kFavorites.tr(),
                    icon: AppAssets.kFavoritesIcon,
                    onTap: () {
                      // Navigator.of(context).pushNamed(NameRoutes.kReviewScreen);
                    },
                  ),
                  RowMenuCard(
                    title: AppStrings.kSettings.tr(),
                    icon: AppAssets.kSettingIcon,
                    onTap: () {
                      // Navigator.of(context).pushNamed(NameRoutes.kSettingScreen);
                    },
                  ),
                  RowMenuCard(
                    title: AppStrings.kContactUs.tr(),
                    icon: AppAssets.kContactUsIcon,
                    onTap: () => Util.openWhatsapp(
                        context: context, phoneNumber: AppStrings.kPhoneNumber),
                  ),
                  RowMenuCard(
                    title: AppStrings.kAppReview.tr(),
                    icon: AppAssets.kAppReviewIcon,
                    divider: false,
                    onTap: () {
                      Navigator.of(context).pushNamed(NameRoutes.kAppReview);
                    },
                  ),
                ],
              ),
            ),
            Row(
              children: [
                const Spacer(),
                ElevatedButton.icon(
                  style: ButtonStyle(
                      elevation: MaterialStateProperty.all(0),
                      backgroundColor: MaterialStateProperty.all(
                        Colors.transparent,
                      )),
                  onPressed: () {},
                  icon: Icon(
                    Icons.login_rounded,
                    size: 15.sp,
                    color: AppColors.darkBlue,
                  ),
                  label: Text(
                    AppStrings.kLogout.tr(),
                    style: TextStyle(
                      fontSize: 10.sp,
                      color: AppColors.darkBlue,
                    ),
                  ),
                ),
              ],
            ),
            const DevelopedWidget()
          ],
        ),
      ),
    );
  }
}
