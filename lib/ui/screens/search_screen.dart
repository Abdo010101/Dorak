import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../constants/constants.dart';
import '../components/components.dart';

class SearchScreen extends StatelessWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.liteWight,
        elevation: 0,
        leadingWidth: 40.w,
        leading: Row(
          children: [
            IconButton(
              onPressed: () => Navigator.pop(context),
              icon: const Icon(
                Icons.arrow_back_ios_new,
                color: AppColors.blue,
              ),
            ),
            TextBuilder(
              text: 'Specialties',
              color: AppColors.navyBlue,
              verticalPadding: 2.h,
              bold: true,
            ),
          ],
        ),
      ),
      body: EmptyCard(
        color: AppColors.transparent,
        verticalPadding: 0,
        verticalMargin: 1.h,
        horizontalMargin: 4.w,
        child: EmptyCard(
          verticalMargin: 1.h,
          horizontalMargin: 0,
          verticalPadding: 1.h,
          color: AppColors.white,
          height: 45.h,
          child: Column(
            children: [
              TextBuilder(
                text: 'Most Popular Specialties',
                color: AppColors.navyBlue,
                verticalPadding: 2.h,
                bold: true,
              ),
              TextFormFieldBuilder(
                hint: 'Full Name',
              ),
              TextFormFieldBuilder(
                hint: '00123456789',
              ),
              TextFormFieldBuilder(
                hint: 'example@mail.com',
              ),
              DropDownBuilder(
                hint: 'Gender',
                value: 'meal',
                items: const ['meal', 'female'],
                isReport: true,
                onChanged: (value) {},
              )
            ],
          ),
        ),
      ),
    );
  }
}
