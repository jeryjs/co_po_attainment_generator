import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';

import '../models/cell_mapping.dart';
import '../utils/utils.dart';

class ExcelWriter {
  final CellMapping cm = CellMapping("ExcelWriter");

  /// A function that writes data from [CellMapping] to the output excel file.
  /// 
  /// - It uses `github.com/jeryjs/excel-writer` for writing data to the excel file.
  /// 
  /// It returns a stream that can be used to display the progress of the operation.
  /// Once successfully written to excel, it launches the file using the default app.
  Stream<String> writeToExcel() async* {
    final appDir = await getApplicationSupportDirectory();

    // Load the Excel files
    final inputFile = await getFileFromAssets('assets/input.xlsx');
    final outputName = '${cm.courseCode}/${getFormattedDate(DateTime.now())}';
    final outputFile = File('${appDir.path}/output/$outputName.xlsx');
    outputFile.create(exclusive: true, recursive: true);

    // load the excel-writer.exe
    final excelWriter = await getFileFromAssets('assets/excel-writer.exe');

    // Define the operations to be performed on the excel file
    List<Map<String, dynamic>> operations = cm.generateOperations();

    // encode the operations to a jsonstring
    final operationsJson = jsonEncode(operations);

    // Start the excelWriter as a separate process
    final process = await Process.start(excelWriter.absolute.path,
        ["v1", operationsJson, inputFile.path, outputFile.path], runInShell: true);
    
    stdout.addStream(process.stdout);
    // stderr.addStream(process.stderr);

    // Listen to the stderr stream and yield the data
    await for (var data in process.stderr.transform(utf8.decoder)) {
      debugPrint(data);
      yield data;
    }

    debugPrint("Finished writing to file: ${outputFile.lengthSync()}");

    // Launch the output excel with default app.
    await OpenFile.open(outputFile.path);
  }
}
