// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:co_po_attainment_v2_1_flutter/components/qp_analyser.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'widgets.dart';

class GetComponent extends StatefulWidget {
  final int index;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  GetComponent({super.key, required this.index});

  bool isFilled() {
    return formKey.currentState!.validate();
  }
  
  @override
  State<GetComponent> createState() => _GetComponentState();
}

class _GetComponentState extends State<GetComponent> {
  get formKey => widget.formKey;
  final ctrl = List<TextEditingController>.generate(5, (index) => TextEditingController(text: null));
  get index => widget.index;

  final dropdownItems = [
    DropdownMenuItem(value: 'Class Test', child: Text('Class Test')),
    DropdownMenuItem(value: 'Lab Experiment', child: Text('Lab Experiment')),
    DropdownMenuItem(value: 'Quiz', child: Text('Quiz')),
    DropdownMenuItem(value: 'Experiential Learning', child: Text('Experiential Learning')),
  ];  

  Future<void> _restoreControllers() async {
    final prefs = await SharedPreferences.getInstance();
    // debugPrint('restoring get_component_${index}_controllers...');
    for (int i = 0; i < ctrl.length; i++) {
      final text = prefs.getString('get_component_${index}_controller$i');
      // debugPrint(text);
      if (text != null) ctrl[i].text = text;
    }
    setState(() {});
    // debugPrint('restored get_component_${index}_controllers: ${ctrl.length}');
  }

  Future<void> _saveControllers() async {
    final prefs = await SharedPreferences.getInstance();
    // debugPrint('saving get_component_${index}_controllers: ${ctrl.length}');
    for (int i = 0; i < ctrl.length; i++) {
      // debugPrint('saving controller $i: ${_ctrl[i].text}');
      await prefs.setString('get_component_${index}_controller$i', ctrl[i].text);
    }
  }
  
  @override
  void initState() {
    _restoreControllers();
    super.initState();
  }

  @override
  void dispose() {
    _saveControllers();
    super.dispose();
  }

  @override
  Widget build(BuildContext ctx) {
    debugPrint('text is: ${ctrl[0].text}');
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
                  SizedBox(height: 8),
                  DropdownButtonFormField<String>(
                    validator: (v) => v == null || v.isEmpty ? 'Required to fill this field' : null,
                    decoration: InputDecoration(
                      labelText: 'Component ${index + 1}:',
                      labelStyle: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      border: OutlineInputBorder(),
                    ),
                    items: dropdownItems,
                    value: ctrl[0].text!=''?ctrl[0].text:null,
                    onChanged: (value) => setState(()=> ctrl[0].text = value!),
                  ),
                  SizedBox(height: 8),
                  textForm("Frequency", "Total num of tests", Icons.numbers, controller: ctrl[1], context: ctx),
                
                  Padding(padding: EdgeInsets.all(16)),
                  textForm("No. of Qns", "Num of Qns in Paper", Icons.question_answer_outlined, controller: ctrl[2], context: ctx),
                  textForm("Total Marks", "Max marks for Paper", Icons.auto_graph, controller: ctrl[3], context: ctx),
                  textForm("% of Contribution", "% of weightage", Icons.confirmation_number_outlined, controller: ctrl[4], context: ctx),
                  
                  Padding(padding: EdgeInsets.all(12)),
                  Padding(
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
                  QpAnalyser(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
