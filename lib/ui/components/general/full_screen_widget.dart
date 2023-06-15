import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg_image/flutter_svg_image.dart';
import 'package:full_screen_image/full_screen_image.dart';
import 'package:sizer/sizer.dart';

import '../../../constants/constants.dart';

class FullScreenWidgetBuilder extends StatelessWidget {
  const FullScreenWidgetBuilder(
      {super.key, required this.url, this.radius, this.width, this.height});
  final String url;
  final double? radius;
  final double? width;
  final double? height;
  @override
  Widget build(BuildContext context) {
    return FullScreenWidget(
      backgroundColor: AppColors.liteWight,
      disposeLevel: DisposeLevel.Medium,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 1.5.w),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(radius ?? 16),
          child: url.split('.').last == 'svg'
              ? Container(
                  width: width,
                  height: height,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: SvgImage.cachedNetwork(url),
                    ),
                  ),
                  child: const SizedBox())
              : CachedNetworkImage(
                  imageUrl: url,
                  width: width ?? 35.w,
                  height: height,
                  fit: BoxFit.fitWidth,
                ),
        ),
      ),
    );
  }
}
