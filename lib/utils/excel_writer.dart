
import 'dart:io';

import 'package:excel/excel.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../models/cell_mapping.dart';

class ExcelWriter {
  final String _excelFilePath = "assets/excel.xlsx";
  final CellMapping _cellMappings = CellMapping();

  Future<List<int>?> writeToExcel() async {
    final outputFile = File('C:/Users/Jery/AppData/Roaming/com.example/co_po_attainment_v2_1_flutter/output.xlsx');
    
    // Load the Excel file
    // var bytes = File("Z:/Documents/All-Projects/Vishal-Sir/CO-PO-Attainment/Vizag_CO_FINAL_Test - Copy.xlsx").readAsBytesSync();
    var bytes = File(_excelFilePath).readAsBytesSync();
    var wb = Excel.decodeBytes(bytes);
    // var sheet = wb["FINAL"];

    final detailsMapping = _cellMappings.detailsMapping;
    final componentsMapping = _cellMappings.componentsMapping;

    // sheet = wb[detailsMapping["sheet"]];

    // Write data to specific cells using the mappings
    // detailsMapping.forEach((key, value) {
    //   debugPrint('$key : $value');
    //   if (RegExp(r'^[A-Z]+\d+$').hasMatch(key)) {
    //     var cellIndex = CellIndex.indexByString(key);
    //     debugPrint(TextCellValue(value).value);
    //     sheet.cell(cellIndex).value = TextCellValue(value);
    //   }
    // });

    var sheet = wb["IA"];
    // debugPrint(componentsMapping);

    sheet.removeColumn(14);

    // outputFile.writeAsBytes(bytes.buffer.asUint8List());

    final excelOutput = wb.save();

    await outputFile.writeAsBytes(excelOutput!);

    // Save changes to the Excel file
    // You may want to save it to a new file or overwrite the existing one
    // For simplicity, I'm just returning the Excel data for further processing
    return excelOutput;
  }
}

// void main() async {
//   // Initialize your controllers and components
//   List<TextEditingController> detailControllers = []; // Populate this list with your detail controllers
//   List<GetComponent> components = []; // Populate this list with your component data

//   // Example usage of CellMapping and ExcelWriter
//   var cellMapping = CellMapping();
//   var detailMappings = cellMapping.getDetailsMapping(detailControllers);
//   var componentMappings = cellMapping.getComponentsMapping(components);

//   var allMappings = {...detailMappings, ...componentMappings};

//   var excelWriter = ExcelWriter('assets/your_excel_file.xlsx', allMappings);

//   var userData = {
//     'name': 'John Doe',
//     // Add other data fields here
//   };

//   // Write data to Excel
//   var excelData = await excelWriter.writeToExcel(userData);

//   // Handle Excel data as needed (e.g., save to a file)
//   File('path_to_output_excel_file.xlsx').writeAsBytesSync(excelData!);
// }
