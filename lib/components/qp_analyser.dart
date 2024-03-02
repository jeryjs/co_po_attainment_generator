// ignore_for_file: prefer_const_constructors, sort_child_properties_last, prefer_const_literals_to_create_immutables, unused_field

import 'dart:io';
import 'dart:async';
import 'dart:typed_data';

import 'package:co_po_attainment_v2_1_flutter/models/cell_mapping.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:image/image.dart' as img;
import 'package:pdfx/pdfx.dart';
import 'package:shimmer/shimmer.dart';

import '../models/analysed_data.dart';
import '../utils/utils.dart';

// ignore: must_be_immutable
class QpAnalyser extends StatefulWidget {
  QpAnalyser({super.key});
  AnalysedData analysedData = AnalysedData.empty();

  @override
  State<QpAnalyser> createState() => _QpAnalyserState();
}

class _QpAnalyserState extends State<QpAnalyser> {
  get analysedData => widget.analysedData;
  List<Uint8List> selectedImages = [];
  int _currentImageIndex = 0;
  Timer? _timer;

  Future<void> _loadQp() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowMultiple: true,
      allowedExtensions: ['jpg', 'png', 'webp', 'heic', 'heif'],
    );

    if (result != null) {
      List<Uint8List> images = await processFiles(result.files);
      setState(() {
        selectedImages = images;
        _currentImageIndex = 0;
      });
      _restartTimer();
    }

    AnalysedData newAnalysedData = await analyseQPWithGemini(selectedImages);
    setState(() => widget.analysedData = newAnalysedData);
    debugPrint(analysedData.toString());
  }

  Future<List<Uint8List>> processFiles(List<PlatformFile> files) async {
    List<Uint8List> processedImages = [];
    for (var file in files) {
      if (file.extension == 'pdf') {
        List<Uint8List> pdfImages = await convertPdfToImages(file);
        processedImages.addAll(pdfImages);
      } else {
        Uint8List? compressedImage = resizeImage(file);
        processedImages.add(compressedImage);
      }
    }
    return processedImages;
  }

  Future<List<Uint8List>> convertPdfToImages(PlatformFile pdfFile) async {
    final pdfDocument = await PdfDocument.openFile(pdfFile.path!);
    final pageCount = pdfDocument.pagesCount;
    debugPrint('pages: $pageCount');

    final List<Uint8List> images = [];
    for (int i = 1; i <= pageCount; i++) {
      final page = await pdfDocument.getPage(i);
      final pageImage = await page.render(width: 800, height: 1130);
      images.add(pageImage!.bytes);
    }

    await pdfDocument.close();

    return images;
  }

  Uint8List resizeImage(PlatformFile file) {
    final filePath = file.path!;
    img.Image? image = img.decodeImage(File(filePath).readAsBytesSync());
    img.Image? resized = img.copyResize(image!, width: 800);
    Uint8List resizedBytes = img.encodeJpg(resized);
    return resizedBytes;
  }

  void _restartTimer() {
    _timer?.cancel(); // Cancel the previous timer if it's still running
    _timer = Timer.periodic(Duration(seconds: 2), (timer) {
      setState(() {
        _currentImageIndex = (_currentImageIndex + 1) % selectedImages.length;
      });
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      surfaceTintColor: Theme.of(context).colorScheme.error,
      child: Column(
        children: [
          selectedImages.isEmpty 
            ? buildBrowseView()
            : analysedData.isEmpty
              ? buildAnalysingView()
              : buildResultView(),
            if (selectedImages.isNotEmpty)
              buildResetButton(),
        ],
      ),
    );
  }

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
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.image, size: 84),
          Text('Load Question Paper'),
        ],
      ),
    );
  }

  Widget buildAnalysingView() {
    final clr = Theme.of(context).colorScheme;
    final underLayer = Column(
      children: [
        Image.memory(selectedImages[_currentImageIndex]),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
              icon: Icon(Icons.arrow_back),
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
              icon: Icon(Icons.arrow_forward),
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
                  Center(
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

  Widget buildResetButton() {
    return ElevatedButton(
      onPressed: () {
        setState(() {
          widget.analysedData = AnalysedData.empty();
          selectedImages = [];
          _timer!.cancel();
        });
      },
      style: ButtonStyle(
        minimumSize: MaterialStateProperty.all<Size>(Size(230, 0)),
        backgroundColor: MaterialStateProperty.all<Color>(Theme.of(context).colorScheme.primaryContainer),
        padding: MaterialStateProperty.all<EdgeInsets>(const EdgeInsets.symmetric(vertical: 16)),
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
      ),
      child: Text('Reset', style: TextStyle(fontSize: 18), overflow: TextOverflow.ellipsis),
    );
  }
}
