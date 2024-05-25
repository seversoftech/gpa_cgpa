import 'dart:async';

import 'package:rxdart/rxdart.dart';

class Bloc {
  final _totalMarksController = BehaviorSubject<int>();
  final _obtainMarksController = BehaviorSubject<String>();

  Bloc() {
    changeTotalMarks(100);
    //_obtainMarksController.value='0';
    _totalMarksController.value = 100;
  }

  final StreamTransformer<int, int> _totalMarksValidator =
      StreamTransformer<int, int>.fromHandlers(handleData: (value, sink) {
    sink.add(value);
  });
  final StreamTransformer<String, String> _obtainMarksValidator =
      StreamTransformer<String, String>.fromHandlers(handleData: (value, sink) {
    try {
      int intValue = int.parse(value);
      if (intValue <= 100 && intValue >= 0) {
        sink.add(value);
      } else {
        sink.addError('invalid');
      }
    } catch (exception) {
      sink.addError('invalid');
    }
  });

  Function get changeTotalMarks => _totalMarksController.sink.add;
  Function get changeObtainMarks => _obtainMarksController.sink.add;

  Stream<int> get totalMarks =>
      _totalMarksController.stream.transform(_totalMarksValidator);
  Stream<String> get obtainMarks =>
      _obtainMarksController.stream.transform(_obtainMarksValidator);

  Stream<bool> get marksValid => Rx.combineLatest2(
        totalMarks,
        obtainMarks,
        (t, o) {
          if (obtainMarksValue > totalMarksValue) {
            _totalMarksController.addError("Invalid");
            return true;
          } else {
            return false;
          }
        },
      );

  int get totalMarksValue => _totalMarksController.value;
  int get obtainMarksValue => int.parse(_obtainMarksController.value);
  void dispose() {
    _totalMarksController.value = 100;
    _obtainMarksController.close();
    _totalMarksController.close();
  }
}
