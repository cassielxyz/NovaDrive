import 'package:flutter/material.dart';

class AppRadius {
  AppRadius._();

  static const double sm = 4.0;
  static const double md = 12.0;
  static const double base = 8.0;
  static const double lg = 16.0;
  static const double xl = 24.0;
  static const double xxl = 28.0;
  static const double full = 9999.0;

  static BorderRadius get radiusSm => BorderRadius.circular(sm);
  static BorderRadius get radiusMd => BorderRadius.circular(md);
  static BorderRadius get radiusBase => BorderRadius.circular(base);
  static BorderRadius get radiusLg => BorderRadius.circular(lg);
  static BorderRadius get radiusXl => BorderRadius.circular(xl);
  static BorderRadius get radiusXxl => BorderRadius.circular(xxl);
  static BorderRadius get radiusFull => BorderRadius.circular(full);
}
