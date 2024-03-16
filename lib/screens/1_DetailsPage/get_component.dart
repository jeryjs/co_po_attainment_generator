import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../components/m_text_form.dart';
import '../../components/widgets.dart';

import 'qp_analyser.dart';

/// A Widget that represents a component in the details page.
/// 5 controllers are created at start for each component.
class GetComponent extends StatefulWidget {
  final int index;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final controllers = List<TextEditingController>.generate(5, (index) => TextEditingController(text: null));
  late final qpAnalyser = QpAnalyser(index: index);

  GetComponent({super.key, required this.index});

  /// Checks if the form is filled and validates all textForms.
  bool isFilled() {
    return formKey.currentState!.validate();
  }

  @override
  State<GetComponent> createState() => _GetComponentState();
}

class _GetComponentState extends State<GetComponent> {
  get formKey => widget.formKey;
  List<TextEditingController> get ctrl => widget.controllers;
  get index => widget.index;

  /// A list of dropdown items for the component type.
  final dropdownItems = [
    const DropdownMenuItem(value: 'IA', child: Text('Class Test')),
    const DropdownMenuItem(value: 'QUIZ', child: Text('Quiz')),
    const DropdownMenuItem(value: 'LAB', child: Text('Lab Experiment')),
    const DropdownMenuItem(value: 'EXP L', child: Text('Experiential Learning')),
    // DropdownMenuItem(value: 'SEE', child: Text('Sem End Exam')),
    // DropdownMenuItem(value: 'CSE', child: Text('Course Exit Survey')),
  ];

  /// Restores the text controllers from shared preferences.
  Future<void> _restoreControllers() async {
    final prefs = await SharedPreferences.getInstance();
    for (int i = 0; i < ctrl.length; i++) {
      final text = prefs.getString('get_component_${index}_controller$i');
      if (text != null) ctrl[i].text = text;
    }
    setState(() {});
  }

  /// Saves the text controllers to shared preferences
  Future<void> _saveControllers() async {
    final prefs = await SharedPreferences.getInstance();
    for (int i = 0; i < ctrl.length; i++) {
      await prefs.setString(
          'get_component_${index}_controller$i', ctrl[i].text);
    }
  }

  @override
  void initState() {
    super.initState();
    _restoreControllers();

    // Set the test number to 1 if the component is not IA
    ctrl[0].addListener(() {
      if (ctrl[0].text != "IA") updateCtrl(ctrl[1], 1);
    });
  }
  
  void updateCtrl(ctrl, n) {
    setState(() => ctrl.text = "$n");
  }

  @override
  void deactivate() {
    _saveControllers();
    super.deactivate();
  }

  /// This widget represents a component like Class Test, Quiz, Lab exam, etc.
  /// It is used in the DetailsPage to show the details of a specific component.
  /// Widgets within the FocusTraversalGroup can be navigated in order with the [Tab] key.
  /// It contains a QPAnalyser widget to optionally analyse the QP pattern from a scanned QP.
  /// The QPAnalyser is disabled for all components except IA.
  @override
  Widget build(BuildContext ctx) {
    var isCT = ctrl[0].text != "IA";
    return FocusTraversalGroup(
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SizedBox(
            width: 250,
            child: Form(
              key: formKey,
              child: ListView(
                children: [
                  const SizedBox(height: 8),
                  DropdownButtonFormField<String>(
                    validator: (v) => v == null || v.isEmpty
                        ? 'Required to fill this field'
                        : null,
                    decoration: InputDecoration(
                      labelText: 'Component ${index + 1}:',
                      labelStyle:
                          const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      border: const OutlineInputBorder(),
                    ),
                    items: dropdownItems,
                    value: ctrl[0].text != '' ? ctrl[0].text : null,
                    onChanged: (value) => setState(() => ctrl[0].text = value!),
                  ),
                  const SizedBox(height: 8),
                  MTextForm("Test No.", "Which test is this?", Icons.numbers,
                    isDigits: true, enabled: !isCT, controller: ctrl[1]),
                  const Padding(padding: EdgeInsets.all(16)),
                  MTextForm("No. of Qns", "Num of Qns in Paper", Icons.question_answer_outlined,
                    isDigits: true, controller: ctrl[2]),
                  MTextForm( "Total Marks", "Max marks for Paper", Icons.auto_graph,
                    isDigits: true, controller: ctrl[3]),
                  MTextForm("% of Contribution", "% of weightage", Icons.confirmation_number_outlined,
                    isDigits: true, controller: ctrl[4]),
                  const Padding(padding: EdgeInsets.all(12)),
                  disable(
                    disabled: isCT,
                    child: Column(
                      children: [
                        const Padding(
                          padding: EdgeInsets.all(8),
                          child: Text(
                            'Additionally you can load the qp pattern from a Scanned QP',
                            style: TextStyle(
                              fontSize: 16,
                              fontStyle: FontStyle.italic,
                              fontWeight: FontWeight.w600,
                              color: Colors.blueGrey,
                            ),
                          ),
                        ),
                        widget.qpAnalyser,
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
