import 'dart:convert';

/// Represents the analysed data of a course.
class AnalysedData {
  String component;
  String testNo;
  String courseName;
  String courseCode;
  String semester;
  List<Map<String, dynamic>> qpPattern;

  AnalysedData._privateConstructor()
      : component = '',
        testNo = '',
        courseName = '',
        courseCode = '',
        semester = '',
        qpPattern = [];

  /// Singleton instance
  static final AnalysedData _instance = AnalysedData._privateConstructor();

  /// Getter for the singleton instance
  static AnalysedData get instance => _instance;

  /// Creates an [AnalysedData] object from a JSON map.
  factory AnalysedData.fromJson(Map<String, dynamic> json) {
    _instance.component = json['compartment'];
    _instance.testNo = json['test_no'];
    _instance.courseName = json['course_name'];
    _instance.courseCode = json['course_code'];
    _instance.semester = json['semester'];
    _instance.qpPattern = List<Map<String, dynamic>>.from(json['qp_pattern']);
    return _instance;
  }

  /// Creates an empty [AnalysedData] object.
  factory AnalysedData.empty() {
    return AnalysedData._privateConstructor();
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
    String qpPatternString = qpPattern.map((pattern) => '\n\t\t\t\t{Q: ${pattern['Q']}, C: ${pattern['C']}, M: ${pattern['M']}}').join(',');

    return '{\n\tcompartment: $component,\n\ttest_no: $testNo,\n\tcourse_name: $courseName,\n\tcourse_code: $courseCode,\n\tsemester: $semester,\n\tqp_pattern: [$qpPatternString\n\t]\n}';
  }
}
