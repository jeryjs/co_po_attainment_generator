// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors, unused_local_variable

import 'package:flutter/material.dart';

import 'widgets.dart';

class GetDetails extends StatefulWidget {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  GetDetails({super.key});

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
  final _ctrl = List<TextEditingController>.generate(20, (index) => TextEditingController(text: null));
  get _formKey => widget.formKey;

  @override
  Widget build(BuildContext ctx) {
    final scr = MediaQuery.of(ctx).size;
    return Card(
      // color: Colors.green.withOpacity(0.1),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: buildInformationForm(ctx),
      ),
    );
  }

  Widget buildInformationForm(ctx) {
    return FocusTraversalGroup(
      child: Form(
        key: _formKey,
        child: ListView(
          children: [
            Text('Basic Information:', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            textForm("Name", "Enter Teacher's Name", Icons.person, controller: _ctrl[0], context: ctx),
            textForm("Designation", "Ex: Asst. Professor", Icons.art_track_sharp, controller: _ctrl[1], context: ctx),
        
            Padding(padding: EdgeInsets.all(8)),
            Text('Subject Information:', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            textForm("Course Name", "Ex: Calculus and Matrix Algebra", Icons.book, controller: _ctrl[2], context: ctx),
            textForm("Course Code", "Ex: 22BS1MA01", Icons.menu_book, controller: _ctrl[3], context: ctx),
            textForm("Branch/Section", "Ex: CSE-AI/1", Icons.library_books_outlined, controller: _ctrl[4], context: ctx),
            textForm("Academic Year", "Ex: 2023", Icons.calendar_today_outlined, isDigits: true, controller: _ctrl[5], context: ctx),
            
            Padding(padding: EdgeInsets.all(8)),
            Text('Number of:', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            textForm("CO’s:", "Enter Number of CO's", Icons.book, isDigits: true, controller: _ctrl[6], context: ctx),
            textForm("PO’s:", "Enter Number of PO's", Icons.menu_book, isDigits: true, controller: _ctrl[7], context: ctx),
            textForm("PSO’s:", "Enter Number of PSO's", Icons.library_books_outlined, isDigits: true, controller: _ctrl[8], context: ctx),
          ],
        ),
      ),
    );
  }
}
