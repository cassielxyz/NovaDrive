import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/theme/app_radius.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/theme_provider.dart';

class NovaGlassCard extends ConsumerWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;
  final bool heavyBlur;
  final BorderRadiusGeometry? borderRadius;
  final double? width;
  final double? height;
  final Color? backgroundColor;
  final bool disableBlur;

  const NovaGlassCard({
    super.key,
    required this.child,
    this.padding,
    this.onTap,
    this.onLongPress,
    this.heavyBlur = false,
    this.borderRadius,
    this.width,
    this.height,
    this.backgroundColor,
    this.disableBlur = false,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeConfig = ref.watch(themeProvider);
    
    final brightness = Theme.of(context).brightness;
    
    Color defaultPanelColor = brightness == Brightness.light
        ? Theme.of(context).colorScheme.primaryContainer.withValues(alpha: 0.15)
        : Theme.of(context).colorScheme.surface.withValues(alpha: 0.5);
        
    Color defaultBorderColor = brightness == Brightness.light
        ? Theme.of(context).colorScheme.primary.withValues(alpha: 0.2)
        : Colors.white.withValues(alpha: 0.2);

    Color panelColor = backgroundColor ?? defaultPanelColor;
    Color borderColor = defaultBorderColor;
    
    if (!themeConfig.enableGlass) {
      panelColor = backgroundColor ?? Theme.of(context).colorScheme.surfaceContainerHighest;
      borderColor = Colors.transparent;
    }
    
    final radius = borderRadius ?? AppRadius.radiusXl;

    Widget cardContent = Container(
      width: width,
      height: height,
      padding: padding ?? const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: panelColor,
        borderRadius: radius,
        border: borderColor == Colors.transparent ? null : Border.all(
          color: borderColor, 
          width: 0.5,
        ),
      ),
      child: child,
    );

    if (themeConfig.enableGlass && !disableBlur) {
      double sigma = 10.0;
      if (heavyBlur) {
        sigma = themeConfig.glassIntensity == GlassIntensity.high ? 40.0 : 25.0;
      } else {
        sigma = themeConfig.glassIntensity == GlassIntensity.high ? 20.0 : (themeConfig.glassIntensity == GlassIntensity.low ? 8.0 : 15.0);
      }
      
      cardContent = ClipRRect(
        borderRadius: radius,
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: sigma, sigmaY: sigma),
          child: cardContent,
        ),
      );
    }

    if (onTap != null || onLongPress != null) {
      return RepaintBoundary(
        child: Material(
          color: Colors.transparent,
          borderRadius: radius,
          child: InkWell(
            borderRadius: radius as BorderRadius,
            onTap: onTap,
            onLongPress: onLongPress,
            splashColor: Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
            highlightColor: Theme.of(context).colorScheme.primary.withValues(alpha: 0.05),
            child: cardContent,
          ),
        ),
      );
    }

    return RepaintBoundary(child: cardContent);
  }
}
