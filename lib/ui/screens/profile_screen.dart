import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

import '../../constants/constants.dart';
import '../../controllers/controllers.dart';
import '../../routes/dorak_routes.dart';
import '../../utis/helpers/app_providers.dart';
import '../../utis/util.dart';
import '../components/components.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final patient = Provider.of<AuthController>(context).currentUser?.patient;
    var authController = Provider.of<AuthController>(context, listen: false);

    return Scaffold(
      backgroundColor: AppColors.liteWight,
      body: EmptyCard(
        color: AppColors.transparent,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextBuilder(
              text: AppStrings.kWelcomeTitle.tr(),
              color: AppColors.navyBlue,
              verticalPadding: 2.h,
              bold: true,
            ),
            ListTileBuilder(
              title: patient?.name ?? '',
              subTitle: patient?.phone ?? '',
              trailing: patient?.email ?? '',
              horizontalMargin: 0,
              horizontalPadding: 5.w,
              verticalMargin: 1.h,
              onTap: () => Navigator.pushNamed(
                  context, NameRoutes.kProfileDetailsScreen),
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
                      // Navigator.of(context).pushNamed(NameRoutes.kAppReview);
                    },
                  ),
                  RowMenuCard(
                    title: AppStrings.kSettings.tr(),
                    icon: AppAssets.kSettingIcon,
                    onTap: () {
                      Navigator.of(context)
                          .pushNamed(NameRoutes.kSettingScreen);
                    },
                  ),
                  RowMenuCard(
                    title: AppStrings.kContactUs.tr(),
                    icon: AppAssets.kContactUsIcon,
                    onTap: () =>
                        Util.openWhatsapp(phoneNumber: AppStrings.kPhoneNumber),
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
                  onPressed: () {
                    AppProviders.disposeAllDisposableProviders(context);
                    authController.logout(context);
                    Navigator.pushNamedAndRemoveUntil(
                        context,
                        NameRoutes.kWelcomeScreen,
                        (Route<dynamic> route) => false);
                  },
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
