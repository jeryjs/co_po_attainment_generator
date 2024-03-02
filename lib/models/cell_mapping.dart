
import 'package:flutter/material.dart';

import '../components/get_component.dart';

class CellMapping {
  final cellMappings = {};
  static final CellMapping _instance = CellMapping._internal();

  factory CellMapping() {
    return _instance;
  }

  CellMapping._internal();

  setDetailsMapping(controllers) {
    cellMappings["details"] = {
      "sheet": "START",
      'C6': controllers[0].text,  // name
      'C7': controllers[1].text,  // designation
      'C8': controllers[2].text,  // course name
      'C9': controllers[3].text,  // course code
      'C10': controllers[4].text, // branch/section
      'C11': controllers[5].text, // academic year
    };
  }
  get detailsMapping => cellMappings["details"];

  void setComponentsMapping(List<GetComponent> components) {
    List<List<Map<String, String>>> componentsList = [];

    for (var comp in components) {
      final sheet = getSheetCode(comp.controllers[0].text);
      List<Map<String, String>> componentControllersList = [];

      Map<String, String> controllerMap = {"sheet": sheet};
      for (var (index, ctrl) in comp.controllers.indexed) {
        controllerMap.addAll({'E${7+index}': ctrl.text});
        componentControllersList.add(controllerMap);
      }

      componentsList.add(componentControllersList);
    }
    debugPrint(componentsList.toString());

    cellMappings["components"] = componentsList;
  }
  get componentsMapping => cellMappings["components"];

  void setDataMapping() {
    // implementation
  }

  String getSheetCode(String name) {
    switch (name) {
      case "Class Test": return "IA";
      case "Lab Experiment": return "LAB";
      case "Quiz": return "QUIZ";
      case "Experiential Learning": return "EXP L";
      default: return "";
    }
  }
}