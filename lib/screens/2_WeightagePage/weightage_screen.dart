import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '/screens/2_WeightagePage/widgets.dart';
import '/components/m_text_form.dart';
import '/components/widgets.dart';
import '/models/cell_mapping.dart';

/// [WeightagePage] is a stateful widget that represents a page where the user can input weightages for different parameters.
/// It contains three forms, each with its own key for validation.
/// The state of the forms is managed by the [_WeightagePageState] class.
class WeightagePage extends StatefulWidget {
  /// List of form keys for validation.
  final List<GlobalKey<FormState>> formKeys =
      List.generate(3, (_) => GlobalKey<FormState>());
  WeightagePage({super.key});

  /// Checks if all input fields are filled and validates them.
  /// Returns true if all fields are filled and valid, false otherwise.
  bool isFilled() {
    for (var formKey in formKeys) {
      if (!formKey.currentState!.validate()) {
        return false;
      }
    }
    return true;
  }

  @override
  State<WeightagePage> createState() => _WeightagePageState();
}

/// [_WeightagePageState] is the state class for [WeightagePage].
/// It manages the state of the text controllers and the cell mapping.
class _WeightagePageState extends State<WeightagePage> {
  /// List of form keys for validation.
  get formKey => widget.formKeys;

  /// List of text controllers for the input fields.
  final ctrl = List.generate(20, (index) => TextEditingController(text: null));

  /// Cell mapping for the weightage.
  final cellMapping = CellMapping("weightage");

  /// Restores the text controllers from shared preferences.
  /// This allows the user to leave the page and come back without losing their input.
  Future<void> _restoreControllers() async {
    // initialize the controllers with default values
    final coLevels = [70, 2.1, 2.1, 2.1, 2.1, 2.1, 2.1];
    final weightages = [80, 20, 50, 50, 20, 5, 10, 10, 20, 50];
    final targets = [50, 50, 50];
    final defaults = coLevels + weightages + targets;

    final prefs = await SharedPreferences.getInstance();
    for (int i = 0; i < ctrl.length; i++) {
      ctrl[i].text = prefs.getString('weightage_controller_$i') ?? defaults[i].toString();
    }
    setState(() {});
  }

  /// Saves the text controllers to shared preferences.
  /// This allows the user to leave the page and come back without losing their input.
  Future<void> _saveControllers() async {
    final prefs = await SharedPreferences.getInstance();
    for (int i = 0; i < ctrl.length; i++) {
      prefs.setString('weightage_controller_$i', ctrl[i].text);
    }
  }

  @override
  initState() {
    super.initState();
    _restoreControllers();

    /// Set CO-Values (ctrl[1-6])'s value to always be 3% of the CO-Target (ctrl[0])
    ctrl[0].addListener(() {
      double value = double.tryParse(ctrl[0].text)! * 3 / 100;
      for (int i = 1; i <= 6; i++) {
        ctrl[i].text = value.toStringAsFixed(2);
      }
    });
  }

  @override
  void deactivate() {
    cellMapping.setWeightageMapping(ctrl);
    _saveControllers();
    super.deactivate();
  }

