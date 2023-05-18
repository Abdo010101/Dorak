import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../constants/constants.dart';
import '../../components/components.dart';

class SearchForCityScreen extends StatelessWidget {
  const SearchForCityScreen({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.liteWight,
      appBar: const CustomAppBar(title: 'Specialties'),
      body: EmptyCard(
        color: AppColors.transparent,
        verticalPadding: 0,
        verticalMargin: 1.h,
        horizontalPadding: 0,
        horizontalMargin: 4.w,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextFormFieldBuilder(
              hint: 'Search for a city',
              verticalMargin: 0,
              horizontalMargin: 0,
              maxLines: 3,
              width: 100.w,
              height: 7.5.h,
              padding: EdgeInsets.only(right: 2.5.w, left: 2.5.w, top: 5.h),
              borderRadius: 15,
              prefixIcon: const Icon(
                Icons.search,
                color: AppColors.gray,
              ),
              color: AppColors.white,
            ),
            SizedBox(
              height: 0.5.h,
            ),
            TextBuilder(
              text: 'Choose the city',
              color: AppColors.navyBlue,
              bold: true,
              verticalPadding: 1.5.h,
              horizontalPadding: 0,
            ),
            const CityWidget(
              cityName: 'Current Location',
              color: AppColors.blue,
              bold: true,
            ),
            const CityWidget(
              cityName: 'All cities',
              color: AppColors.blue,
            ),
            Expanded(
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: 12,
                scrollDirection: Axis.vertical,
                itemBuilder: (context, index) {
                  return const CityWidget(
                    cityName: 'City name',
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
