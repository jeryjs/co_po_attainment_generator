// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'dart:io';

import 'package:flutter/material.dart';

import '/models/cell.dart';
import '/components/widgets.dart';
import '/models/cell_mapping.dart';
import '/screens/3_GeneratePage/generator_history.dart';
import '/utils/excel_writer.dart';

/// `GeneratePage` is a StatefulWidget that represents the page where the Excel file generation takes place.
/// It contains two main sections: a history view and a generate view.
class GeneratePage extends StatefulWidget {
  /// Constructor for GeneratePage. It calls the constructor of its superclass with a key.
  const GeneratePage({super.key});

  /// Checks if the form is filled. Currently, it always returns true.
  /// In future implementations, it can be used to validate the form.
  bool isFilled() {
    return true;
  }

  /// Creates the mutable state for this widget at a given location in the tree.
  @override
  State<GeneratePage> createState() => _GeneratePageState();
}

/// The state associated with a [GeneratePage] widget.
class _GeneratePageState extends State<GeneratePage> {
  /// The file that is imported by the user.
  File? file;

  /// Operations generated for the current page.
  final operations = CellMapping("GeneratePage").generateOperations();

  /// Describes the part of the user interface represented by this widget.
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(flex: 2, child: buildFileHistory()),
        Expanded(flex: 2, child: buildGenerateView()),
      ],
    );
  }

  /// Builds the file history view.
  ///
  /// It is a card containing a list of previously generated files.
  Widget buildFileHistory() {
    return const Card(
      child: Column(
        children: [
          Text(
            "History",
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          Expanded(child: IntrinsicHeight(child: GeneratorHistory())),
        ],
      ),
    );
  }

  /// Builds the generate view.
  ///
  /// It is a card containing a button that triggers the Excel file generation.
  Widget buildGenerateView() {
    return Card(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text("Generate", style: heading),
          buildImportView(),
          buildGenerateButton(),
        ],
      ),
    );
  }

  /// Builds the import view.
  Widget buildImportView() {
    final isFileSelected = file != null;
    final details = CellMapping("GenScrn").detailsMapping[0]["mappings"];
    final name = details[Cell.details.name];
    final courseCode = details[Cell.details.courseCode];
    final subject = '${details[Cell.details.courseName]} (${details[Cell.details.branch]})';

    final scr = MediaQuery.of(context).size;
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.withOpacity(0.8)),
      ),
      height: scr.height * 0.5,
      width: scr.width * 0.35,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          // mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Teacher:',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                Text(name, style: TextStyle(fontSize: 24)),
                            SizedBox(height: 16),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Course Code:',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                Text(courseCode, style: TextStyle(fontSize: 24)),
                SizedBox(height: 16),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Subject:',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                Text(subject, style: TextStyle(fontSize: 24)),
                SizedBox(height: 16),
              ],
            ),
            Expanded(
              child: Align(
                alignment: Alignment.bottomRight,
                child: Chip(
                  label: Text(
                    isFileSelected
                        ? "Imported: ${file.toString()}"
                        : "Imported: nil",
                  ),
                  labelStyle:
                      TextStyle(fontSize: 24, fontWeight: FontWeight.w300),
                  backgroundColor:
                      Theme.of(context).colorScheme.secondaryContainer,
                  avatar: Icon(Icons.upload_file_outlined),
                  deleteIcon: Icon(
                    isFileSelected ? Icons.close : Icons.question_mark,
                    size: 28,
                    weight: 0.1,
                  ),
                  deleteButtonTooltipMessage: isFileSelected
                      ? "Remove this file"
                      : "You can import a file from the History\nto overwrite it with new data.",
                  onDeleted: () => setState(() => file = null),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Padding buildGenerateButton() {
    final scr = MediaQuery.of(context).size;
    return Padding(
      padding: const EdgeInsets.all(18.0),
      child: ElevatedButton(
        style: ButtonStyle(
          minimumSize: MaterialStateProperty.resolveWith(
            (_) => Size(scr.width * 0.35, scr.height * 0.09),
          ),
          backgroundColor: MaterialStateProperty.resolveWith(
            (_) => Theme.of(context).colorScheme.primaryContainer,
          ),
          shape: MaterialStateProperty.resolveWith(
            (_) =>
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
        ),
        onPressed: () async {
          await showGeneratingDialog(ExcelWriter().writeToExcel());
        },
        child: const Text('Generate Excel', style: TextStyle(fontSize: 24)),
      ),
    );
  }

  /// Shows a progress dialog while the excel file is being generated.
  ///
  /// It accepts a [stream] as parameter.
  /// The [stream] data is used to display the progress of the file generation.
  Future<void> showGeneratingDialog(Stream<String> stream) {
    String data = "";
    return showGeneralDialog(
      context: context,
      pageBuilder: (context, anim1, anim2) {
        return AlertDialog(
          title: const Row(
            children: [
              Text("Generating Excel..."),
              CircularProgressIndicator.adaptive(),
            ],
          ),
          content: StreamBuilder<String>(
            stream: stream,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                data += snapshot.data!;
              }
              if (snapshot.connectionState == ConnectionState.done) {
                Navigator.of(context).pop();
              }
              // Wrap the Text widget in 2 scrollViews to enable multi-directional scrolling.
              return SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: SizedBox(
                    width: 300,
                    child: Text(
                      data,
                      softWrap: false,
                      overflow: TextOverflow.fade,
                    ),
                  ),
                ),
              );
            },
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                return;
              },
              child: const Text("Cancel"),
            ),
          ],
        );
      },
    );
  }
}
