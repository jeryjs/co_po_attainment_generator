// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';


/// Returns the input decoration for a text form field.
///
/// This function creates and returns an [InputDecoration] object with the specified title, hint,
/// icon, and context.
InputDecoration textFormDecoration(
  String title,
  String hint,
  IconData icon,
  BuildContext context,
) {
  return InputDecoration(
    labelText: title,
    hintText: hint,
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(100),
    ),
    prefixIcon: Icon(icon),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(16),
      borderSide: BorderSide(
        color: Theme.of(context).colorScheme.primaryContainer,
        width: 4,
      ),
    ),
  );
}

/// Returns the button style used in Fluent UI.
///
/// This function returns a [ButtonStyle] object with the background color and shape
/// properties set based on the provided [context].
ButtonStyle fluentUiBtn(BuildContext context) {
  return ButtonStyle(
    backgroundColor: MaterialStateProperty.resolveWith(
      (states) => Theme.of(context).focusColor,
    ),
    shape: MaterialStateProperty.resolveWith(
      (states) => RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
    ),
  );
}

/// A text style for headings.
/// 
/// This text style is used for headings and has a font size of 24 and a bold font weight.
TextStyle heading = TextStyle(fontSize: 24, fontWeight: FontWeight.bold);

/// A widget that disables user interaction with its child widget.
///
/// This widget wraps the provided [child] widget and makes it unresponsive to user input
/// when the [disabled] flag is set to `true`.
Widget disable({
  Key? key,
  bool disabled = true,
  Widget? child,
}) {
  return IgnorePointer(
    ignoring: disabled,
    child: disabled
      ? Container(
          foregroundDecoration: BoxDecoration(
            color: Colors.black,
            backgroundBlendMode: BlendMode.saturation,
          ),
          child: Opacity(
            opacity: 0.7,
            child: child,
          ),
        )
      : child,
  );
}
