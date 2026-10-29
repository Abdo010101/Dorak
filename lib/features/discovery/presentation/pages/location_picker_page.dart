import 'package:dorakpattient/features/discovery/presentation/widgets/confirm_location_sheet.dart';
import 'package:dorakpattient/features/discovery/presentation/widgets/map_background.dart';
import 'package:dorakpattient/features/discovery/presentation/widgets/pill_search_bar.dart';
import 'package:easy_localization/easy_localization.dart' hide TextDirection;
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// Figma `203:1600` — Discovery 02 Location picker.
class LocationPickerPage extends StatelessWidget {
  const LocationPickerPage({super.key});

  static const _accent = Color(0xFF1F8046);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: Text(
          'discovery_location_title'.tr(),
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: Color(0xFF1D1D1D),
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_forward_ios, color: Color(0xFF1D1D1D)),
          onPressed: () => context.pop(),
        ),
      ),
      body: SafeArea(
        top: false,
        child: Stack(
          children: [
            const Positioned.fill(child: MapBackground()),
            PositionedDirectional(
              top: 8,
              start: 16,
              end: 16,
              child: PillSearchBar(
                hint: 'discovery_my_location'.tr(),
                readOnly: true,
                onTap: () {},
              ),
            ),
            const Center(
              child: Icon(
                Icons.location_on,
                size: 48,
                color: _accent,
              ),
            ),
            PositionedDirectional(
              bottom: 200,
              start: 16,
              child: Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: const [
                    BoxShadow(
                      color: Color(0x1F000000),
                      offset: Offset(0, 2),
                      blurRadius: 4,
                    ),
                  ],
                ),
                child: InkWell(
                  onTap: () {},
                  borderRadius: BorderRadius.circular(12),
                  child: const Icon(
                    Icons.my_location,
                    size: 24,
                    color: _accent,
                  ),
                ),
              ),
            ),
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: ConfirmLocationSheet(
                label: 'discovery_location_selected'.tr(),
                value: 'discovery_location_value'.tr(),
                cta: SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: FilledButton(
                    style: FilledButton.styleFrom(
                      backgroundColor: _accent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: () => context.pop(),
                    child: Text(
                      'discovery_location_confirm'.tr(),
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
