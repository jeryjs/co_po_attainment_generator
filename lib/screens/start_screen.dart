// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors, unused_import

import 'dart:math';

import 'package:co_po_attainment_v2_1_flutter/components/get_component.dart';
import 'package:co_po_attainment_v2_1_flutter/components/widgets.dart';
import 'package:flutter/material.dart';

import '../components/get_details.dart';
import '../models/cell_mapping.dart';

class StartPage extends StatefulWidget {
  StartPage({super.key});
  final List<GetComponent> components = [GetComponent(index: 0)];
  final getDetailsWidget = GetDetails();

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

    debugPrint('isFilled: true');
    return tests.any((test) => test == false) ? false : true;
  }

  @override
  State<StartPage> createState() => _StartPageState();
}

class _StartPageState extends State<StartPage> {
  get _components => widget.components;
  final _scrollController = ScrollController();

  final _width1 = 0.55;
  final _width2 = 275.0;

  void _addComponent() {
    setState(() => _components.add(GetComponent(index: _components.length)));
    final offset = _components.length * _width2 < MediaQuery.of(context).size.width * _width1 ? 0 : _width2;
    _scrollController.animateTo(
      _scrollController.position.maxScrollExtent + offset,
      duration: Duration(milliseconds: 500),
      curve: Curves.easeOut,
    );
  }

  void _removeComponent(int index) {
    setState(() => _components.removeAt(index));
    final offset = _components.length * _width2 < MediaQuery.of(context).size.width * _width1 ? 0 : 275;
    _scrollController.animateTo(
      _scrollController.position.pixels - offset,
      duration: Duration(milliseconds: 500),
      curve: Curves.easeOut,
    );
  }

  @override
  void dispose() {
    CellMapping().setComponentsMapping(_components);
    _scrollController.dispose();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    final scr = MediaQuery.of(context).size;
    return buildInformationForm();
  }

  Widget buildInformationForm() {
    final width = MediaQuery.of(context).size.width;
    final clr = Theme.of(context).colorScheme;
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Expanded(child: widget.getDetailsWidget),
        Row(
          children: [
            MouseRegion(
              onEnter: (event) => setState(() {}),
              onExit: (event) => setState(() {}),
              child: AnimatedContainer(
                duration: Duration(milliseconds: 500),
                width: min(_components.length * _width2, width * _width1),
                curve: Curves.easeOutBack,
                child: ListView.builder(
                  controller: _scrollController,
                  scrollDirection: Axis.horizontal,
                  itemCount: _components.length,
                  itemBuilder: (context, index) => _components[index],
                ),
              ),
            ),
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: Icon(Icons.add),
                  onPressed: _addComponent,
                  style: fluentUiBtn(context),
                ),
                Padding(padding: EdgeInsets.symmetric(vertical: 8)),
                if (_components.length > 1)
                  IconButton(
                    icon: Icon(Icons.remove),
                    onPressed: () => _removeComponent(_components.length - 1),
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
