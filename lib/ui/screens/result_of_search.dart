import 'package:dorakpattient/data/models/response/offer_response.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

import '../../constants/constants.dart';
import '../../controllers/controllers.dart';
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
        child: Consumer<SearchResultController>(
          builder: (context, controller, child) {
            List<Doctor> doctorsList = controller.doctorsList;
            return controller.isLoading
                ? const LoadingWidget(
                    backgroundColor: AppColors.transparent,
                  )
                : ListView.separated(
                    itemCount: doctorsList.length,
                    itemBuilder: (context, index) {
                      Doctor model = doctorsList[index];
                      return DoctorWidget(
                        home: true,
                        model: model,
                      );
                    },
                    separatorBuilder: (BuildContext context, int index) {
                      return SizedBox(
                        height: 1.h,
                      );
                    },
                  );
          },
        ),
      ),
    );
  }
}
