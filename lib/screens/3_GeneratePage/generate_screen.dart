import 'package:flutter/material.dart';

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
  /// It is a card containing a list of previously generated files.
  Widget buildFileHistory() {
    return const Card(
      child: Column(
        children: [
          Text("History",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          Expanded(child: IntrinsicHeight(child: GeneratorHistory())),
        ],
      ),
    );
  }

  /// Builds the generate view.
  /// It is a card containing a button that triggers the Excel file generation.
  Widget buildGenerateView() {
    return Card(
      child: Column(children: [
        Text("Generate", style: heading),
        ElevatedButton(
          style: fluentUiBtn(context),
          onPressed: () async {
            String data = "";
            showGeneralDialog(
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
                    stream: ExcelWriter().writeToExcel(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        data += snapshot.data!;
                      }
                      if (snapshot.connectionState == ConnectionState.done) {
                        Navigator.of(context).pop();
                      }
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
          },
          child: const Text('Test write to excel'),
        ),
      ]),
    );
  }
}