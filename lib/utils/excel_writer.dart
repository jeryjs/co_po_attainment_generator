import 'dart:convert';
import 'dart:io';

import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/material.dart';

import '../models/cell_mapping.dart';
import '../utils/utils.dart';

class ExcelWriter {
  final CellMapping cm = CellMapping("ExcelWriter");

  Stream<String> writeToExcel() async* {
    final appDir = await getApplicationSupportDirectory();

    // Load the Excel files
    final inputFile = File('assets/input.xlsx');
    final outputName = '${cm.courseCode}/${getFormattedDate(DateTime.now())}';
    final outputFile = File('${appDir.path}/output/$outputName.xlsx');
    outputFile.create(exclusive: true, recursive: true);

    // load the excel-writer.exe
    final excelWriter = File('assets/excel-writer.exe');

    // Define the operations to be performed on the excel file
    List<Map<String, dynamic>> operations = cm.generateOperations();

    // encode the operations to a jsonstring
    final operationsJson = jsonEncode(operations);

    // Start the excelWriter as a separate process
    final process = await Process.start(excelWriter.absolute.path,
        ["v1", operationsJson, inputFile.absolute.path, outputFile.path], runInShell: true);
    
    stdout.addStream(process.stdout);
    // stderr.addStream(process.stderr);

    // Listen to the stderr stream and yield the data
    await for (var data in process.stderr.transform(utf8.decoder)) {
      debugPrint(data);
      yield data;
    }

    debugPrint("Finished writing to file: ${outputFile.lengthSync()}");

    await OpenFile.open(outputFile.path);
  }
}
