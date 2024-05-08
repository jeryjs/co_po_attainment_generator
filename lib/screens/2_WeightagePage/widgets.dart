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

  /// The controller for the marks text field.
  final TextEditingController markCtrl;

  /// The controllers for the min range text field,
  final TextEditingController min;

  /// The controller for the max range text field,
  final TextEditingController? max;

  /// Creates a new [WhenTextField] widget.
  /// [title] is the title of the text field.
  /// [hint] is the hint text for the text field. It defaults to "How much minimum marks?".
  /// [markCtrl] is the controller for the text field.
  const WhenTextField(this.title,
      {super.key,
      this.hint = "How much minimum marks?",
      required this.markCtrl,
      required this.min,
      required this.max});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * 0.05, vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(title+' '),
          inputField(context, min, '? '),
          if (max != null) 
            Row(children:[
              Text("% and "),
              inputField(context, max, '? '),
            ]),
          Text("% of students score: "),
          inputField(context, markCtrl, "How much minimum marks?"),
          Text("marks"),
        ],
      ),
    );
  }
  
  Widget inputField(ctx, ctrl, hint) {
    // select all text on focus
    final focusNode = FocusNode();
    focusNode.addListener(() {
      if (focusNode.hasFocus) {
        ctrl.selection = TextSelection(
          baseOffset: 0,
          extentOffset: ctrl.text.length,
        );
      }
    });

    return IntrinsicWidth(
      child: Shortcuts(
        shortcuts: <LogicalKeySet, Intent>{
          LogicalKeySet(LogicalKeyboardKey.arrowUp): IncrementIntent(),
          LogicalKeySet(LogicalKeyboardKey.arrowDown): DecrementIntent(),
        },
        child: Actions(
            actions: <Type, Action<Intent>>{
              IncrementIntent: CallbackAction<IncrementIntent>(
                onInvoke: (IncrementIntent intent) => incrementDigits(ctrl),
              ),
              DecrementIntent: CallbackAction<DecrementIntent>(
                onInvoke: (DecrementIntent intent) => decrementDigits(ctrl),
              ),
            },
          child: TextFormField(
            controller: ctrl,
            focusNode: focusNode,
            validator: (v) => v == null || v.isEmpty ? 'Required to fill this field' : null,
            keyboardType: const TextInputType.numberWithOptions(decimal: false, signed: false),
            inputFormatters: <TextInputFormatter>[  
              FilteringTextInputFormatter.digitsOnly,
              FilteringTextInputFormatter.deny(RegExp(r'^\d\d\d+$')),
            ],
            textAlign: TextAlign.center,
            style: TextStyle(color: Theme.of(ctx).colorScheme.primary),
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: TextStyle(fontSize: hint.length>5 ? 10 : 18),
              border: const UnderlineInputBorder(),
            ),
          ),
        ),
      ),
    );
  }  

  void incrementDigits(controller) {
    final txt = controller.text;
    int curVal = txt == '' ? 0 : int.parse(txt);
    controller.text = (++curVal).toString();
  }

  void decrementDigits(controller) {
    final txt = controller.text;
    int curVal = txt == '' ? 0 : int.parse(txt);
    controller.text = curVal > 0 ? (--curVal).toString() : '0';
  }
}

/// Represents an intent to increment a value.
class IncrementIntent extends Intent {}

/// Represents an intent to decrement a value.
class DecrementIntent extends Intent {}
