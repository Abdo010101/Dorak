import 'package:easy_localization/easy_localization.dart' hide TextDirection;
import 'package:flutter/material.dart';

import 'booking_tokens.dart';

/// Horizontal 4-step indicator for the booking flow.
/// Figma `jA3JQXye9DbBrxzNkEj9nf` node `177:928`. 358×81.
///
/// Steps are written in logical order (step 1 → step 4). RTL mirroring is
/// handled by Flutter via the parent `Directionality`.
enum BookingStep { specialtyDoctor, dateTime, review, done }

class BookingStepper extends StatelessWidget {
  const BookingStepper({super.key, required this.current});

  final BookingStep current;

  @override
  Widget build(BuildContext context) {
    final steps = _steps();
    final currentIndex = BookingStep.values.indexOf(current);

    return SizedBox(
      height: 72,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          for (var i = 0; i < steps.length; i++) ...[
            Expanded(
              child: _StepCell(
                index: i + 1,
                labelKey: steps[i],
                state: _stateFor(i, currentIndex),
              ),
            ),
            if (i != steps.length - 1)
              _Connector(completed: i < currentIndex),
          ],
        ],
      ),
    );
  }

  List<String> _steps() => const [
        'booking_stepper_step1',
        'booking_stepper_step2',
        'booking_stepper_step3',
        'booking_stepper_step4',
      ];

  _StepState _stateFor(int index, int currentIndex) {
    if (index < currentIndex) return _StepState.completed;
    if (index == currentIndex) return _StepState.current;
    return _StepState.pending;
  }
}

enum _StepState { completed, current, pending }

class _StepCell extends StatelessWidget {
  const _StepCell({
    required this.index,
    required this.labelKey,
    required this.state,
  });

  final int index;
  final String labelKey;
  final _StepState state;

  @override
  Widget build(BuildContext context) {
    final (bg, fg, border) = switch (state) {
      _StepState.completed => (
          BookingTokens.accent,
          Colors.white,
          BookingTokens.accent,
        ),
      _StepState.current => (
          Colors.white,
          BookingTokens.accent,
          BookingTokens.accent,
        ),
      _StepState.pending => (
          Colors.white,
          BookingTokens.textDisabled,
          BookingTokens.borderNeutral,
        ),
    };
    final labelColor = state == _StepState.pending
        ? BookingTokens.textDisabled
        : BookingTokens.textPrimary;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 28,
          height: 28,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: bg,
            shape: BoxShape.circle,
            border: Border.all(color: border, width: 2),
          ),
          child: state == _StepState.completed
              ? const Icon(Icons.check, size: 16, color: Colors.white)
              : Text(
                  '$index',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: fg,
                  ),
                ),
        ),
        const SizedBox(height: 8),
        Text(
          labelKey.tr(),
          textAlign: TextAlign.center,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            fontSize: 11,
            fontWeight: state == _StepState.current
                ? FontWeight.w700
                : FontWeight.w500,
            color: labelColor,
            height: 1.3,
          ),
        ),
      ],
    );
  }
}

class _Connector extends StatelessWidget {
  const _Connector({required this.completed});
  final bool completed;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 13),
      child: Container(
        width: 24,
        height: 2,
        color: completed
            ? BookingTokens.accent
            : BookingTokens.borderNeutral,
      ),
    );
  }
}
