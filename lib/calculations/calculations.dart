import 'package:rxdart/rxdart.dart';
import '../blocs/bloc.dart';

class MyCalculation {
  List<Bloc> subjectList = [];
  double? percentage;
  int? totalNumbers;
  int? obtainNumbers;
  double? creditHours;
  double? qualityPoints;
  int numberOfSubjects = 0;
  double? gpa;

  String get percentageStr => (percentage.toString().length > 2)
      ? percentage.toString().substring(0, 4)
      : percentage.toString();
  String get gpaStr => (gpa.toString().length > 4)
      ? gpa.toString().substring(0, 5)
      : gpa.toString();

  Stream<bool> get _s0 => subjectList[0].marksValid;
  Stream<bool> get _s1 => subjectList[1].marksValid;
  Stream<bool> get _s2 => subjectList[2].marksValid;
  Stream<bool> get _s3 => subjectList[3].marksValid;
  Stream<bool> get _s4 => subjectList[4].marksValid;
  Stream<bool> get _s5 => subjectList[5].marksValid;
  Stream<bool> get _s6 => subjectList[6].marksValid;
  Stream<bool> get _s7 => subjectList[7].marksValid;
  Stream<bool> get _s8 => subjectList[8].marksValid;
  Stream<bool> get _s9 => subjectList[9].marksValid;

