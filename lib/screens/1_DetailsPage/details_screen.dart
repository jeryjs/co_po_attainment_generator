import 'dart:math';

import 'package:flutter/material.dart';

import 'get_details.dart';
import 'get_component.dart';
import '../../components/widgets.dart';
import '../../models/cell_mapping.dart';

/// Represents the start page of the application.
class DetailsPage extends StatefulWidget {
  DetailsPage({super.key});

  /// List of components on the start page.
  final List<GetComponent> components = [GetComponent(index: 0)];

  /// Widget for getting details.
  final getDetailsWidget = GetDetails();

  /// Checks if all the components and the details widget are filled.
  bool isFilled() {
    List<bool> tests = [];
    for (var component in components) {
      if (!component.isFilled()) {
        tests.add(false);
      } else {
        tests.add(true);
      }
    }
    if (!getDetailsWidget.isFilled()) {
      tests.add(false);
    } else {
      tests.add(true);
    }

    return tests.any((test) => test == false) ? false : true;
  }

  @override
  State<DetailsPage> createState() => _DetailsPageState();
}

class _DetailsPageState extends State<DetailsPage> {
  get components => widget.components;
  final _scrollController = ScrollController();

  // min and max width offsets for component's scroll animation
  final _width1 = 0.55;
  final _width2 = 275.0;

  /// Adds a new component to the list and scrolls to the end of the list if necessary.
  void _addComponent() {
    final width = MediaQuery.of(context).size.width;
    setState(() => components.add(GetComponent(index: components.length)));
    final offset = components.length * _width2 < width * _width1 ? 0 : _width2;
    _scrollController.animateTo(
      _scrollController.position.maxScrollExtent + offset,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeOut,
    );
  }

  /// Removes a component from the list at the specified index and scrolls to the previous component if necessary.
  void _removeComponent(int index) {
    final width = MediaQuery.of(context).size.width;
    setState(() => components.removeAt(index));
    final offset = components.length * _width2 < width * _width1 ? 0 : 275;
    _scrollController.animateTo(
      _scrollController.position.pixels - offset,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeOut,
    );
  }

  @override
  void deactivate() {
    CellMapping("StartPage").setComponentsMapping(components);
    _scrollController.dispose();
    super.deactivate();
  }

  /// Display the Details screen with components
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Expanded(child: widget.getDetailsWidget),
        Row(
          children: [

            /// Animate adding or removing components
            AnimatedContainer(
              duration: const Duration(milliseconds: 500),
              width: min(components.length * _width2, width * _width1),
              curve: components.length > 1
                ? Curves.easeOutBack
                : Curves.easeInOut,
              child: ListView.builder(
                controller: _scrollController,
                scrollDirection: Axis.horizontal,
                itemCount: components.length,
                itemBuilder: (context, index) => components[index],
              ),
            ),

            /// Fluent UI style buttons for adding/removing Components.
            /// The remove button is displayed only when theres at least 1 component
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: _addComponent,
                  style: fluentUiBtn(context),
                ),
                const Padding(padding: EdgeInsets.symmetric(vertical: 8)),
                if (components.length > 0)
                  IconButton(
                    icon: const Icon(Icons.remove),
                    onPressed: () => _removeComponent(components.length - 1),
                    style: fluentUiBtn(context),
                  ),
              ],
            ),
          ],
        ),
      ],
    );
  }
}
