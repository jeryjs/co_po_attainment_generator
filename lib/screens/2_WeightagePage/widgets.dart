import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// [GradeDisplayText] is a stateless widget that displays a grade as text.
/// It uses a read-only text field to display the grade.
/// The grade is passed to the widget through the [value] parameter.
class GradeDisplayText extends StatelessWidget {
  /// The grade to display.
  final String value;

  /// Creates a new [GradeDisplayText] widget.
  /// [value] is the grade to display.
  const GradeDisplayText({super.key, required this.value});

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: TextEditingController(text: value),
      readOnly: true,
      textAlign: TextAlign.center,
      focusNode: FocusNode(skipTraversal: true),
      decoration: const InputDecoration(
        border: UnderlineInputBorder(
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}

/// [WhenTextField] is a stateless widget that provides a text field for user input.
/// It is used to ask the user for a minimum mark.
/// The title of the field and the hint text can be customized.
/// The input is validated to ensure it is not empty.
class WhenTextField extends StatelessWidget {
  /// The title of the text field.
  final String title;

  /// The hint text for the text field.
  final String hint;

  /// The controller for the text field.
  final TextEditingController controller;

  /// Creates a new [WhenTextField] widget.
  /// [title] is the title of the text field.
  /// [hint] is the hint text for the text field. It defaults to "How much minimum marks?".
  /// [controller] is the controller for the text field.
  const WhenTextField(this.title,
      {super.key,
      this.hint = "How much minimum marks?",
      required this.controller});

  @override
  Widget build(BuildContext context) {
    // select all text on focus
    final focusNode = FocusNode();
    focusNode.addListener(() {
      if (focusNode.hasFocus) {
        controller.selection = TextSelection(
          baseOffset: 0,
          extentOffset: controller.text.length,
        );
      }
    });
    return Padding(
      padding: EdgeInsets.symmetric(
          horizontal: MediaQuery.of(context).size.width * 0.05, vertical: 4),
      child: TextFormField(
        controller: controller,
        focusNode: focusNode,
        validator: (v) =>
            v == null || v.isEmpty ? 'Required to fill this field' : null,
        keyboardType:
            const TextInputType.numberWithOptions(decimal: false, signed: true),
        inputFormatters: <TextInputFormatter>[
          FilteringTextInputFormatter.digitsOnly
        ],
        textAlign: TextAlign.center,
        style: TextStyle(color: Theme.of(context).colorScheme.primary),
        decoration: InputDecoration(
          labelText: title,
          hintText: hint,
          border: const UnderlineInputBorder(borderSide: BorderSide.none),
        ),
      ),
    );
  }
}