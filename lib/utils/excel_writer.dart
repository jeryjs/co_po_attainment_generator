import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';

import '../models/cell_mapping.dart';
import '../utils/utils.dart';

/// This class holds the logic for writing data to an excel file.
class ExcelWriter {
  final CellMapping cm = CellMapping("ExcelWriter");

  /// A function that writes data from [CellMapping] to the output excel file.
  /// 
  /// - It uses `github.com/jeryjs/excel-writer` for writing data to the excel file.
  /// 
  /// It can accept a [inputFile] if a previously created excel file is to be used as a template.
  /// If no file is passed or the file is null, it will be created using the default template.
  /// 
  /// It returns a [Stream] that can be used to display the progress of the operation.
  /// Once successfully written to excel, it launches the file using the default app.
  Stream<String> writeToExcel(File? inputFile) async* {
    final appDir = await getApplicationSupportDirectory();

    // Load the Excel files
    inputFile ??= await getFileFromAssets('assets/input.xlsx');
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
        ["-v", "v1", "-op", operationsJson, "-i", inputFile.path, "-o", outputFile.path]);
    
    // stdout.addStream(process.stdout);
    stderr.addStream(process.stderr);

    // Listen to the stdout stream and yield the data
    await for (var data in process.stdout.transform(utf8.decoder)) {
      debugPrint(data);
      yield data;
    }

    debugPrint("Finished writing to file: ${outputFile.lengthSync()}");

    // Launch the output excel with default app.
    await OpenFile.open(outputFile.path);
  }
}
