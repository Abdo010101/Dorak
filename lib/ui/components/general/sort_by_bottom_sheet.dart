import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

import '../../../constants/constants.dart';
import '../../../controllers/controllers.dart';
import '../components.dart';

class SortByBottomSheet extends StatelessWidget {
  const SortByBottomSheet({
    Key? key,
    this.filterType,
  }) : super(key: key);
  final String? filterType;

  @override
  Widget build(BuildContext context) {
    GeneralController generalController =
        Provider.of<GeneralController>(context, listen: false);
    return Consumer<FilterController>(
      builder: (context, controller, child) {
        return BottomSheetBuilder(
          backgroundColor: AppColors.white,
          crossAlignment: CrossAxisAlignment.start,
          height: 55.h,
          containerHeight: 50.h,
          children: [
            Row(
              children: [
                TextBuilder(
                  text: AppStrings.kSortBy.tr(),
                  color: AppColors.darkBlue,
                  bold: true,
                  size: AppFontSizes.kS5,
                  verticalPadding: 0,
                ),
                const Spacer(),
                InkWell(
                  onTap: controller.resetData,
                  child: TextBuilder(
                    text: AppStrings.kReset.tr(),
                    color: AppColors.blue,
                    underline: true,
                  ),
                ),
              ],
            ),
            RadioListTile(
              title: Text(AppStrings.kSortByList[0].tr()),
              value: AppStrings.kSortByList[0],
              activeColor: AppColors.blue,
              groupValue: controller.arrangeBy,
              onChanged: controller.changeArrangeBy,
            ),
            RadioListTile(
              title: Text(AppStrings.kSortByList[1].tr()),
              value: AppStrings.kSortByList[1],
              activeColor: AppColors.blue,
              groupValue: controller.arrangeBy,
              onChanged: controller.changeArrangeBy,
            ),
            RadioListTile(
              title: Text(AppStrings.kSortByList[2].tr()),
              value: AppStrings.kSortByList[2],
              activeColor: AppColors.blue,
              groupValue: controller.arrangeBy,
              onChanged: controller.changeArrangeBy,
            ),
            RadioListTile(
              title: Text(AppStrings.kSortByList[3].tr()),
              value: AppStrings.kSortByList[3],
              activeColor: AppColors.blue,
              groupValue: controller.arrangeBy,
              onChanged: controller.changeArrangeBy,
            ),
            ButtonBuilder(
              radius: 25,
              buttonColor: AppColors.blue,
              title: AppStrings.kApplyFilter.tr(),
              margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.5.h),
              width: 90.w,
              height: 6.5.h,
              onPressed: () async {
                Navigator.pop(context);
                filterType == 'Offer'
                    ? controller.filterOffer(context)
                    : controller.filterDoctors(
                        context,
                        lng: generalController.lng,
                        lat: generalController.lat,
                        /*cityId: generalController.cityId,
                        areaId: generalController.areaId*/
                      );
                if (filterType == 'Offer') {
                  context.read<OffersController>().pagingController?.refresh();
                } else {
                  context
                      .read<SearchResultController>()
                      .pagingController
                      ?.refresh();
                }
              },
            ),
          ],
        );
      },
    );
  }
}
