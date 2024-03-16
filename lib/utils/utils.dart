import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

import '../models/analysed_data.dart';

/// Analyzes the question paper with Gemini AI.
/// Returns the analyzed data.
Future<AnalysedData> analyseQPWithGemini(List<Uint8List> images) async {
  AnalysedData result = AnalysedData();

  // Create a GenerativeModel instance with the Gemini model and API key
  // ignore: unused_local_variable
  final model = GenerativeModel(
    model: 'gemini-1.0-pro-vision-latest',
    apiKey: await rootBundle.loadString('assets/api/google.key'),
    generationConfig: GenerationConfig(
      candidateCount: 1,
      temperature: 0.5,
      topP: 1.0,
      topK: 40,
    ),
  );

  // Example images for training the AI model.
  final exampleImages = [
    await File("assets/samples/IA/1/1.jpg").readAsBytes(),
    await File("assets/samples/IA/1/2.jpg").readAsBytes(),
    await File("assets/samples/IA/1/3.jpg").readAsBytes(),
    await File("assets/samples/IA/2/1.jpg").readAsBytes(),
  ];

  // Prompt for the analysis
  final prompt = [
    TextPart('''You are a helper that accepts Question paper image as input and analyse the image to give ur output as a array containing map of the Qn Number, Course outcome and marks as {Q, C, M}.The marks are specified at the start of a set of questions.For each question, there's a specified course outcome.You also provide additional data about the analysed qp image, such as the 'compartment' (one of "Internal Assessment", "Quiz", "Lab Experiment" or 'null' if u dont know), 'test_no' (usually indicated along with compartment), 'course_name' (as given in qp, else null), 'course_code' (also as given in qp, else null) and semester (also as given in qp, else null). It's possible for the numbers to sometimes be given in roman numerals too.'''),
    TextPart('Question Paper: '), ...exampleImages.sublist(0, 3).map((img) => DataPart('image/jpeg', img)),
    TextPart('Question Paper Analysis: {    "compartment": "Internal Assessment",    "test_no": "5",    "course_name": "Calculus and Matrix algebra",    "course_code": "22BS1MA01",    "semester": "1",    "qp_pattern": [        { "Q": 1, "C": 1, "M": 2 },        { "Q": 2, "C": 1, "M": 2 },        { "Q": 3, "C": 1, "M": 2 },        { "Q": 4, "C": 6, "M": 2 },        { "Q": 5, "C": 6, "M": 2 },        { "Q": 6, "C": 6, "M": 2 },        { "Q": 7, "C": 2, "M": 2 },        { "Q": 8, "C": 2, "M": 2 },        { "Q": 9, "C": 2, "M": 2 },        { "Q": 10, "C": 5, "M": 2 },        { "Q": 11, "C": 5, "M": 2 },        { "Q": 12, "C": 5, "M": 2 },        { "Q": 13, "C": 5, "M": 2 },        { "Q": 14, "C": 5, "M": 2 },        { "Q": 15, "C": 5, "M": 2 },        { "Q": 16, "C": 5, "M": 10 },        { "Q": 17, "C": 5, "M": 10 }    ]}'''),
    TextPart('Question Paper: '), ...exampleImages.sublist(3, 4).map((img) => DataPart('image/jpeg', img)),
    TextPart('Question Paper Analysis: {    "compartment": "Internal Assessment",    "test_no": "2",    "course_name": "Computer Architecture",    "course_code": "22CSE154",    "semester": "3",    "qp_pattern": [        { "Q": 1, "C": 4, "M": 2 },        { "Q": 2, "C": 4, "M": 2 },        { "Q": 3, "C": 4, "M": 2 },        { "Q": 4, "C": 4, "M": 2 },        { "Q": 5, "C": 4, "M": 2 },        { "Q": 6, "C": 3, "M": 5 },        { "Q": 7, "C": 3, "M": 5 },        { "Q": 8, "C": 5, "M": 5 },        { "Q": 9, "C": 5, "M": 5 },        { "Q": 10, "C": 4, "M": 5 },        { "Q": 11, "C": 4, "M": 10 },        { "Q": 12, "C": 4, "M": 10 },        { "Q": 13, "C": 5, "M": 10 }    ]}'''),
    TextPart('Question Paper: '), ...images.map((img) => DataPart('image/jpeg', img)),
    TextPart('Question Paper Analysis: '),
  ];

  try {
    final startTime = DateTime.now().millisecondsSinceEpoch;
    debugPrint('Generating Analysis: $startTime');
    // Generate content using the model and prompt
    final response = await model.generateContent([Content.multi(prompt)]);
    final text = response.text!;
    // const text = '{    "compartment": "Internal Assessment",    "test_no": "5",    "course_name": "Calculus and Matrix algebra",    "course_code": "22BS1MA01",    "semester": "1",    "qp_pattern": [        { "Q": 1, "C": 1, "M": 2 },        { "Q": 2, "C": 1, "M": 2 },        { "Q": 3, "C": 1, "M": 2 },        { "Q": 4, "C": 6, "M": 2 },        { "Q": 5, "C": 6, "M": 2 },        { "Q": 6, "C": 6, "M": 2 },        { "Q": 7, "C": 2, "M": 2 },        { "Q": 8, "C": 2, "M": 2 },        { "Q": 9, "C": 2, "M": 2 },        { "Q": 10, "C": 5, "M": 2 },        { "Q": 11, "C": 5, "M": 2 },        { "Q": 12, "C": 5, "M": 2 },        { "Q": 13, "C": 5, "M": 2 },        { "Q": 14, "C": 5, "M": 2 },        { "Q": 15, "C": 5, "M": 2 },        { "Q": 16, "C": 5, "M": 10 },        { "Q": 17, "C": 5, "M": 10 }    ]}';
    // const text = '{    "compartment": "Internal Assessment",    "test_no": "2",    "course_name": "Computer Architecture",    "course_code": "22CSE154",    "semester": "3",    "qp_pattern": [        { "Q": 1, "C": 4, "M": 2 },        { "Q": 2, "C": 4, "M": 2 },        { "Q": 3, "C": 4, "M": 2 },        { "Q": 4, "C": 4, "M": 2 },        { "Q": 5, "C": 4, "M": 2 },        { "Q": 6, "C": 3, "M": 5 },        { "Q": 7, "C": 3, "M": 5 },        { "Q": 8, "C": 5, "M": 5 },        { "Q": 9, "C": 5, "M": 5 },        { "Q": 10, "C": 4, "M": 5 },        { "Q": 11, "C": 4, "M": 10 },        { "Q": 12, "C": 4, "M": 10 },        { "Q": 13, "C": 5, "M": 10 }    ]}';
    // await Future.delayed(const Duration(seconds: 2));
    debugPrint(text);
    result = AnalysedData.fromJson(jsonDecode(text));
    final elapsedTime = DateTime.now().millisecondsSinceEpoch - startTime;
    debugPrint('Time Taken: $elapsedTime ms');
  } catch (e) {
    result.error = e;
    debugPrint(e.toString());
  }
  return result;
}

/// Returns the Excel Style column name based on the[start] column and [n] no. of cols after it.
///
/// `Example: getColName('A', 1) => 'B'`
/// `Example: getColName('YA', 10) => 'YK'`
String getColName(String start, int n) {
  int ascii = start.codeUnitAt(0);
  ascii += n;

  if (ascii > 90) {
    int overflow = ascii - 90;
    int firstChar = 64 + (overflow / 26).floor();
    int secondChar = 64 + (overflow % 26);
    if (secondChar == 64) {
      firstChar -= 1;
      secondChar = 90;
    }
    return String.fromCharCode(firstChar + 1) + String.fromCharCode(secondChar);
  } else {
    return String.fromCharCode(ascii);
  }
}

String getFormattedDate(DateTime now) {
  final year = now.year;
  final month = now.month.toString().padLeft(2, '0');
  final day = now.day.toString().padLeft(2, '0');
  final hour = now.hour.toString().padLeft(2, '0');
  final minute = now.minute.toString().padLeft(2, '0');
  final second = now.second.toString().padLeft(2, '0');
  return '$year-$month-${day}_$hour-$minute-$second';
}
