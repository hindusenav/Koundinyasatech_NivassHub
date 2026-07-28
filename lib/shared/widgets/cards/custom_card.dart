import 'package:flutter/material.dart';
import '../../../core/theme/app_decoration.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_spacing.dart';

/// The app's base card container. Uses [Ink] rather than [Container] so an
/// [onTap] ripple still shows through the decorated background — a plain
/// `Container` with a `color` set would paint over and hide it.
class CustomCard extends StatelessWidget {
  const CustomCard({
    super.key,
    required this.child,
    this.padding = AppSpacing.cardInsets,
    this.onTap,
    this.elevated = false,
  });

  final Widget child;
  final EdgeInsetsGeometry padding;
  final VoidCallback? onTap;
  final bool elevated;

  @override
  Widget build(BuildContext context) {
    final decoration =
        elevated ? AppDecoration.elevatedCard(context) : AppDecoration.card(context);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: AppRadius.radiusMd,
        child: Ink(
          padding: padding,
          decoration: decoration,
          child: child,
        ),
      ),
    );
  }
}
