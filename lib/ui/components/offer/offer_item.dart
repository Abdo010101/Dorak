import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../constants/constants.dart';
import '../components.dart';

class OfferItemSelection extends StatelessWidget {
  const OfferItemSelection({
    super.key,
    required this.tittle,
    required this.items,
    required this.itemChosen,
  });
  final String tittle;
  final String itemChosen;
  final List<String> items;
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextBuilder(
          text: tittle,
          color: AppColors.darkBlue,
          verticalPadding: 0.25.h,
        ),
        Row(
          children: [
            Container(
              margin: EdgeInsetsDirectional.only(start: 4.w),
              width: 0.5.w,
              height: 12.5.h,
              color: AppColors.blue,
            ),
            SizedBox(
              width: 80.w,
              child: ListView.builder(
                  itemCount: items.length,
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    return OfferCheckBox(
                        onChanged: (value) {},
                        value: itemChosen == items[index],
                        tittle: items[index]);
                  }),
            )
          ],
        ),
        DividerBuilder(
          dividerColor: AppColors.darkGray.withOpacity(0.45),
          thickness: 0.15.h,
          width: 95.w,
        ),
      ],
    );
  }
}
