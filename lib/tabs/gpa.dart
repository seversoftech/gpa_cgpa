import 'dart:convert';

import 'package:cgpa_calc/screens/calculator.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Widgets/listHeader.dart';
import '../blocs/bloc.dart';
import '../calculations/calculations.dart';
import '../fontsColorsETC.dart';
import '../screens/PopUp.dart';

int subjectCount = 1;
MyCalculation calculation = MyCalculation();

TextEditingController fname = TextEditingController();
TextEditingController regno = TextEditingController();

bool? enableCalculateButton;

class Calculation {
  final String regno;
  final String fname;
  final String creditHours;
  final String qualityPoints;
  final String obtainNumbers;
  final String totalNumbers;
  final String percentageStr;
  final String gpaStr;

  Calculation({
    required this.regno,
    required this.fname,
    required this.creditHours,
    required this.qualityPoints,
    required this.obtainNumbers,
    required this.totalNumbers,
    required this.percentageStr,
    required this.gpaStr,
  });
}

class Gpa extends StatefulWidget {
  const Gpa({super.key});

  @override
  createState() => _GpaState();
}

class _GpaState extends State<Gpa> with AutomaticKeepAliveClientMixin<Gpa> {
  @override
  bool get wantKeepAlive => true;
  Future<List<Map<String, dynamic>>> _loadResults() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? resultsJson = prefs.getString('results');
    if (resultsJson == null) {
      return [];
    } else {
      List<dynamic> resultsList = json.decode(resultsJson);
      return List<Map<String, dynamic>>.from(resultsList);
    }
  }

  Future<void> _saveResult(Calculation calculation) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<Map<String, dynamic>> results = await _loadResults();

    Map<String, dynamic> newResult = {
      'regno': regno.text,
      'fname': fname.text,
      'creditHours': calculation.creditHours,
      'qualityPoints': calculation.qualityPoints,
      'obtainNumbers': calculation.obtainNumbers,
      'totalNumbers': calculation.totalNumbers,
      'percentageStr': calculation.percentageStr,
      'gpaStr': calculation.gpaStr,
    };

    results.insert(0, newResult);
    String resultsJson = json.encode(results);
    await prefs.setString('results', resultsJson);
    setState(() {}); // Refresh the UI
  }

  void _addResult() async {
    Calculation newCalculation = Calculation(
      regno: regno.text,
      fname: fname.text,
      creditHours: calculation.creditHours.toString(),
      qualityPoints: calculation.qualityPoints.toString(),
      obtainNumbers: calculation.obtainNumbers.toString(),
      totalNumbers: calculation.totalNumbers.toString(),
      percentageStr: calculation.percentageStr,
      gpaStr: calculation.gpaStr,
    );

    await _saveResult(newCalculation);

    setState(
      () {
        fname.clear();
        regno.clear();
        calculation = MyCalculation();
        calculation.setSubjectNo(0);
        enableCalculateButton = false;

        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => const Calculator(),
          ),
        );
      },
    );
  }

  @override
  Widget build(context) {
    super.build(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.only(right: 10),
              child: (calculation.numberOfSubjects > 0)
                  ? const Text('Press clear to enter again')
                  : const Text('No of subjects:  '),
            ),
            myDropDownButton(),
          ],
        ),
        listHeader('Subjects', 'Total Score ', 'Score Obtained '),
        Expanded(
          child: ListView.separated(
            separatorBuilder: (context, index) => const Divider(
              color: Colors.transparent,
            ),
            itemCount: calculation.numberOfSubjects,
            addAutomaticKeepAlives: wantKeepAlive,
            cacheExtent: 600,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 5),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(5),
                  child: Container(
                    height: 45,
                    color: Colors.purple[100],
                    child: row(
                      calculation.subjectList[index],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            StreamBuilder(
              stream: calculation.marksListValidation,
              builder: (context, snapshot) {
                return Expanded(
                  child: ElevatedButton(
                    onPressed: (calculation.numberOfSubjects == 0)
                        ? null
                        : (snapshot.hasData && enableCalculateButton == true)
                            ? () {
                                calculation.calculateSumPer();
                                calculation.calculateGpa();
                                showPopUp(context, _showResult(), "GPA Result");
                              }
                            : null,
                    style: ElevatedButton.styleFrom(
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.zero,
                      ),
                      foregroundColor: Colors.purple[900],
                      backgroundColor: Colors.purple[300],
                      disabledForegroundColor:
                          Colors.purple[500]?.withOpacity(0.38),
                      disabledBackgroundColor:
                          Colors.purple[500]?.withOpacity(0.12),
                      elevation: 0,
                      padding: const EdgeInsets.all(16),
                    ),
                    child: Text(
                      'Calculate',
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: numberColor),
                    ),
                  ),
                );
              },
            ),
            Expanded(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.zero,
                  ),
                  foregroundColor: Colors.purple[900],
                  backgroundColor: Colors.purple[300],
                  disabledForegroundColor:
                      Colors.purple[500]?.withOpacity(0.38),
                  disabledBackgroundColor:
                      Colors.purple[500]?.withOpacity(0.12),
                  elevation: 0,
                  padding: const EdgeInsets.all(16),
                ),
                onPressed: () {
                  setState(
                    () {
                      calculation = MyCalculation();
                      calculation.setSubjectNo(0);
                      enableCalculateButton = false;
                    },
                  );
                },
                child: const Text(
                  'Clear',
                  style: TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.white),
                ),
              ),
            ),
          ],
        )
      ],
    );
  }

  Widget _showResult() {
    return SingleChildScrollView(
      child: Container(
        padding: const EdgeInsets.only(top: 10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              margin: const EdgeInsets.only(left: 5, top: 10, right: 5),
              padding: const EdgeInsets.only(
                left: 10,
                right: 5,
              ),
              decoration: BoxDecoration(
                color: Colors.purple[100],
                borderRadius: const BorderRadius.all(Radius.circular(5.0)),
                border: Border.all(color: listLineColor),
              ),
              child: TextField(
                controller: fname,
                decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: 'Enter full Name',
                    hintStyle:
                        TextStyle(fontFamily: numberFont, color: numberColor)),
                autofocus: true,
                style: TextStyle(fontFamily: numberFont, color: numberColor),
                keyboardType: TextInputType.text,
              ),
            ),
            Container(
              margin: const EdgeInsets.only(left: 5, top: 10, right: 5),
              padding: const EdgeInsets.only(left: 10, right: 5),
              decoration: BoxDecoration(
                color: Colors.purple[100],
                borderRadius: const BorderRadius.all(Radius.circular(5.0)),
                border: Border.all(
                  color: listLineColor,
                ),
              ),
              child: TextField(
                controller: regno,
                decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: 'Enter Matric. No',
                    hintStyle:
                        TextStyle(fontFamily: numberFont, color: numberColor)),
                autofocus: true,
                style: TextStyle(fontFamily: numberFont, color: numberColor),
                keyboardType: TextInputType.text,
              ),
            ),
            _rowForResullt(
                'Credit Hours   :', calculation.creditHours.toString()),
            _rowForResullt(
                'Quality Points :', calculation.qualityPoints.toString()),
            _rowForResullt(
                'Obtain Marks  :', calculation.obtainNumbers.toString()),
            _rowForResullt(
                'Total Marks    :', calculation.totalNumbers.toString()),
            _rowForResullt(
                ' Percentage    :', "${calculation.percentageStr} %"),
            _rowForResullt('GPA           :', calculation.gpaStr),
            InkWell(
              onTap: _addResult,
              child: _rowForResullt("", 'SAVE'),
            )
          ],
        ),
      ),
    );
  }

  Widget _rowForResullt(String name, String value) {
    return Container(
      alignment: Alignment.center,
      margin: const EdgeInsets.only(left: 5, top: 10, right: 5),
      padding: const EdgeInsets.only(left: 10, top: 5, right: 5, bottom: 5),
      decoration: BoxDecoration(
        color: Colors.purple[100],
        borderRadius: const BorderRadius.all(
          Radius.circular(5.0),
        ),
        border: Border.all(
          color: listLineColor,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(
                name,
                style: const TextStyle(
                    fontWeight: FontWeight.normal,
                    fontSize: 15,
                    fontStyle: FontStyle.normal),
              ),
            ],
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                value,
                style: TextStyle(
                  fontFamily: numberFont,
                  color: numberColor,
                  fontSize: 15,
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget myDropDownButton() {
    return DropdownButton<int>(
      value: calculation.numberOfSubjects,
      style: TextStyle(fontFamily: numberFont, color: numberColor),
      onChanged: (value) {
        setState(
          () {
            subjectCount = 1;
            calculation = MyCalculation();
            calculation.setSubjectNo(value!);
          },
        );
      },
      items: (calculation.numberOfSubjects > 0)
          ? null
          : <int>[0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10].map<DropdownMenuItem<int>>(
              (int value) {
                return DropdownMenuItem<int>(
                  value: value,
                  child: Text(
                    value.toString(),
                  ),
                );
              },
            ).toList(),
    );
  }

  Widget row(bloc) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SizedBox(
          width: 100,
          height: 35,
          child: Center(
            child: TextField(
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: 'Subject ${subjectCount++}',
                hintStyle:
                    TextStyle(fontFamily: numberFont, color: numberColor),
              ),
              autofocus: true,
              style: TextStyle(fontFamily: numberFont, color: numberColor),
              keyboardType: TextInputType.text,
            ),
          ),
        ),
        Container(
          width: 100,
          height: 35,
          foregroundDecoration: BoxDecoration(
            border: Border(
              left: BorderSide(color: listLineColor),
              right: BorderSide(color: listLineColor),
            ),
          ),
          child: Center(
            child: dropDownList(bloc),
          ),
        ),
        SizedBox(
          width: 100,
          height: 35,
          child: Center(
            child: numberField(bloc),
          ),
        )
      ],
    );
  }

  Widget dropDownList(bloc) {
    return StreamBuilder(
      stream: bloc.totalMarks,
      builder: (context, snapshot) {
        return DropdownButton(
          value: (snapshot.hasData || snapshot.hasError) ? snapshot.data : 100,
          style: TextStyle(fontFamily: numberFont, color: numberColor),
          onChanged: bloc.changeTotalMarks,
          items: <int>[20, 40, 60, 80, 100].map<DropdownMenuItem<int>>(
            (int value) {
              return DropdownMenuItem(
                value: value,
                child: Text(
                  value.toString(),
                ),
              );
            },
          ).toList(),
        );
      },
    );
  }

  Widget numberField(Bloc bloc) {
    return StreamBuilder(
      stream: bloc.obtainMarks,
      builder: (context, snapshot) {
        return SizedBox(
          width: 50,
          child: Center(
            child: TextField(
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: '00',
                hintStyle: TextStyle(
                  fontFamily: numberFont,
                  color: Colors.purple[200],
                ),
              ),
              onChanged: (value) {
                bloc.changeObtainMarks(value);
                enableCalculateButton = true;
              },
              autofocus: false,
              style: TextStyle(
                  fontFamily: numberFont,
                  color: snapshot.hasError ? Colors.red : numberColor),
              keyboardType: TextInputType.phone,
            ),
          ),
        );
      },
    );
  }
}
