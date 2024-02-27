// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

Widget textForm(title, hint, icon, {isDigits = false, required TextEditingController controller, required BuildContext context}) {
  
  // select all text on focus
  final focusNode = FocusNode();
  focusNode.addListener(() {
    if (focusNode.hasFocus) controller.selection = TextSelection(baseOffset: 0, extentOffset: controller.text.length);
  });

  return Padding(
    padding: const EdgeInsets.all(4.0),
    child: KeyboardListener(
      focusNode: FocusNode(skipTraversal: true),
      onKeyEvent: (event) {
        if (isDigits) {
          if (event.logicalKey == LogicalKeyboardKey.arrowUp) {
            int currentValue = controller.text == '' ? 0 : int.parse(controller.text);
            controller.text = (++currentValue).toString();
          } else if (event.logicalKey == LogicalKeyboardKey.arrowDown) {
            int currentValue = controller.text == '' ? 0 : int.parse(controller.text);
            controller.text = currentValue > 0 ? (--currentValue).toString() : '0';
          }
        }
      },
      child: TextFormField(
        controller: controller,
        focusNode: focusNode,
        validator: (v) => v == null || v.isEmpty ? 'Required to fill this field' : null,
        maxLines: 1,
        keyboardType: isDigits ? TextInputType.number : null,
        inputFormatters: isDigits
            ? <TextInputFormatter>[FilteringTextInputFormatter.digitsOnly]
            : null,
        decoration: InputDecoration(
          labelText: title,
          hintText: hint,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(100),
          ),
          prefixIcon: Icon(icon),
          suffixIcon: isDigits
            ? Padding(padding: const EdgeInsets.only(right: 8.0),
              child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                  InkWell(
                    focusNode: FocusNode(skipTraversal: true),
                    child: Icon(Icons.add, size: 20 ),
                    onTap: () {
                      int currentValue =  controller.text == '' ? 0 : int.parse(controller.text);
                      controller.text = (++currentValue).toString();
                    },
                  ),
                  InkWell(
                    focusNode: FocusNode(skipTraversal: true),
                    child: Icon(Icons.remove, size: 20  ),
                    onTap: () {
                      int currentValue = controller.text == '' ? 0 : int.parse(controller.text);
                      controller.text = currentValue > 0 ? (--currentValue).toString(): '0';
                    },
                  ),
                ]),
              )
            : null,
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide(color: Theme.of(context).colorScheme.primary),
          ),
        ),
        style: TextStyle(color: Theme.of(context).colorScheme.primary, fontSize: 16),
      ),
    ),
  );
}

InputDecoration textFormDecoration(title, hint, icon, {required context}) {
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
          color: Theme.of(context).colorScheme.primaryContainer, width: 4),
    ),
  );
}

ButtonStyle fluentUiBtn(context) {
  return ButtonStyle(
    backgroundColor: MaterialStateProperty.resolveWith((states) => Theme.of(context).focusColor),
    shape: MaterialStateProperty.resolveWith(
      (states) => RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
    )
  );
}