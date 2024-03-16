import 'dart:convert';

/// Represents the analysed data of a course.
class AnalysedData {
  String component;
  String testNo;
  String courseName;
  String courseCode;
  String semester;
  List<Map<String, dynamic>> qpPattern;

  Object? error;

  /// Constructs an [AnalysedData] object.
  AnalysedData({
    this.component = '',
    this.testNo = '',
    this.courseName = '',
    this.courseCode = '',
    this.semester = '',
    this.qpPattern = const [],
  });

  /// Creates an [AnalysedData] object from a JSON map.
    factory AnalysedData.fromJson(Map<String, dynamic> json) {
      return AnalysedData(
        component: json['compartment'],
        testNo: json['test_no'],
        courseName: json['course_name'],
        courseCode: json['course_code'],
        semester: json['semester'],
        qpPattern: List<Map<String, dynamic>>.from(json['qp_pattern']),
      );
    }

  /// Creates an empty [AnalysedData] object.
  factory AnalysedData.empty() {
    return AnalysedData();
  }

  /// Checks if the [AnalysedData] object is empty.
  bool get isEmpty {
    return component.isEmpty &&
        testNo.isEmpty &&
        courseName.isEmpty &&
        courseCode.isEmpty &&
        semester.isEmpty &&
        qpPattern.isEmpty;
  }

  /// Checks if the [AnalysedData] object is not empty.
  bool get isNotEmpty {
    return component.isNotEmpty ||
        testNo.isNotEmpty ||
        courseName.isNotEmpty ||
        courseCode.isNotEmpty ||
        semester.isNotEmpty ||
        qpPattern.isNotEmpty;
  }

  /// Converts the [AnalysedData] object to a JSON string.
  String toJson() {
    final json = jsonEncode({
      'compartment': component,
      'test_no': testNo,
      'course_name': courseName,
      'course_code': courseCode,
      'semester': semester,
      'qp_pattern': qpPattern,
    });
    return json;
  }

  @override
  String toString() {
    String qpPatternString = qpPattern
        .map((pattern) =>
            '\n\t\t\t\t{Q: ${pattern['Q']}, C: ${pattern['C']}, M: ${pattern['M']}}')
        .join(',');

    return error != null
        ? error.toString()
        : '{\n\tcompartment: $component,\n\ttest_no: $testNo,\n\tcourse_name: $courseName,\n\tcourse_code: $courseCode,\n\tsemester: $semester,\n\tqp_pattern: [$qpPatternString\n\t]\n}';
  }
}
