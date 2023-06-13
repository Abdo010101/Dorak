import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:sizer/sizer.dart';

class RatingBarWidget extends StatelessWidget {
  const RatingBarWidget({
    Key? key,
    this.initialRating,
    this.itemSize,
    this.ignoreGesture = true,
    this.onRateUpdate,
  }) : super(key: key);
  final double? initialRating;
  final double? itemSize;
  final bool ignoreGesture;
  final Function(double)? onRateUpdate;
  @override
  Widget build(BuildContext context) {
    return RatingBar.builder(
        initialRating: initialRating ?? 4,
        minRating: 1,
        ignoreGestures: ignoreGesture,
        direction: Axis.horizontal,
        allowHalfRating: true,
        itemCount: 5,
        itemSize: itemSize ?? 10.sp,
        itemPadding: const EdgeInsets.symmetric(horizontal: 1.0),
        itemBuilder: (context, _) => const Icon(
              Icons.star,
              color: Colors.amber,
            ),
        onRatingUpdate: onRateUpdate ?? (_) {});
  }
}
