import 'package:flutter/material.dart';
import 'package:the_man_who_sold_the_world/Plugins/Colores.dart';

final c = Colores();

class CustomTextField extends StatelessWidget {
  final TextEditingController? controller;
  final String label;
  final String? hint;
  final bool obscureText;
  final TextInputType keyboardType;
  final IconData? prefixIcon;
  final IconData? suffixIcon;
  final VoidCallback? onSuffixPressed;
  final Function(String)? onChanged;
  const CustomTextField({
    super.key,
    this.controller,
    required this.label,
    this.hint,
    this.obscureText = false,
    this.keyboardType = TextInputType.text,
    this.prefixIcon,
    this.suffixIcon,
    this.onSuffixPressed,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      style: TextStyle(color: c.textPrimary, fontSize: 18),
      decoration: InputDecoration(
        iconColor: c.textPrimary,
        focusColor: c.textPrimary,
        prefixIconColor: c.textPrimary,
        suffixIconColor: c.textPrimary,
        labelText: label,
        hintText: hint,
        labelStyle: TextStyle(color: c.textPrimary),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        filled: true,
        fillColor: c.backgroundDark,
        prefixIcon: prefixIcon != null ? Icon(prefixIcon) : null,
        suffixIcon: suffixIcon != null
            ? IconButton(icon: Icon(suffixIcon), onPressed: onSuffixPressed)
            : null,
      ),
      onChanged: onChanged,
    );
  }
}
