import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '/components/m_text_form.dart';
import '/components/widgets.dart';
import '/models/cell_mapping.dart';

/// A widget that allows the user to input details such as name, designation, course information, etc.
class GetDetails extends StatefulWidget {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final ctrl = List<TextEditingController>.generate(10, (index) => TextEditingController(text: null));

  GetDetails({super.key});

  /// Checks if the form is filled and validates all input fields.
  bool isFilled() {
    if (formKey.currentState!.validate()) {
      return true;
    } else {
      return false;
    }
  }

  @override
  State<GetDetails> createState() => _GetDetailsState();
}

class _GetDetailsState extends State<GetDetails> {
  get ctrl => widget.ctrl; 
  get formKey => widget.formKey;

  /// Restores the text controllers from shared preferences.
  Future<void> _restoreControllers() async {
    final prefs = await SharedPreferences.getInstance();
    for (int i = 0; i < ctrl.length; i++) {
      ctrl[i].text = prefs.getString('get_details_controller_$i') ?? '';
    }
    setState(() {});
  }

  /// Saves the text controllers to shared preferences.
  Future<void> _saveControllers() async {
    final prefs = await SharedPreferences.getInstance();
    for (int i = 0; i < ctrl.length; i++) {
      prefs.setString('get_details_controller_$i', ctrl[i].text);
    }
  }
  
  @override
  void initState() {
    super.initState();
    _restoreControllers();
  }

  @override
  void deactivate() {
    _saveControllers();
    CellMapping("GetDetails").setDetailsMapping(ctrl);
    super.deactivate();
  }

  @override
  Widget build(BuildContext ctx) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: buildInformationForm(ctx),
      ),
    );
  }

  /// Builds the information form.
  Widget buildInformationForm(ctx) {
    int idx = 0;  // index for first controller
    return FocusTraversalGroup(
      child: Form(
        key: formKey,
        child: ListView(
          children: [
            Text('Basic Information:', style: heading),
            MTextForm("Name", "Enter Teacher's Name", Icons.person, controller: ctrl[idx++]),
            MTextForm("Designation", "Ex: Asst. Professor", Icons.art_track_sharp, controller: ctrl[idx++]),
        
            const Padding(padding: EdgeInsets.all(8)),
            Text('Subject Information:', style: heading),
            MTextForm("Course Name", "Ex: Calculus and Matrix Algebra", Icons.book, controller: ctrl[idx++]),
            MTextForm("Course Code", "Ex: 22BS1MA01", Icons.menu_book, controller: ctrl[idx++]),
            MTextForm("Branch/Section", "Ex: CSE-AI/1", Icons.library_books_outlined, controller: ctrl[idx++]),
            MTextForm("Semester", "Ex: 4", Icons.calendar_today_outlined, isDigits: true, controller: ctrl[idx++]),
            MTextForm("Academic Year", "Ex: 2023", Icons.calendar_today_outlined, isDigits: true, controller: ctrl[idx++]),
            
            const Padding(padding: EdgeInsets.all(8)),
            Text('Number of:', style: heading),
            MTextForm("CO’s:", "Enter Number of CO's", Icons.book, isDigits: true, controller: ctrl[idx++]),
            // textForm("PO’s:", "Enter Number of PO's", Icons.menu_book, isDigits: true, controller: ctrl[idx++]),
            // textForm("PSO’s:", "Enter Number of PSO's", Icons.library_books_outlined, isDigits: true, controller: ctrl[idx++]),
          ],
        ),
      ),
    );
  }
}
