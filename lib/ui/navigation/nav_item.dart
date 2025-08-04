import 'package:flutter/material.dart';
import 'package:ma_so_thue/ui/common/app_colors.dart';

enum NavItem {
  home(Icons.home_outlined, '/'),
  search(Icons.search_outlined, '/search'),
  favorites(Icons.notifications, '/favorites'),
  profile(Icons.person_outline, '/profile');

  const NavItem(this.iconData, this.route);
  final IconData iconData;
  final String route;

  Icon icon(ColorScheme scheme, {bool selected = false}) =>
      Icon(iconData, color: selected ? kBrandOrange : scheme.onSurfaceVariant);
}
