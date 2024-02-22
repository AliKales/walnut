import 'package:flutter/material.dart';

final class Buttons {
  String text;
  VoidCallback? onTap;
  final Icon? icon;
  final Color? background;

  Buttons(
    String t,
    this.onTap, {
    this.icon,
    this.background,
  }) : text = t.toUpperCase();

  bool get _isIcon => icon != null;

  Widget filled() {
    if (_isIcon) {
      return FilledButton.icon(
        onPressed: onTap,
        style: _filledButtonStyle(),
        icon: icon!,
        label: _text(),
      );
    }
    return FilledButton(
      style: _filledButtonStyle(),
      onPressed: onTap,
      child: _text(),
    );
  }

  ButtonStyle _filledButtonStyle() {
    return FilledButton.styleFrom(
      minimumSize: const Size(double.maxFinite, 53),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(12)),
      ),
      backgroundColor: background,
    );
  }

  Widget outlined() {
    if (_isIcon) {
      return OutlinedButton.icon(
        onPressed: onTap,
        icon: icon!,
        style: _outlinedButtonStyle(),
        label: _text(),
      );
    }
    return OutlinedButton(
      onPressed: onTap,
      style: _outlinedButtonStyle(),
      child: _text(),
    );
  }

  ButtonStyle _outlinedButtonStyle() {
    return OutlinedButton.styleFrom(
      minimumSize: const Size(double.maxFinite, 53),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(12)),
      ),
    );
  }

  Widget textB() {
    if (_isIcon) {
      return TextButton.icon(
        onPressed: onTap,
        icon: icon!,
        label: _text(),
      );
    }
    return TextButton(
      onPressed: onTap,
      child: _text(),
    );
  }

  Text _text() => Text(
        text,
        style: const TextStyle(fontWeight: FontWeight.bold),
      );
}
