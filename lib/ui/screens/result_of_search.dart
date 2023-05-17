import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../constants/constants.dart';
import '../components/components.dart';

class ResultOfSearchScreen extends StatelessWidget {
  const ResultOfSearchScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.liteWight,
      appBar: const CustomAppBar(title: 'Specialties Name'),
      body: EmptyCard(
        color: AppColors.transparent,
        horizontalPadding: 0,
        verticalPadding: 0,
        verticalMargin: 0,
        child: ListView.separated(
          itemCount: 10,
          itemBuilder: (context, index) {
            return const DoctorWidget();
          },
          separatorBuilder: (BuildContext context, int index) {
            return SizedBox(
              height: 1.h,
            );
          },
        ),
      ),
    );
  }
}
