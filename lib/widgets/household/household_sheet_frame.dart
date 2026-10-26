import 'package:flutter_nivasshub/constants/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_nivasshub/constants/figma_colors.dart';

/// Shared chrome for the Add Family / Add Pet bottom sheets: rounded white
/// panel, title row with a close button, keyboard-aware padding, and an orange
/// primary action pinned to the bottom.
class HouseholdSheetFrame extends StatelessWidget {
  const HouseholdSheetFrame({
    super.key,
    required this.title,
    required this.child,
    required this.actionLabel,
    required this.onAction,
    this.isBusy = false,
    this.error,
  });

  final String title;
  final Widget child;
  final String actionLabel;
  final VoidCallback? onAction;
  final bool isBusy;
  final String? error;

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.viewInsetsOf(context).bottom;
    return Padding(
      padding: EdgeInsets.only(bottom: bottomInset),
      child: DecoratedBox(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: SafeArea(
          top: false,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 10),
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.cardBorder,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(8, 8, 8, 0),
                child: Row(
                  children: [
                    IconButton(
                      onPressed: isBusy ? null : () => Navigator.maybePop(context),
                      icon: const Icon(Icons.close, color: FigmaColors.navy),
                    ),
                    Expanded(
                      child: Text(
                        title,
                        style: const TextStyle(
                          color: FigmaColors.navy,
                          fontSize: 17,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Flexible(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(20, 8, 20, 12),
                  keyboardDismissBehavior:
                      ScrollViewKeyboardDismissBehavior.onDrag,
                  child: child,
                ),
              ),
              if (error != null)
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 8),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.error_outline,
                        size: 16,
                        color: AppColors.error,
                      ),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          error!,
                          style: const TextStyle(
                            color: AppColors.error,
                            fontSize: 12.5,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
                child: SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: isBusy ? null : onAction,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: FigmaColors.orange,
                      foregroundColor: Colors.white,
                      disabledBackgroundColor: FigmaColors.orange.withValues(
                        alpha: 0.6,
                      ),
                      disabledForegroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    child: isBusy
                        ? const SizedBox(
                            width: 22,
                            height: 22,
                            child: CircularProgressIndicator(
                              strokeWidth: 2.4,
                              color: Colors.white,
                            ),
                          )
                        : Text(
                            actionLabel,
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Outlined text field styled to match the sheets.
InputDecoration householdFieldDecoration(String hint, {String? prefixText}) {
  OutlineInputBorder border(Color c) => OutlineInputBorder(
    borderRadius: BorderRadius.circular(12),
    borderSide: BorderSide(color: c),
  );
  return InputDecoration(
    hintText: hint,
    prefixText: prefixText,
    counterText: '',
    isDense: true,
    contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 15),
    enabledBorder: border(AppColors.cardBorder),
    focusedBorder: border(FigmaColors.accentBlue),
    border: border(AppColors.cardBorder),
  );
}
