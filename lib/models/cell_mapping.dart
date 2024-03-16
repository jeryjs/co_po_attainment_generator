
import 'package:flutter/material.dart';

import '/screens/1_DetailsPage/get_component.dart';
import '/utils/utils.dart';

class CellMapping {
	final cellMappings = {};
	static final CellMapping _instance = CellMapping._internal();

	String? courseCode;

	factory CellMapping(name) {
		debugPrint(name);
		return _instance;
	}

	CellMapping._internal();

	get detailsMapping => cellMappings[Mapping.details];
	setDetailsMapping(controllers) {
		courseCode = controllers[3].text.toUpperCase();
		cellMappings[Mapping.details] = [
			{
				"sheet": "START",
				"cos": controllers[7].text,
				// "pos": controllers[8].text,
				// "psos": controllers[9].text,
				"mappings": {
					'C6': controllers[0].text, // name
					'C7': controllers[1].text, // designation
					'C8': controllers[2].text, // course name
					'C9': controllers[3].text, // course code
					'C10': controllers[4].text, // branch/section
					'C11': controllers[5].text, // Semester
					'C12': controllers[6].text, // academic year
				}
			}, {
				"sheet": "FINAL",
				"mappings": {
					'B21': controllers[7].text, // name
				}
			}
		];
	}

	get componentsMapping => cellMappings[Mapping.components];
	void setComponentsMapping(List<GetComponent> components) {
		List<Map<String, dynamic>> componentsList = [];

			for (var comp in components) {
				final sheet = comp.controllers[0].text;
				final startCol = getStartCol(comp.controllers[1].text);
				// make qpPattern empty if not Class Test
				final qpPattern = sheet != "IA" ? [] : comp.qpAnalyser.analysedData.qpPattern;
        // use the entered question count if qpPattern is empty
				final questionsCount = qpPattern.isEmpty ? int.parse(comp.controllers[2].text) : qpPattern.length;
        debugPrint("$sheet: $questionsCount");
				Map<String, dynamic> controllerMap = {
					"sheet": sheet,
					"questionsCount": questionsCount,
					"qpPattern": qpPattern,
					"startColumn": startCol,
					"mappings": {},
				};
				for (var (i, it) in qpPattern.indexed) {
					final column = getColName(startCol, i);
					controllerMap["mappings"]['${column}7'] = it['Q'].toString();
					controllerMap["mappings"]['${column}8'] = "CO${it['C']}";
					controllerMap["mappings"]['${column}9'] = it['M'].toString();
				}
				componentsList.add(controllerMap);
			}
		cellMappings[Mapping.components] = componentsList;
	}

	get weightageMapping => cellMappings[Mapping.weightage];
	void setWeightageMapping(List<TextEditingController> ctrl) {
		cellMappings[Mapping.weightage] = [
			{
				"sheet": "START",
				"mappings": {
					'K6': ctrl[0].text,
				}
			},
			{
				"sheet": "FINAL",
				"mappings": {
					'B21': ctrl[1].text,
					'C21': ctrl[2].text,
					'D21': ctrl[3].text,
					'E21': ctrl[4].text,
					'F21': ctrl[5].text,
					'G21': ctrl[6].text,
				}
			} 
		];
	}

	String getStartCol(String num) {
		switch (num) {
			case "1": return "E";
			case "2": return "Z";
			case "3": return "AU";
			case "4": return "BP";
			case "5": return "CK";
			default: return "";
		}
	}

		List<Map<String, dynamic>> generateOperations() {
			List<Map<String, dynamic>> operations = [];
			// Retrieve the cell mappings
			final detailsMapping = cellMappings[Mapping.details];
			final componentsMapping = cellMappings[Mapping.components];

			for (var it in detailsMapping) {
				operations.add({"type": "updateCells", ...it});
			}
			for (var it in componentsMapping) {
				// Unhide the sheet
				operations.add({"type": "showSheet", "sheet": it["sheet"]});
				// Fill the cells with given values
				operations.add({"type": "updateCells", ...it});
				// Unhide the columns: startColumn to startColumn + [count]
				operations.add({"type": "showColumn", "sheet": it["sheet"], "column": "${it["startColumn"]}", "count": it["questionsCount"]});
        // For class tests, unhide the grade (every 20th) column too
				operations.add({"type": "showColumn", "sheet": it["sheet"], "column": getColName(it["startColumn"], 20), "count": 1});
			}
			return operations;
		}
}

enum Mapping {
	details,
	components,
	weightage,
}
