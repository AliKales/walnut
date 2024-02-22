import 'package:caroby/caroby.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CTextField extends StatelessWidget {
  const CTextField({
    super.key,
    this.controller,
    this.label,
    this.onChanged,
    this.readOnly = false,
    this.initialValue,
    this.maxLines = 1,
    this.width,
    this.inputFormatters,
    this.keyboardType,
    this.length,
    this.prefixText,
    this.textCapitalization = TextCapitalization.none,
    this.suffixIcon,
    this.prefixIcon,
    this.filled = false,
    this.isHighRadius = false,
    this.obscureText = false,
    this.hintText,
    this.validator,
  });

  final TextEditingController? controller;
  final String? label;
  final String? hintText;
  final ValueChanged<String>? onChanged;
  final bool readOnly;
  final String? initialValue;
  final int? maxLines;
  final int? length;
  final double? width;
  final List<TextInputFormatter>? inputFormatters;
  final TextInputType? keyboardType;
  final String? prefixText;
  final TextCapitalization textCapitalization;
  final Widget? suffixIcon;
  final Widget? prefixIcon;
  final bool filled;
  final bool isHighRadius;
  final bool obscureText;
  final String? Function(String?)? validator;

  TextEditingController? get _controller {
    if (initialValue.isNotEmptyAndNull) {
      return TextEditingController(text: initialValue!);
    }
    return controller;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: _textField(context),
    );
  }

  Widget _textField(BuildContext context) {
    if (validator != null) {
      return TextFormField(
        validator: validator,
        obscureText: obscureText,
        textCapitalization: textCapitalization,
        maxLength: length,
        maxLines: maxLines,
        readOnly: readOnly,
        onChanged: (value) => onChanged?.call(value.trim()),
        controller: _controller,
        decoration: InputDecoration(
          border: OutlineInputBorder(
            borderSide: filled ? BorderSide.none : const BorderSide(),
            borderRadius: isHighRadius
                ? BorderRadius.circular(60)
                : BorderRadius.circular(4),
          ),
          filled: filled,
          fillColor: context.colorScheme.primary.withOpacity(0.1),
          labelText: label,
          suffixIcon: suffixIcon,
          prefixIcon: prefixIcon,
          prefixText: prefixText,
          counterText: "",
          hintText: hintText,
        ),
        inputFormatters: inputFormatters,
        keyboardType: keyboardType,
      );
    }
    return TextField(
      obscureText: obscureText,
      textCapitalization: textCapitalization,
      maxLength: length,
      maxLines: maxLines,
      readOnly: readOnly,
      onChanged: (value) => onChanged?.call(value.trim()),
      controller: _controller,
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderSide: filled ? BorderSide.none : const BorderSide(),
          borderRadius: isHighRadius
              ? BorderRadius.circular(60)
              : BorderRadius.circular(4),
        ),
        filled: filled,
        fillColor: context.colorScheme.primary.withOpacity(0.1),
        labelText: label,
        suffixIcon: suffixIcon,
        prefixIcon: prefixIcon,
        prefixText: prefixText,
        counterText: "",
        hintText: hintText,
      ),
      inputFormatters: inputFormatters,
      keyboardType: keyboardType,
    );
  }
}
