import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Represents an intent to increment a value.
class IncrementIntent extends Intent {}

/// Represents an intent to decrement a value.
class DecrementIntent extends Intent {}

/// A custom widget that represents a **material** styled text form field with various features.
///
/// This widget provides a text form field with options like selecting all text on focus,
/// incrementing and decrementing the value for numeric input, and more.
class MTextForm extends StatelessWidget {
  final String title;
  final String? hint;
  final IconData? icon;
  final bool isDigits;
  final bool enabled;
  final double radius;
  final EdgeInsets padding;
  final TextEditingController controller;

  const MTextForm(
    this.title,
    this.hint,
    this.icon, {
    super.key,
    this.isDigits = false,
    this.enabled = true,
    this.radius = 16.0,
    this.padding = const EdgeInsets.all(4.0),
    required this.controller,
  });

  void incrementDigits() {
    if (isDigits) {
      final txt = controller.text;
      int curVal = txt == '' ? 0 : int.parse(txt);
      controller.text = (++curVal).toString();
    }
  }

  void decrementDigits() {
    if (isDigits) {
      final txt = controller.text;
      int curVal = txt == '' ? 0 : int.parse(txt);
      controller.text = curVal > 0 ? (--curVal).toString() : '0';
    }
  }

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
      padding: padding,
      child: Shortcuts(
        shortcuts: <LogicalKeySet, Intent>{
          LogicalKeySet(LogicalKeyboardKey.arrowUp): IncrementIntent(),
          LogicalKeySet(LogicalKeyboardKey.arrowDown): DecrementIntent(),
        },
        child: Actions(
          actions: <Type, Action<Intent>>{
            IncrementIntent: CallbackAction<IncrementIntent>(
              onInvoke: (IncrementIntent intent) => incrementDigits(),
            ),
            DecrementIntent: CallbackAction<DecrementIntent>(
              onInvoke: (DecrementIntent intent) => decrementDigits(),
            ),
          },
          child: TextFormField(
            controller: controller,
            focusNode: focusNode,
            validator: (v) =>
                v == null || v.isEmpty ? 'Required to fill this field' : null,
            enabled: enabled,
            maxLines: 1,
            keyboardType: isDigits
                ? const TextInputType.numberWithOptions(decimal: false, signed: true)
                : null,
            inputFormatters: isDigits
                ? <TextInputFormatter>[FilteringTextInputFormatter.digitsOnly]
                : null,
            decoration: InputDecoration(
              labelText: title,
              hintText: hint,
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(100)),
              prefixIcon: Icon(icon),
              suffixIcon: isDigits
                  ? Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // increment and decrement the value for numeric input with arrow keys
                          InkWell(
                            focusNode: FocusNode(skipTraversal: true),
                            child: const Icon(Icons.arrow_drop_up, size: 24),
                            onTap: () {
                              final txt = controller.text;
                              int curVal = txt == '' ? 0 : int.parse(txt);
                              controller.text = (++curVal).toString();
                            },
                          ),
                          InkWell(
                            focusNode: FocusNode(skipTraversal: true),
                            child: const Icon(Icons.arrow_drop_down, size: 24),
                            onTap: () {
                              final txt = controller.text;
                              int curVal = txt == '' ? 0 : int.parse(txt);
                              controller.text =
                                  curVal > 0 ? (--curVal).toString() : '0';
                            },
                          ),
                        ],
                      ),
                    )
                  : null,
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(radius),
                borderSide: BorderSide(
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
            ),
            style: TextStyle(
              color: Theme.of(context).colorScheme.primary,
              fontSize: 16,
            ),
          ),
        ),
      ),
    );
  }
}
