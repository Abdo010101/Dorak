import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../constants/constants.dart';
import '../../../data/models/response/response.dart';
import '../components.dart';

class OfferItemSelection extends StatelessWidget {
  const OfferItemSelection({
    super.key,
    required this.tittle,
    required this.items,
    required this.onSelect,
    required this.onClose,
  });
  final String tittle;
  final List<Titles?> items;
  final Function(int) onSelect;
  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            TextBuilder(
              text: tittle,
              color: AppColors.darkBlue,
              verticalPadding: 0.25.h,
              size: AppFontSizes.kS4,
            ),
            const Spacer(),
            InkWell(
              onTap: onClose,
              child: Icon(
                CupertinoIcons.chevron_down,
                color: AppColors.darkGray.withOpacity(0.75),
              ),
            ),
            SizedBox(
              width: 2.5.w,
            ),
          ],
        ),
        Row(
          children: [
            SizedBox(
              width: 80.w,
              child: ListView.builder(
                  itemCount: items.length,
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    return Row(
                      children: [
                        OfferCheckBox(
                            onChanged: (value) => onSelect(index),
                            value: items[index]?.icon == '1',
                            tittle: items[index]?.name ?? ''),
                      ],
                    );
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
