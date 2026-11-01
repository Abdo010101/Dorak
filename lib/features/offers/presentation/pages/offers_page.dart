import 'package:dorakpattient/core/state/status.dart';
import 'package:dorakpattient/features/home/presentation/widgets/offer_card.dart';
import 'package:dorakpattient/features/offers/logic/offers_cubit.dart';
import 'package:dorakpattient/features/offers/logic/offers_state.dart';
import 'package:easy_localization/easy_localization.dart' hide TextDirection;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Phase 8 — Offers list. Wires [OffersCubit] → `GET /patient/offers`
/// (scope §10.1.32).
class OffersPage extends StatefulWidget {
  const OffersPage({super.key});

  @override
  State<OffersPage> createState() => _OffersPageState();
}

class _OffersPageState extends State<OffersPage> {
  static const _textPrimary = Color(0xFF1D1D1D);

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      context.read<OffersCubit>().loadFirstPage();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 6, 16, 14),
              child: Text(
                'offers'.tr(),
                textAlign: TextAlign.right,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                  color: _textPrimary,
                ),
              ),
            ),
            Expanded(
              child: BlocBuilder<OffersCubit, OffersState>(
                builder: (context, s) {
                  if (s.status == Status.loading && s.offers.isEmpty) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (s.offers.isEmpty) {
                    return Center(
                      child: Padding(
                        padding: const EdgeInsets.all(24),
                        child: Text(
                          s.errorMessage ?? 'offers_empty'.tr(),
                          textAlign: TextAlign.center,
                          style: const TextStyle(color: Color(0xFF4C4C4C)),
                        ),
                      ),
                    );
                  }
                  return GridView.builder(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 8,
                      mainAxisSpacing: 12,
                      childAspectRatio: 0.70,
                    ),
                    itemCount: s.offers.length,
                    itemBuilder: (_, i) {
                      final o = s.offers[i];
                      return OfferCard(
                        centerId: o.doctor?.id ?? 0,
                        title: o.title ?? '',
                        centerName: o.doctor?.name ?? '',
                        price:
                            (o.priceAfter ?? o.priceBefore ?? '').toString(),
                        imageAsset: 'assets/images/home/dental_offer.png',
                      );
                    },
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