  List<Stream> _getMarksValidationList() {
    switch (numberOfSubjects) {
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

  Stream<bool> get marksListValidation => CombineLatestStream(
      _getMarksValidationList(), (value) => (value.isNotEmpty) ? true : false);

  void setSubjectNo(int number) {
    numberOfSubjects = number;
    subjectList.clear();
    for (int i = 0; i < number; i++) {
      subjectList.add(Bloc());
    }
  }

  void calculateSumPer() {
    totalNumbers = 0;
    obtainNumbers = 0;

    for (Bloc index in subjectList) {
      totalNumbers = totalNumbers! + index.totalMarksValue;
      obtainNumbers = obtainNumbers! + index.obtainMarksValue;
    }

    if (totalNumbers != 0) {
      percentage = (obtainNumbers! * 100) / totalNumbers!;
    } else {
      percentage = 0;
    }
  }

  void calculateGpa() {
    qualityPoints = 0;
    creditHours = 0;
    List<double> qp = List<double>.filled(numberOfSubjects, 0.0);
    List<double> ch = List<double>.filled(numberOfSubjects, 0.0);

    for (int i = 0; i < numberOfSubjects; i++) {
      if (subjectList[i].totalMarksValue == 100) {
        {
          ch[i] = 5;
        }
        if (subjectList[i].obtainMarksValue >= 80) {
          qp[i] = 20;
        } else {
          switch (subjectList[i].obtainMarksValue) {
            case 79:
              qp[i] = 19.50;
              break;
            case 78:
              qp[i] = 19.50;
              break;
            case 77:
              qp[i] = 19.00;
              break;
            case 76:
              qp[i] = 18.50;
              break;
            case 75:
              qp[i] = 18.50;
              break;
            case 74:
              qp[i] = 18.00;
              break;
            case 73:
              qp[i] = 17.50;
              break;
            case 72:
              qp[i] = 17.50;
              break;
            case 71:
              qp[i] = 17.00;
              break;
            case 70:
              qp[i] = 16.50;
              break;
            case 69:
              qp[i] = 16.50;
              break;
            case 68:
              qp[i] = 16.00;
              break;
            case 67:
              qp[i] = 15.50;
              break;
            case 66:
              qp[i] = 15.50;
              break;
            case 65:
              qp[i] = 15.00;
              break;
            case 64:
              qp[i] = 14.50;
              break;
            case 63:
              qp[i] = 14.50;
              break;
            case 62:
              qp[i] = 14.00;
              break;
            case 61:
              qp[i] = 13.50;
              break;
            case 60:
              qp[i] = 13.50;
              break;
            case 59:
              qp[i] = 13.00;
              break;
            case 58:
              qp[i] = 12.50;
              break;
            case 57:
              qp[i] = 12.50;
              break;
            case 56:
              qp[i] = 12.00;
              break;
            case 55:
              qp[i] = 11.50;
              break;
            case 54:
              qp[i] = 11.50;
              break;
            case 53:
              qp[i] = 11.00;
              break;
            case 52:
              qp[i] = 10.50;
              break;
            case 51:
              qp[i] = 10.50;
              break;
            case 50:
              qp[i] = 10.00;
              break;
            case 49:
              qp[i] = 9.50;
              break;
            case 48:
              qp[i] = 9.00;
              break;
            case 47:
              qp[i] = 8.50;
              break;
            case 46:
              qp[i] = 8.00;
              break;
            case 45:
              qp[i] = 7.50;
              break;
            case 44:
              qp[i] = 7.00;
              break;
            case 43:
              qp[i] = 6.50;
              break;
            case 42:
              qp[i] = 6.00;
              break;
            case 41:
              qp[i] = 5.50;
              break;
            case 40:
              qp[i] = 5.00;
              break;
            default:
              qp[i] = 0;
          }
        }
      } else {
        if (subjectList[i].totalMarksValue == 80) {
          {
            ch[i] = 4;
          }
          if (subjectList[i].obtainMarksValue >= 64) {
            qp[i] = 16;
          } else {
            switch (subjectList[i].obtainMarksValue) {
              case 63:
                qp[i] = 15.60;
                break;
              case 62:
                qp[i] = 15.20;
                break;
              case 61:
                qp[i] = 14.80;
                break;
              case 60:
                qp[i] = 14.80;
                break;
              case 59:
                qp[i] = 14.40;
                break;
              case 58:
                qp[i] = 14.00;
                break;
              case 57:
                qp[i] = 13.60;
                break;
              case 56:
                qp[i] = 13.20;
                break;
              case 55:
                qp[i] = 12.80;
                break;
              case 54:
                qp[i] = 12.40;
                break;
              case 53:
                qp[i] = 12.00;
                break;
              case 52:
                qp[i] = 12.00;
                break;
              case 51:
                qp[i] = 11.60;
                break;
              case 50:
                qp[i] = 11.20;
                break;
              case 49:
                qp[i] = 10.80;
                break;
              case 48:
                qp[i] = 10.80;
                break;
              case 47:
                qp[i] = 10.40;
                break;
              case 46:
                qp[i] = 10.00;
                break;
              case 45:
                qp[i] = 9.60;
                break;
              case 44:
                qp[i] = 9.20;
                break;
              case 43:
                qp[i] = 8.80;
                break;
              case 42:
                qp[i] = 8.80;
                break;
              case 41:
                qp[i] = 8.40;
                break;
              case 40:
                qp[i] = 8.00;
                break;
              case 39:
                qp[i] = 7.60;
                break;
              case 38:
                qp[i] = 7.20;
                break;
              case 37:
                qp[i] = 6.40;
                break;
              case 36:
                qp[i] = 6.00;
                break;
              case 35:
                qp[i] = 5.60;
                break;
              case 34:
                qp[i] = 5.20;
                break;
              case 33:
                qp[i] = 4.40;
                break;
              case 32:
                qp[i] = 4.00;
                break;
              default:
                qp[i] = 0;
            }
          }
        } else {
          if (subjectList[i].totalMarksValue == 60) {
            {
              ch[i] = 3;
            }
            if (subjectList[i].obtainMarksValue >= 48) {
              qp[i] = 12;
            } else {
              switch (subjectList[i].obtainMarksValue) {
                case 47:
                  qp[i] = 11.70;
                  break;
                case 46:
                  qp[i] = 11.40;
                  break;
                case 45:
                  qp[i] = 11.10;
                  break;
                case 44:
                  qp[i] = 10.50;
                  break;
                case 43:
                  qp[i] = 10.20;
                  break;
                case 42:
                  qp[i] = 9.90;
                  break;
                case 41:
                  qp[i] = 9.60;
                  break;
                case 40:
                  qp[i] = 9.30;
                  break;
                case 39:
                  qp[i] = 9.00;
                  break;
                case 38:
                  qp[i] = 8.70;
                  break;
                case 37:
                  qp[i] = 8.40;
                  break;
                case 36:
                  qp[i] = 8.10;
                  break;
                case 35:
                  qp[i] = 7.50;
                  break;
                case 34:
                  qp[i] = 7.20;
                  break;
                case 33:
                  qp[i] = 6.90;
                  break;
                case 32:
                  qp[i] = 6.60;
                  break;
                case 31:
                  qp[i] = 6.30;
                  break;
                case 30:
                  qp[i] = 6.00;
                  break;
                case 29:
                  qp[i] = 5.40;
                  break;
                case 28:
                  qp[i] = 5.10;
                  break;
                case 27:
                  qp[i] = 4.50;
                  break;
                case 26:
                  qp[i] = 3.90;
                  break;
                case 25:
                  qp[i] = 3.60;
                  break;
                case 24:
                  qp[i] = 3.00;
                  break;
                default:
                  qp[i] = 0;
              }
            }
          } else {
            if (subjectList[i].totalMarksValue == 40) {
              {
                ch[i] = 2;
              }
              if (subjectList[i].obtainMarksValue >= 32) {
                qp[i] = 8;
              } else {
                switch (subjectList[i].obtainMarksValue) {
                  case 31:
                    qp[i] = 7.60;
                    break;
                  case 30:
                    qp[i] = 7.40;
                    break;
                  case 29:
                    qp[i] = 7.00;
                    break;
                  case 28:
                    qp[i] = 6.60;
                    break;
                  case 27:
                    qp[i] = 6.40;
                    break;
                  case 26:
                    qp[i] = 6.00;
                    break;
                  case 25:
                    qp[i] = 5.60;
                    break;
                  case 24:
                    qp[i] = 5.40;
                    break;
                  case 23:
                    qp[i] = 5.00;
                    break;
                  case 22:
                    qp[i] = 4.60;
                    break;
                  case 21:
                    qp[i] = 4.40;
                    break;
                  case 20:
                    qp[i] = 4.00;
                    break;
                  case 19:
                    qp[i] = 3.60;
                    break;
                  case 18:
                    qp[i] = 3.00;
                    break;
                  case 17:
                    qp[i] = 2.60;
                    break;
                  case 16:
                    qp[i] = 2.00;
                    break;
                  default:
                    qp[i] = 0;
                    break;
                }
              }
            } else {
              if (subjectList[i].totalMarksValue == 20) {
                {
                  ch[i] = 1;
                }
                if (subjectList[i].obtainMarksValue >= 16) {
                  qp[i] = 4;
                } else {
                  switch (subjectList[i].obtainMarksValue) {
                    case 15:
                      qp[i] = 3.70;
                      break;
                    case 14:
                      qp[i] = 3.30;
                      break;
                    case 13:
                      qp[i] = 3.30;
                      break;
                    case 12:
                      qp[i] = 2.70;
                      break;
                    case 11:
                      qp[i] = 2.30;
                      break;
                    case 10:
                      qp[i] = 2.00;
                      break;
                    case 9:
                      qp[i] = 1.50;
                      break;
                    case 8:
                      qp[i] = 1.00;
                      break;
                    default:
                      qp[i] = 0;
                      break;
                  }
                }
              } else {
                qp[i] = 0;
              }
            }
          }
        }
      }
      creditHours = (creditHours != null) ? creditHours! + ch[i] : creditHours;
      qualityPoints =
          (qualityPoints != null) ? qualityPoints! + qp[i] : qualityPoints;
    }

    gpa = (qualityPoints! / creditHours!);
  }
}
