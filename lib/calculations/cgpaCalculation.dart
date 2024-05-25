import 'package:rxdart/rxdart.dart';

import '../blocs/cgpaBloc.dart';

class CGPACalculation {
  int numberOfSmesters = 0;
  List<CgpaBloc> semesterList = [];
  int totalCreditHours = 0;
  double totalQualityPoints = 0;
  double? cgpa;

  Stream<bool> get _s0 => semesterList[0].semesterValid;
  Stream<bool> get _s1 => semesterList[1].semesterValid;
  Stream<bool> get _s2 => semesterList[2].semesterValid;
  Stream<bool> get _s3 => semesterList[3].semesterValid;
  Stream<bool> get _s4 => semesterList[4].semesterValid;
  Stream<bool> get _s5 => semesterList[5].semesterValid;
  Stream<bool> get _s6 => semesterList[6].semesterValid;
  Stream<bool> get _s7 => semesterList[7].semesterValid;
  Stream<bool> get _s8 => semesterList[8].semesterValid;
  Stream<bool> get _s9 => semesterList[9].semesterValid;

  String get cgpaValue => (cgpa.toString().length > 6)
      ? cgpa.toString().substring(0, 6)
      : cgpa.toString();

  List<Stream> _getsmesterValidationList() {
    switch (numberOfSmesters) {
      case 1:
        return [_s0];
      case 2:
        return [_s0, _s1];
      case 3:
        return [_s0, _s1, _s2];
      case 4:
        return [_s0, _s1, _s2, _s3];
      case 5:
        return [_s0, _s1, _s2, _s3, _s4];
      case 6:
        return [_s0, _s1, _s2, _s3, _s4, _s5];
      case 7:
        return [_s0, _s1, _s2, _s3, _s4, _s5, _s6];
      case 8:
        return [_s0, _s1, _s2, _s3, _s4, _s5, _s6, _s7];
      case 9:
        return [_s0, _s1, _s2, _s3, _s4, _s5, _s6, _s7, _s8];
      case 10:
        return [_s0, _s1, _s2, _s3, _s4, _s5, _s6, _s7, _s8, _s9];
      default:
        return [];
    }
  }

  Stream<bool> get validSemesters =>
      CombineLatestStream(_getsmesterValidationList(), (values) => true);
  void setNoOfSmesters(int number) {
    numberOfSmesters = number;
    for (int i = 0; i < number; i++) {
      semesterList.add(CgpaBloc());
    }
  }

  void calculateCgpa() {
    cgpa = 0;
    totalCreditHours = 0;
    totalQualityPoints = 0;
    for (int i = 0; i < numberOfSmesters; i++) {
      totalCreditHours += semesterList[i].creditHrValue;
      totalQualityPoints += semesterList[i].qualityPtValue;
    }
    cgpa = totalQualityPoints / totalCreditHours;
  }
}

