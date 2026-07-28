import 'package:flutter/material.dart';
import '../core/theme/app_colors.dart';
import '../core/theme/app_dimensions.dart';
import '../core/theme/app_radius.dart';
import '../core/theme/app_spacing.dart';
import '../core/theme/app_text_styles.dart';

/// Assembles [AppColors], [AppTextStyles], [AppSpacing], [AppRadius], and
/// [AppDimensions] into the two [ThemeData] instances the app runs on.
/// This is the only file that should construct a [ThemeData] — everything
/// else consumes it via `Theme.of(context)`.
class AppTheme {
  AppTheme._();

  static ThemeData get light => _build(brightness: Brightness.light);
  static ThemeData get dark => _build(brightness: Brightness.dark);

  static ThemeData _build({required Brightness brightness}) {
    final isDark = brightness == Brightness.dark;

    final backgroundColor =
        isDark ? AppColors.backgroundDark : AppColors.backgroundLight;
    final surfaceColor =
        isDark ? AppColors.surfaceDark : AppColors.surfaceLight;
    final textPrimary =
        isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight;
    final textSecondary =
        isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight;
    final borderColor = isDark ? AppColors.borderDark : AppColors.borderLight;
    final dividerColor = isDark ? AppColors.dividerDark : AppColors.dividerLight;
    final disabledBorderColor =
        isDark ? AppColors.grey700 : AppColors.grey200;

    final colorScheme = ColorScheme.fromSeed(
      seedColor: AppColors.primary,
      brightness: brightness,
    ).copyWith(
      primary: AppColors.primary,
      onPrimary: AppColors.white,
      secondary: AppColors.secondary,
      onSecondary: AppColors.white,
      tertiary: AppColors.tertiary,
      error: AppColors.error,
      onError: AppColors.white,
      surface: surfaceColor,
      onSurface: textPrimary,
      outline: borderColor,
    );

    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: backgroundColor,
      fontFamily: AppTextStyles.fontFamily,
      visualDensity: VisualDensity.adaptivePlatformDensity,
      textTheme: _textTheme(textPrimary, textSecondary),
      appBarTheme: AppBarThemeData(
        backgroundColor: surfaceColor,
        foregroundColor: textPrimary,
        elevation: 0,
        centerTitle: true,
        surfaceTintColor: Colors.transparent,
        titleTextStyle: AppTextStyles.titleLarge.copyWith(color: textPrimary),
        iconTheme: IconThemeData(color: textPrimary, size: AppDimensions.iconMd),
      ),
      cardTheme: CardThemeData(
        color: surfaceColor,
        elevation: AppDimensions.cardElevation,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(borderRadius: AppRadius.radiusMd),
      ),
      dividerTheme: DividerThemeData(
        color: dividerColor,
        thickness: AppDimensions.dividerThickness,
        space: AppSpacing.md,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: AppColors.white,
          disabledBackgroundColor:
              isDark ? AppColors.grey700 : AppColors.grey300,
          minimumSize: const Size(double.infinity, AppDimensions.buttonHeightMd),
          shape: RoundedRectangleBorder(borderRadius: AppRadius.radiusSm),
          textStyle: AppTextStyles.labelLarge,
          elevation: 0,
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.primary,
          side: const BorderSide(color: AppColors.primary),
          minimumSize: const Size(double.infinity, AppDimensions.buttonHeightMd),
          shape: RoundedRectangleBorder(borderRadius: AppRadius.radiusSm),
          textStyle: AppTextStyles.labelLarge,
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColors.primary,
          textStyle: AppTextStyles.labelLarge,
        ),
      ),
      inputDecorationTheme: InputDecorationThemeData(
        filled: true,
        fillColor: surfaceColor,
        contentPadding: AppSpacing.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.sm,
        ),
        border: OutlineInputBorder(
          borderRadius: AppRadius.radiusSm,
          borderSide: BorderSide(color: borderColor),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: AppRadius.radiusSm,
          borderSide: BorderSide(color: borderColor),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: AppRadius.radiusSm,
          borderSide: const BorderSide(color: AppColors.primary, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: AppRadius.radiusSm,
          borderSide: const BorderSide(color: AppColors.error, width: 2),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: AppRadius.radiusSm,
          borderSide: const BorderSide(color: AppColors.error, width: 2),
        ),
        disabledBorder: OutlineInputBorder(
          borderRadius: AppRadius.radiusSm,
          borderSide: BorderSide(color: disabledBorderColor),
        ),
        hintStyle: AppTextStyles.bodyMedium.copyWith(color: textSecondary),
        labelStyle: AppTextStyles.bodyMedium.copyWith(color: textSecondary),
        errorStyle: AppTextStyles.bodySmall.copyWith(color: AppColors.error),
      ),
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: surfaceColor,
        modalBackgroundColor: surfaceColor,
        shape: RoundedRectangleBorder(borderRadius: AppRadius.topLg),
        showDragHandle: true,
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: surfaceColor,
        shape: RoundedRectangleBorder(borderRadius: AppRadius.radiusMd),
        titleTextStyle: AppTextStyles.titleLarge.copyWith(color: textPrimary),
        contentTextStyle: AppTextStyles.bodyMedium.copyWith(color: textSecondary),
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: isDark ? AppColors.grey700 : AppColors.grey900,
        contentTextStyle:
            AppTextStyles.bodyMedium.copyWith(color: AppColors.white),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: AppRadius.radiusSm),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: isDark ? AppColors.grey800 : AppColors.grey100,
        labelStyle: AppTextStyles.labelMedium.copyWith(color: textPrimary),
        padding: AppSpacing.symmetric(
          horizontal: AppSpacing.sm,
          vertical: AppSpacing.xs,
        ),
        shape: RoundedRectangleBorder(borderRadius: AppRadius.radiusFull),
      ),
    );
  }

  static TextTheme _textTheme(Color primaryColor, Color secondaryColor) {
    return TextTheme(
      displayLarge: AppTextStyles.displayLarge.copyWith(color: primaryColor),
      displayMedium: AppTextStyles.displayMedium.copyWith(color: primaryColor),
      displaySmall: AppTextStyles.displaySmall.copyWith(color: primaryColor),
      headlineLarge: AppTextStyles.headlineLarge.copyWith(color: primaryColor),
      headlineMedium:
          AppTextStyles.headlineMedium.copyWith(color: primaryColor),
      headlineSmall: AppTextStyles.headlineSmall.copyWith(color: primaryColor),
      titleLarge: AppTextStyles.titleLarge.copyWith(color: primaryColor),
      titleMedium: AppTextStyles.titleMedium.copyWith(color: primaryColor),
      titleSmall: AppTextStyles.titleSmall.copyWith(color: primaryColor),
      bodyLarge: AppTextStyles.bodyLarge.copyWith(color: primaryColor),
      bodyMedium: AppTextStyles.bodyMedium.copyWith(color: primaryColor),
      bodySmall: AppTextStyles.bodySmall.copyWith(color: secondaryColor),
      labelLarge: AppTextStyles.labelLarge.copyWith(color: primaryColor),
      labelMedium: AppTextStyles.labelMedium.copyWith(color: secondaryColor),
      labelSmall: AppTextStyles.labelSmall.copyWith(color: secondaryColor),
    );
  }
}