  @override
  Widget build(BuildContext context) {
    return FocusTraversalGroup(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Expanded(
            flex: 3,
            child: Row(
              children: [
                Expanded(flex: 3, child: buildCoLevels(context)),
                Expanded(flex: 6, child: buildWeightage(context)),
              ],
            ),
          ),
          Expanded(flex: 2, child: buildTargets()),
        ],
      ),
    );
  }

  /// Builds the CO Levels card.
  /// This card contains a form with input fields for the CO levels.
  /// [ctx] is the build context.
  Widget buildCoLevels(BuildContext ctx) {
    return Card(
      child: FocusTraversalGroup(
        child: Form(
          key: formKey[0],
          child: ListView(
            children: [
              Center(
                child: Text("CO Levels", style: heading),
              ),
              const Padding(padding: EdgeInsets.all(4)),
              MTextForm("CO's Target", "Minimum % target for COs",
                  Icons.track_changes,
                  isDigits: true, controller: ctrl[0]),
              const Padding(padding: EdgeInsets.all(12)),
              ListView.builder(
                itemCount: 6,
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  if (index % 2 == 0) {
                    int idx1 = index + 1;
                    int idx2 = index + 2;

                    /// Display the target for COs as two fields per row
                    return Row(
                      children: [
                        Expanded(
                          child: MTextForm("CO$idx1", "CO$idx1 %", null,
                              isDigits: true, controller: ctrl[idx1]),
                        ),
                        const SizedBox(width: 4),
                        Expanded(
                          child: MTextForm("CO$idx2", "CO$idx2 %", null,
                              isDigits: true, controller: ctrl[idx2]),
                        ),
                      ],
                    );
                  } else {
                    return const SizedBox(height: 4);
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Builds the Weightage card.
  /// This card contains a form with input fields for the weightages.
  /// [ctx] is the build context.
  Widget buildWeightage(BuildContext ctx) {
    int idx = 7;
    return Card(
      child: FocusTraversalGroup(
        child: Form(
          key: formKey[1],
          child: ListView(
            // shrinkWrap: true,
            children: [
              Center(
                child: Text(
                  "Weightage",
                  style: heading,
                ),
              ),
              const Padding(padding: EdgeInsets.all(4)),
              Row(children: [
                Expanded(
                    child: MTextForm("Direct", "Direct", Icons.panorama_horizontal,
                        isDigits: true, controller: ctrl[idx++])),
                Expanded(
                    child: MTextForm(
                        "Indirect", "Indirect", Icons.panorama_horizontal_select,
                        isDigits: true, controller: ctrl[idx++])),
              ]),
              Row(children: [
                Expanded(
                    child: MTextForm("Internal Assessment",
                        "Internal Assessment", Icons.note_alt_outlined,
                        isDigits: true, controller: ctrl[idx++])),
                Expanded(
                    child: MTextForm("Semester End Exam", "Semester End Exam",
                        Icons.drive_file_rename_outline_outlined,
                        isDigits: true, controller: ctrl[idx++])),
              ]),
              Row(children: [
                Expanded(
                    child: MTextForm("Class Test", "Class Test", Icons.note,
                        isDigits: true, controller: ctrl[idx++])),
                Expanded(
                    child: MTextForm(
                        "MCQ/Quiz", "MCQ/Quiz", Icons.view_list_outlined,
                        isDigits: true, controller: ctrl[idx++])),
              ]),
              Row(children: [
                Expanded(
                    child: MTextForm("Experience Learning",
                        "Experience Learning", Icons.explicit_outlined,
                        isDigits: true, controller: ctrl[idx++])),
                Expanded(
                    child: MTextForm("Lab/Assignment/Activity",
                        "Lab/Assignment/Activity", Icons.laptop_chromebook,
                        isDigits: true, controller: ctrl[idx++])),
              ]),
              Row(children: [
                Expanded(
                    child: MTextForm("Course Exit Survey", "Course Exit Survey",
                        Icons.countertops_rounded,
                        isDigits: true, controller: ctrl[idx++])),
                Expanded(child: Container()),
              ]),
            ],
          ),
        ),
      ),
    );
  }

  /// Builds the Targets card.
  /// This card contains a form with input fields for the targets.
  Widget buildTargets() {
    final width = MediaQuery.of(context).size.width * 0.1;
    int idx = 16;
    return Card(
      child: Center(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: width),
          child: SingleChildScrollView(
            child: Form(
              key: formKey[2],
              child: Table(
                border: TableBorder.all(
                    width: 0.5,
                    color: Theme.of(context).colorScheme.primary,
                    borderRadius: BorderRadius.circular(24)),
                columnWidths: const {
                  0: FractionColumnWidth(0.7),
                  1: FractionColumnWidth(0.3),
                },
                defaultVerticalAlignment: TableCellVerticalAlignment.bottom,
                children: [
                  const TableRow(children: [
                    Text('When',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 24, fontWeight: FontWeight.bold)),
                    Text('Grade',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 24, fontWeight: FontWeight.bold)),
                  ]),
                  TableRow(children: [
                    WhenTextField('More than 80% of students score:',
                        controller: ctrl[idx++]),
                    const GradeDisplayText(value: '3'),
                  ]),
                  TableRow(children: [
                    WhenTextField('Between 70% and 80% of students score:',
                        controller: ctrl[idx++]),
                    const GradeDisplayText(value: '2'),
                  ]),
                  TableRow(children: [
                    WhenTextField('Less than 70% of students score:',
                        controller: ctrl[idx++]),
                    const GradeDisplayText(value: '1'),
                  ]),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
