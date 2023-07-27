import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

import '../../../constants/constants.dart';
import '../../../controllers/controllers.dart';
import '../components.dart';

class FilterBottomSheet extends StatelessWidget {
  const FilterBottomSheet({
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
          height: 110.h,
          children: [
            Row(
              children: [
                TextBuilder(
                  text: AppStrings.kFilterBy.tr(),
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
            Visibility(
              visible: controller.specialtyMainToggle,
              replacement: OfferDropDown(
                  tittle: AppStrings.kMainSpecialty.tr(),
                  onPressed: () {
                    controller.openMainSpecialty();
                  }),
              child: OfferItemSelection(
                tittle: AppStrings.kMainSpecialty.tr(),
                items: controller.mainSpecialtyList,
                onSelect: (value) async {
                  controller.mainSpecialtySelect(value);
                  if (controller.subSpecialtyList.isEmpty) {
                    await generalController.getSubSpeciality(controller
                        .mainSpecialtyList[controller.mainSpecialtyIndex!].id!);
                    EasyLoading.dismiss();
                    controller.openMainSpecialty();
                    controller.openSubSpecialty();
                    controller.subSpecialtyList =
                        generalController.subSpecializationList;
                  }
                },
                onClose: controller.openMainSpecialty,
              ),
            ),
            controller.mainSpecialtyIndex == null ||
                    controller.subSpecialtyList.isEmpty
                ? const SizedBox()
                : Visibility(
                    visible: controller.subSpecialtyToggle,
                    replacement: OfferDropDown(
                      tittle: AppStrings.kSubSpecialties.tr(),
                      onPressed: () async {
                        if (controller.subSpecialtyList.isEmpty) {
                          EasyLoading.show();
                          await generalController.getSubSpeciality(controller
                              .mainSpecialtyList[controller.mainSpecialtyIndex!]
                              .id!);
                          EasyLoading.dismiss();
                          controller.subSpecialtyList =
                              generalController.subSpecializationList;
                        }
                        controller.openSubSpecialty();
                      },
                    ),
                    child: OfferItemSelection(
                      tittle: AppStrings.kSubSpecialties.tr(),
                      items: controller.subSpecialtyList,
                      onSelect: controller.subSpecialtySelect,
                      onClose: controller.openSubSpecialty,
                    ),
                  ),
            Visibility(
              visible: controller.availabilityToggle,
              replacement: OfferDropDown(
                  tittle: AppStrings.kAvailability.tr(),
                  onPressed: controller.openAvailability),
              child: OfferItemSelection(
                tittle: AppStrings.kAvailability.tr(),
                items: controller.availabilityList,
                onSelect: controller.availabilitySelect,
                onClose: controller.openAvailability,
              ),
            ),
            Visibility(
              visible: controller.genderToggle,
              replacement: OfferDropDown(
                  tittle: AppStrings.kGender.tr(),
                  onPressed: controller.openGender),
              child: OfferItemSelection(
                tittle: AppStrings.kGender.tr(),
                items: controller.genderList,
                onSelect: controller.genderSelect,
                onClose: controller.openGender,
              ),
            ),
            Visibility(
              visible: controller.titleToggle,
              replacement: OfferDropDown(
                  tittle: AppStrings.kTitle.tr(),
                  onPressed: controller.openTitle),
              child: OfferItemSelection(
                tittle: AppStrings.kTitle.tr(),
                items: controller.titlesList,
                onSelect: controller.tittleSelect,
                onClose: controller.openTitle,
              ),
            ),
            SizedBox(
              height: 2.h,
            ),
            controller.minPrice == null || controller.maxPrice == null
                ? const SizedBox()
                : SliderTheme(
                    data: SliderThemeData(
                      trackHeight: 2,
                      activeTrackColor: AppColors.blue,
                      inactiveTrackColor: AppColors.blue.withOpacity(0.25),
                      thumbColor: AppColors.white,
                    ),
                    child: RangeSlider(
                      values: controller.currentRangeValues!,
                      labels: RangeLabels(
                          '${controller.currentRangeValues!.start}',
                          '${controller.currentRangeValues!.start}'),
                      onChanged: controller.changeRange,
                      min: double.parse(controller.minPrice!),
                      max: double.parse(controller.maxPrice!),
                    ),
                  ),
            controller.minPrice == null || controller.maxPrice == null
                ? const SizedBox()
                : Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextBuilder(
                        text:
                            '${AppStrings.kCurrency.tr()} ${controller.currentRangeValues?.start.toInt()} ',
                        horizontalPadding: 2.5.w,
                      ),
                      TextBuilder(
                        text:
                            '${AppStrings.kCurrency.tr()} ${controller.currentRangeValues?.end.toInt()} ',
                        horizontalPadding: 2.5.w,
                      ),
                    ],
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
                  await context
                      .read<OffersController>()
                      .startPagingControllerListener(home: false);
                }
              },
            ),
          ],
        );
      },
    );
  }
}
