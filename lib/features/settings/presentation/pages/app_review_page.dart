import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:go_router/go_router.dart';

import '../../../../constants/strings.dart';
import '../../../../core/state/status.dart';
import '../../../../core/theme/app_colors_theme.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/ui_kit/ui_kit.dart';
import '../../logic/app_review_cubit.dart';
import '../../logic/app_review_state.dart';

class AppReviewPage extends StatelessWidget {
  const AppReviewPage({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = AppColorsTheme.of(context);
    final spacing = AppSpacing.of(context);
    final type = AppTypography.of(context);
    return BlocListener<AppReviewCubit, AppReviewState>(
      listenWhen: (p, c) => p.status != c.status || p.submitted != c.submitted,
      listener: (ctx, state) {
        if (state.submitted) {
          ctx.read<AppReviewCubit>().reset();
          if (ctx.canPop()) ctx.pop();
        } else if (state.status == Status.failure &&
            state.errorMessage != null) {
          AppSnackbar.show(
            ctx,
            state.errorMessage!,
            kind: AppSnackbarKind.error,
          );
        }
      },
      child: Scaffold(
        backgroundColor: colors.surfaceField,
        appBar: AppTopBar(title: AppStrings.kAppReview.tr()),
        body: BlocBuilder<AppReviewCubit, AppReviewState>(
          builder: (ctx, state) {
            return ListView(
              padding: EdgeInsets.symmetric(
                horizontal: spacing.lg,
                vertical: spacing.md,
              ),
              children: [
                Text(
                  'rate_quality'.tr(),
                  style: type.titleMd.copyWith(color: colors.textPrimary),
                ),
                SizedBox(height: spacing.lg),
                Center(
                  child: RatingBar.builder(
                    initialRating: state.rating,
                    glow: false,
                    allowHalfRating: false,
                    itemCount: 5,
                    itemBuilder: (_, __) =>
                        Icon(Icons.star_rounded, color: colors.borderPrimary),
                    onRatingUpdate: (v) =>
                        ctx.read<AppReviewCubit>().setRating(v),
                  ),
                ),
                SizedBox(height: spacing.lg),
                TextField(
                  minLines: 3,
                  maxLines: 6,
                  onChanged: (v) => ctx.read<AppReviewCubit>().setComment(v),
                  decoration: InputDecoration(
                    hintText: AppStrings.kRateComment.tr(),
                  ),
                ),
                SizedBox(height: spacing.lg),
                AppPrimaryButton(
                  label: 'submit'.tr(),
                  isLoading: state.status == Status.loading,
                  onPressed: () => ctx.read<AppReviewCubit>().submit(),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
