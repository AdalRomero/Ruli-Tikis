import 'package:flutter/material.dart';
import 'package:the_man_who_sold_the_world/Plugins/Colores.dart';

final c = Colores();

class CustomContainer extends StatelessWidget implements PreferredSizeWidget {
  final double? width;
  final double? height;
  final Widget? child;
  final double borderRadius;

  const CustomContainer({
    super.key,
    this.width,
    this.height,
    this.child,
    this.borderRadius = 18,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,

      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [c.surfaceDark, c.surfaceDark],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(borderRadius),
        border: Border.all(color: Colors.grey.withOpacity(0.2), width: 1),

        boxShadow: [
          BoxShadow(
            color: c.appBarSombra.withOpacity(0.1),
            blurRadius: 4,
            offset: Offset(5, 6),
          ),
          BoxShadow(
            color: Colors.white.withOpacity(0.2),
            blurRadius: 4,
            offset: Offset(0, 0),
          ),
        ],
      ),
      child: child,
    );
  }

  /// Para que funcione como AppBar si lo usas en Scaffold
  @override
  Size get preferredSize => Size.fromHeight(height ?? kToolbarHeight);
}
