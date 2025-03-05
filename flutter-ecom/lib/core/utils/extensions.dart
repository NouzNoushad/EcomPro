import 'package:flutter/material.dart';

import '../helpers/navigation_helper.dart';

extension CapitalizeExt on String {
  String toCapitalize() => this[0].toUpperCase() + substring(1).toLowerCase();
}

// media query extension
extension MediaQueryExt on BuildContext {
  double get height => MediaQuery.of(this).size.height;
  double get width => MediaQuery.of(this).size.width;
}

// push navigation extension
extension NavigatorExt on BuildContext {
  pushNavigation(Widget screen) => Navigator.push(
        this,
        NavigationHelpers.pageRouteBuilder(screen),
      );
}

// push replacement extension
extension NavigatorReplacementExt on BuildContext {
  pushReplacementNavigation(Widget screen) => Navigator.pushReplacement(
        this,
        NavigationHelpers.pageRouteBuilder(screen),
      );
}
