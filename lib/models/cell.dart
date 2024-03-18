class Cell {
  static final details = Details();
  static final components = Components();
  static final weightage = Weightage();
}

class Details {
  String name = 'C6';
  String designation = 'C7';
  String courseName = 'C8';
  String courseCode = 'C9';
  String branch = 'C10';
  String semester = 'C11';
  String academicYear = 'C12';
  String noOfCOs = 'B21';
}

class Components {
  String contribution = '..'; // TODO: find out the cell.
}

class Weightage {
  String coTarget = 'K6';
  List<String> cos = ['B21', 'C21', 'D21', 'E21', 'F21', 'G21'];

  String direct = 'D6';
  String indirect = 'D7';
  String internalAssessment = 'D8';
  String semEndExam = 'D9';
  String classTest = 'D10';
  String mcqOrQuiz = 'D11';
  String expLearning = 'D12';
  String labAssignmentActivity = 'D13';
  String courseExitSurvey = 'D14';
}