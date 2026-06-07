import 'package:flutter/material.dart';
import 'dart:math';

/// Responsive Helper untuk mendapatkan ukuran yang konsisten di semua device
class ResponsiveHelper {
  late BuildContext context;
  late MediaQueryData mediaQuery;

  ResponsiveHelper(this.context) {
    mediaQuery = MediaQuery.of(context);
  }

  /// Screen dimensions
  double get screenWidth => mediaQuery.size.width;
  double get screenHeight => mediaQuery.size.height;
  double get screenDiagonal =>
      sqrt(screenWidth * screenWidth + screenHeight * screenHeight);

  /// Safe area dimensions
  double get safeWidth =>
      screenWidth - (mediaQuery.padding.left + mediaQuery.padding.right);
  double get safeHeight =>
      screenHeight - (mediaQuery.padding.top + mediaQuery.padding.bottom);

  /// Device orientation
  bool get isPortrait => mediaQuery.orientation == Orientation.portrait;
  bool get isLandscape => !isPortrait;

  /// Device type detection
  DeviceType get deviceType {
    final diagonal = screenDiagonal;
    if (diagonal < 550) {
      return DeviceType.phone;
    } else if (diagonal < 1200) {
      return DeviceType.tablet;
    } else {
      return DeviceType.desktop;
    }
  }

  /// Base scale factor (normalized to standard screen)
  double get scaleFactor {
    // Standard base: 393 width (typical phone)
    const standardWidth = 393.0;
    return screenWidth / standardWidth;
  }

  /// Responsive font sizes (scaled by device)
  double get fontSizeXSmall => 10 * scaleFactor;
  double get fontSizeSmall => 12 * scaleFactor;
  double get fontSizeBody => 14 * scaleFactor;
  double get fontSizeBodyLarge => 16 * scaleFactor;
  double get fontSizeSubtitle => 18 * scaleFactor;
  double get fontSizeHeading => 22 * scaleFactor;
  double get fontSizeTitle => 28 * scaleFactor;
  double get fontSizeLargeTitle => 36 * scaleFactor;
  double get fontSizeXLarge => 54 * scaleFactor;

  /// Responsive spacing
  double get spacing2 => 2 * scaleFactor;
  double get spacing4 => 4 * scaleFactor;
  double get spacing5 => 5 * scaleFactor;
  double get spacing8 => 8 * scaleFactor;
  double get spacing10 => 10 * scaleFactor;
  double get spacing12 => 12 * scaleFactor;
  double get spacing15 => 15 * scaleFactor;
  double get spacing16 => 16 * scaleFactor;
  double get spacing20 => 20 * scaleFactor;
  double get spacing24 => 24 * scaleFactor;
  double get spacing30 => 30 * scaleFactor;
  double get spacing32 => 32 * scaleFactor;
  double get spacing40 => 40 * scaleFactor;
  double get spacing48 => 48 * scaleFactor;

  /// Responsive button dimensions
  double get buttonWidthSmall => 160 * scaleFactor;
  double get buttonWidthMedium => 220 * scaleFactor;
  double get buttonWidthLarge => 280 * scaleFactor;
  double get buttonHeight => 55 * scaleFactor;

  /// Responsive icon sizes
  double get iconSizeSmall => 16 * scaleFactor;
  double get iconSizeMedium => 24 * scaleFactor;
  double get iconSizeLarge => 32 * scaleFactor;
  double get iconSizeXLarge => 48 * scaleFactor;

  /// Responsive border radius
  double get radiusSmall => 8 * scaleFactor;
  double get radiusMedium => 12 * scaleFactor;
  double get radiusLarge => 20 * scaleFactor;
  double get radiusXLarge => 30 * scaleFactor;

  /// Responsive padding values
  EdgeInsets get paddingSmall => EdgeInsets.all(spacing8);
  EdgeInsets get paddingMedium => EdgeInsets.all(spacing16);
  EdgeInsets get paddingLarge => EdgeInsets.all(spacing24);

  EdgeInsets get paddingHorizontalSmall =>
      EdgeInsets.symmetric(horizontal: spacing8);
  EdgeInsets get paddingHorizontalMedium =>
      EdgeInsets.symmetric(horizontal: spacing16);
  EdgeInsets get paddingHorizontalLarge =>
      EdgeInsets.symmetric(horizontal: spacing24);

  EdgeInsets get paddingVerticalSmall =>
      EdgeInsets.symmetric(vertical: spacing8);
  EdgeInsets get paddingVerticalMedium =>
      EdgeInsets.symmetric(vertical: spacing16);
  EdgeInsets get paddingVerticalLarge =>
      EdgeInsets.symmetric(vertical: spacing24);

  /// Get responsive text style
  TextStyle getTextStyle({
    required TextSize size,
    Color? color,
    FontWeight weight = FontWeight.normal,
    double? letterSpacing,
    double? lineHeight,
  }) {
    return TextStyle(
      fontSize: _getFontSize(size),
      color: color,
      fontWeight: weight,
      letterSpacing: letterSpacing,
      height: lineHeight,
    );
  }

  double _getFontSize(TextSize size) {
    switch (size) {
      case TextSize.xSmall:
        return fontSizeXSmall;
      case TextSize.small:
        return fontSizeSmall;
      case TextSize.body:
        return fontSizeBody;
      case TextSize.bodyLarge:
        return fontSizeBodyLarge;
      case TextSize.subtitle:
        return fontSizeSubtitle;
      case TextSize.heading:
        return fontSizeHeading;
      case TextSize.title:
        return fontSizeTitle;
      case TextSize.largeTitle:
        return fontSizeLargeTitle;
      case TextSize.xLarge:
        return fontSizeXLarge;
    }
  }
}

enum DeviceType { phone, tablet, desktop }

enum TextSize {
  xSmall,
  small,
  body,
  bodyLarge,
  subtitle,
  heading,
  title,
  largeTitle,
  xLarge,
}

/// Extension untuk akses mudah ResponsiveHelper dari BuildContext
extension ResponsiveContext on BuildContext {
  ResponsiveHelper get responsive => ResponsiveHelper(this);
}
