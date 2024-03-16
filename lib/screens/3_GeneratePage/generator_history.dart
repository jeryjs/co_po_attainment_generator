import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:open_file/open_file.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

/// `GeneratorHistory` is a StatefulWidget that displays a history of generated files.
/// It watches for changes in the output directory and updates the UI accordingly.
class GeneratorHistory extends StatefulWidget {
  const GeneratorHistory({super.key});

  @override
  State<GeneratorHistory> createState() => _GeneratorHistoryState();
}

/// `_GeneratorHistoryState` is the state associated with `GeneratorHistory`.
/// It uses `TickerProviderStateMixin` to provide ticker for animations.
class _GeneratorHistoryState extends State<GeneratorHistory> with TickerProviderStateMixin {
  /// [courseFiles] is a map where each key is a course name and the value is a list of associated files.
  Map<String, List<File>> courseFiles = {};
  StreamSubscription<FileSystemEvent>? _subscription;

  @override
  void initState() {
    super.initState();
    watchForChanges();
    getFiles();
  }

  /// `getFiles` is an asynchronous method that fetches all the files from the output directory.
  /// It categorizes the files based on the course and updates the `courseFiles` map.
  Future<void> getFiles() async {
    debugPrint("getFiles");
    final appDir = await getApplicationSupportDirectory();
    final outputDir = Directory('${appDir.path}/output');
    if (!outputDir.existsSync()) return;
    
    final courseDirs = outputDir.listSync().map((e) => Directory(e.path));

    courseFiles.clear();
    for (var courseDir in courseDirs) {
      List<File> files = [];
      for (var file in courseDir.listSync()) {
        final fName = basename(file.path);
        if (fName.endsWith('.xlsx') && !fName.startsWith('~\$')) {
          files.add(file as File);
        }
      }
      if (files.isEmpty) continue; // Skip this Directory if its empty
      courseFiles[basename(courseDir.path)] = files;
      setState(() {});
    }
  }

  /// `watchForChanges` is an asynchronous method that watches for changes in the output directory.
  /// It triggers `getFiles` method and updates the state whenever a change is detected.
  void watchForChanges() async {
    final appDir = await getApplicationSupportDirectory();
    final outputDir = Directory(appDir.path);

    _subscription = outputDir.watch(recursive: true).listen((event) {
      if (event.type != FileSystemEvent.modify) {
        getFiles();
        setState(() {});
      }
    });
  }

  @override
  void deactivate() {
    _subscription?.cancel();
    super.deactivate();
  }

  @override
  Widget build(BuildContext context) {
    // getFiles();
    return courseFiles.isNotEmpty
        ? buildCourseView(context)
        : buildEmptyView(context);
  }

  /// `buildCourseView` is a method that builds the UI for displaying the course files.
  /// It takes [context] as a parameter and returns a `ListView` widget.
  Widget buildCourseView(BuildContext context) {
    final clr = Theme.of(context).colorScheme;
    return ListView(
      children: courseFiles.entries.map((entry) {
        final scrollCtrl = ScrollController();
        final course = entry.key;
        final files = entry.value;
        final count = files.length;
        return ExpansionTile(
          // Display course index number
          leading: Text(
            '${courseFiles.keys.toList().indexOf(course) + 1}.',
            style: const TextStyle(fontSize: 24),
          ),
          title: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              course,
              style: TextStyle(fontSize: 34, color: clr.secondary),
            ),
          ),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(count.toString()),
              const Icon(Icons.arrow_drop_down, size: 32),
            ],
          ),
          onExpansionChanged: (_) {
            // Scroll to the bottom of after the list has expanded
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (scrollCtrl.hasClients) {
                scrollCtrl.animateTo(
                  scrollCtrl.position.maxScrollExtent,
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.decelerate,
                );
              }
            });
          },
          children: [
            // Show only 3 files at time
            SizedBox(
              height: 50.0 * (count < 3 ? count : 2),
              child: Card(
                elevation: 2,
                child: filesBuilder(context, scrollCtrl, files),
              ),
            ),
          ],
        );
      }).toList(),
    );
  }

  /// `filesBuilder` is a method that builds the UI for displaying the files of a course.
  /// It takes [context], [ctrl] (ScrollController), and [files] (List of files) as parameters
  ///  and returns a `ListView.builder` widget.
  Widget filesBuilder(BuildContext context, ScrollController ctrl, List files) {
    return ListView.builder(
      controller: ctrl,
      itemCount: files.length,
      itemBuilder: (ctx, index) {
        final file = files[index] as File;
        final animCtrl = AnimationController(
          duration: const Duration(milliseconds: 300),
          vsync: this,
        );
        return ScaleTransition(
          scale: Tween<double>(
            begin: 1,
            end: 0,
          ).animate(animCtrl),
          child: ListTile(
            leading: Text(
              '${index + 1}.',
              style: const TextStyle(fontSize: 16),
            ),
            title: Text(basenameWithoutExtension(file.toString())),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(Icons.delete_outlined),
                  tooltip: "Delete",
                  onPressed: () {
                    animCtrl.forward();
                    try {
                      file.deleteSync();
                    } on FileSystemException catch (e) {
                      final err = e;
                      showDialog(
                          context: ctx,
                          builder: (ctx) {
                            return AlertDialog(
                                title: Text(err.message),
                                content: Text(err.osError.toString()));
                          });
                      animCtrl.reverse();
                    }
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.open_in_new),
                  tooltip: "Open",
                  onPressed: () => OpenFile.open(file.path),
                ),
                ElevatedButton.icon(
                  icon: const Icon(Icons.arrow_circle_right_outlined),
                  label: const Text("Import"),
                  onPressed: () {},
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  /// `buildEmptyView` is a method that builds the UI for the empty state.
  /// It takes [context] as a parameter and returns a `Card` widget.
  Widget buildEmptyView(BuildContext context) {
    return Card(
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(
            Icons.hourglass_empty,
            size: 84,
            color: Theme.of(context).colorScheme.primary,
          ),
          // SizedBox(),
          Text(
            "You haven't Generated\n any files yet...",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
        ],
      ),
    );
  }
}
