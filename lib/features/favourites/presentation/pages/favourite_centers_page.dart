import 'package:dorakpattient/core/router/route_names.dart';
import 'package:dorakpattient/core/state/status.dart';
import 'package:dorakpattient/core/theme/app_colors_theme.dart';
import 'package:dorakpattient/core/theme/app_typography.dart';
import 'package:dorakpattient/core/ui_kit/ui_kit.dart';
import 'package:dorakpattient/features/favourites/logic/favourites_cubit.dart';
import 'package:dorakpattient/features/favourites/logic/favourites_state.dart';
import 'package:easy_localization/easy_localization.dart' hide TextDirection;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

/// Phase 11 — Account 10 Favourite centers (Figma `363:3887`).
class FavouriteCentersPage extends StatefulWidget {
  const FavouriteCentersPage({super.key});

  @override
  State<FavouriteCentersPage> createState() => _FavouriteCentersPageState();
}

class _FavouriteCentersPageState extends State<FavouriteCentersPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<FavouritesCubit>().load();
    });
  }

  @override
  Widget build(BuildContext context) {
    final colors = AppColorsTheme.of(context);
    return Scaffold(
      backgroundColor: colors.white,
      appBar: AppTopBar(title: 'favourite_centers_title'.tr()),
      body: SafeArea(
        top: false,
        child: BlocBuilder<FavouritesCubit, FavouritesState>(
          builder: (context, state) {
            if (state.status == Status.loading) {
              return const AppLoadingState();
            }
            if (state.status == Status.failure) {
              return AppErrorState(
                title: 'something_went_wrong'.tr(),
                message: state.errorMessage,
                retryLabel: 'retry'.tr(),
                onRetry: () => context.read<FavouritesCubit>().load(),
              );
            }
            if (state.items.isEmpty) {
              return _EmptyState(
                onExplore: () => context.goNamed(RouteNames.home),
              );
            }
            return GridView.builder(
              padding:
                  const EdgeInsetsDirectional.fromSTEB(16, 16, 16, 24),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 8,
                crossAxisSpacing: 8,
                childAspectRatio: 0.72,
              ),
              itemCount: state.items.length,
              itemBuilder: (_, i) => _FavouriteTile(data: state.items[i]),
            );
          },
        ),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState({required this.onExplore});
  final VoidCallback onExplore;

  @override
  Widget build(BuildContext context) {
    final colors = AppColorsTheme.of(context);
    return AppEmptyState(
      icon: Icon(
        Icons.favorite_border,
        size: 48,
        color: colors.borderPrimary,
      ),
      title: 'favourite_centers_empty_title'.tr(),
      message: 'favourite_centers_empty_body'.tr(),
      actionLabel: 'favourite_centers_empty_cta'.tr(),
      onAction: onExplore,
    );
  }
}

class _FavouriteTile extends StatelessWidget {
  const _FavouriteTile({required this.data});
  final FavouriteCenter data;

  @override
  Widget build(BuildContext context) {
    final colors = AppColorsTheme.of(context);
    final typo = AppTypography.of(context);
    return Container(
      decoration: BoxDecoration(
        color: colors.white,
        border: Border.all(color: colors.fieldBorder),
        borderRadius: BorderRadius.circular(16),
      ),
      padding: const EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: data.imageUrl != null
                  ? Image.network(data.imageUrl!, fit: BoxFit.cover)
                  : Container(color: colors.neutral50),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            data.name,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: typo.textLgSemibold.copyWith(color: colors.textPrimary),
          ),
          if (data.distance != null)
            Text(
              data.distance!,
              style: typo.textMdRegular
                  .copyWith(color: colors.textSecondary),
            ),
        ],
      ),
    );
  }
}
