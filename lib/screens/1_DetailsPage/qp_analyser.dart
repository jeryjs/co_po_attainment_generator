import 'dart:convert';
import 'dart:io';
import 'dart:async';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:image/image.dart' as img;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';

import '/models/analysed_data.dart';
import '/utils/utils.dart';

/// A widget that analyses the selected QP using google's gemini AI.
// ignore: must_be_immutable
class QpAnalyser extends StatefulWidget {
  AnalysedData analysedData = AnalysedData.empty();
  final int index;
  
  QpAnalyser({super.key, required this.index});

  @override
  State<QpAnalyser> createState() => _QpAnalyserState();
}

class _QpAnalyserState extends State<QpAnalyser> {
  get analysedData => widget.analysedData;
  List<Uint8List> selectedImages = [];
  int _currentImageIndex = 0;
  Timer? _timer;

  /// Loads the question paper from the device.
  Future<void> _loadQp() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowMultiple: true,
      allowedExtensions: ['jpg', 'jpeg', 'png', 'webp', 'heic', 'heif'],
    );

    if (result != null) {
      List<Uint8List> images = await processFiles(result.files);
      setState(() {
        selectedImages = images;
        _currentImageIndex = 0;
      });
      _restartTimer();
    } else {
      return;
    }

    AnalysedData newAnalysedData = await analyseQPWithGemini(selectedImages);
    setState(() => widget.analysedData = newAnalysedData);
  }

  /// Processes the selected files and returns a list of processed images.
  Future<List<Uint8List>> processFiles(List<PlatformFile> files) async {
    List<Uint8List> processedImages = [];
    for (var file in files) {
      Uint8List? compressedImage = resizeImage(file);
      processedImages.add(compressedImage);
    }
    return processedImages;
  }

  /// Resizes an image to a specific width while maintaining the aspect ratio.
  Uint8List resizeImage(PlatformFile file) {
    final filePath = file.path!;
    img.Image? image = img.decodeImage(File(filePath).readAsBytesSync());
    img.Image? resized = img.copyResize(image!, width: 800);
    Uint8List resizedBytes = img.encodeJpg(resized);
    return resizedBytes;
  }

  /// Restarts the timer to cycle through the selected images.
  void _restartTimer() {
    _timer?.cancel(); // Cancel the previous timer if it's still running
    _timer = Timer.periodic(const Duration(seconds: 2), (timer) {
      setState(() {
        if (selectedImages.isEmpty) return;
        _currentImageIndex = (_currentImageIndex + 1) % selectedImages.length;
      });
    });
  }

  /// Saves the analysed qp data to shared preferences.
  Future<void> _saveAnalysedData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('analysedData_${widget.index}', widget.analysedData.toJson());
  }

  /// Restores the analysed qp data from shared preferences.
  Future<void> _restoreAnalysedData() async {
    final prefs = await SharedPreferences.getInstance();
    final analysedData = prefs.getString('analysedData_${widget.index}');
    if (analysedData != null) {
      widget.analysedData = AnalysedData.fromJson(jsonDecode(analysedData));
      setState(() {});
    }
  }

  @override
  void initState() {
    _restoreAnalysedData();
    super.initState();
  }

  @override
  void deactivate() {
    _timer?.cancel();
    _saveAnalysedData();
    super.deactivate();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      surfaceTintColor: Theme.of(context).colorScheme.error,
      child: Column(
        children: [
          selectedImages.isEmpty && analysedData.isEmpty
            ? buildBrowseView()
            : analysedData.isEmpty
              ? buildAnalysingView()
              : buildResultView(),
            if (selectedImages.isNotEmpty || analysedData.isNotEmpty)
              buildResetButton(),
        ],
      ),
    );
  }

  /// Builds the view for browsing and loading question papers.
  Widget buildBrowseView() {
    return ElevatedButton(
      onPressed: _loadQp,
      style: ButtonStyle(
    backgroundColor: MaterialStateProperty.resolveWith((states) => Theme.of(context).cardColor),
    shape: MaterialStateProperty.resolveWith(
      (states) => RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
    )
  ),
      child: const Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.image, size: 84),
          Text('Load Question Paper'),
        ],
      ),
    );
  }

  /// Builds the view for analyzing the question paper.
  Widget buildAnalysingView() {
    final clr = Theme.of(context).colorScheme;
    final underLayer = Column(
      children: [
        Image.memory(selectedImages[_currentImageIndex]),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () => setState(() {
                  _currentImageIndex > 0
                      ? --_currentImageIndex
                      : _currentImageIndex = selectedImages.length - 1;
                  _restartTimer();
                },
              ),
            ),
            Text('${_currentImageIndex + 1}/${selectedImages.length}'),
            IconButton(
              icon: const Icon(Icons.arrow_forward),
              onPressed: () => setState(() {
                  _currentImageIndex < selectedImages.length - 1
                      ? ++_currentImageIndex
                      : _currentImageIndex = 0;
                  _restartTimer();
                },
              ),
            ),
          ],
        ),
      ],
    );
    return Center(
      child: Card(
        // color: clr.primaryContainer,
        child: Stack(
          children: [
            underLayer,
            Shimmer.fromColors(
              baseColor: clr.primary,
              highlightColor: clr.primaryContainer,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  const Center(
                    child: Column(children: [
                      Text('Analysing image', style: TextStyle(fontSize: 25.0, fontWeight: FontWeight.bold), textAlign: TextAlign.center, overflow: TextOverflow.ellipsis),
                      Text('This process can take upto 25 secs', style: TextStyle(fontSize: 18, fontStyle: FontStyle.italic), textAlign: TextAlign.center),
                    ]),
                  ),
                  Opacity(opacity: 0.4, child: underLayer),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Builds the view for displaying the analysis result.
  Widget buildResultView() {
    return Card(
      color: Theme.of(context).colorScheme.onSecondary,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Text('Component: ${analysedData.component}'),
          // Text('Test No: ${analysedData.testNo}'),
          // Text('Course Name: ${analysedData.courseName}'),
          // Text('Course Code: ${analysedData.courseCode}'),
          // Text('Semester: ${analysedData.semester}'),
          // Text('QpPattern: ${analysedData.qpPattern.map((pattern) => '\n\t\t\t\t[Q: ${pattern['Q']},\t\tC: ${pattern['C']},\t\tM: ${pattern['M']}]').join(',')}\n'),
          Text(analysedData.toString())
        ],
      ),
    );
  }

  /// Builds the reset button.
  Widget buildResetButton() {
    return ElevatedButton(
      onPressed: () {
        setState(() {
          widget.analysedData = AnalysedData.empty();
          selectedImages = [];
          _saveAnalysedData();
          _timer?.cancel();
        });
      },
      style: ButtonStyle(
        minimumSize: MaterialStateProperty.all<Size>(const Size(230, 0)),
        backgroundColor: MaterialStateProperty.all<Color>(Theme.of(context).colorScheme.primaryContainer),
        padding: MaterialStateProperty.all<EdgeInsets>(const EdgeInsets.symmetric(vertical: 16)),
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
      ),
      child: const Text('Reset', style: TextStyle(fontSize: 18), overflow: TextOverflow.ellipsis),
    );
  }
}
