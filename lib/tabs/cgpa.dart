import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../Widgets/listHeader.dart';
import '../calculations/cgpaCalculation.dart';
import '../blocs/cgpaBloc.dart';
import '../fontsColorsETC.dart';
import '../screens/PopUp.dart';
import '../screens/calculator.dart';

TextEditingController fname = TextEditingController();
TextEditingController regno = TextEditingController();

bool enableCalculateButton = false;
int smesterCount = 0;
CGPACalculation calculation = CGPACalculation();

class Calculation {
  final String regno;
  final String fname;
  final String totalCreditHours;
  final String totalqualityPoints;
  final String cgpaValue;

  Calculation({
    required this.regno,
    required this.fname,
    required this.totalCreditHours,
    required this.totalqualityPoints,
    required this.cgpaValue,
  });
}

class CGPA extends StatefulWidget {
  const CGPA({super.key});

  @override
  _CGPAState createState() => _CGPAState();
}

class _CGPAState extends State<CGPA> with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  Future<List<Map<String, dynamic>>> _loadcgpa() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? cgpaJson = prefs.getString('cgpa');
    if (cgpaJson == null) {
      return [];
    } else {
      List<dynamic> cgpaList = json.decode(cgpaJson);
      return List<Map<String, dynamic>>.from(cgpaList);
    }
  }

  Future<void> _saveCgpa(Calculation calculation) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<Map<String, dynamic>> cgpa = await _loadcgpa();

    Map<String, dynamic> newCgpa = {
      'regno': regno.text,
      'fname': fname.text,
      'totalQualityPoints': calculation.totalqualityPoints,
      'totalCreditHours': calculation.totalCreditHours,
      'cgpaValue': calculation.cgpaValue,
    };

    cgpa.insert(0, newCgpa);
    String cgpaJson = json.encode(cgpa);
    await prefs.setString('cgpa', cgpaJson);
    setState(() {}); // Refresh the UI
  }

  void _addCgpa() async {
    Calculation newCalculation = Calculation(
      regno: regno.text,
      fname: fname.text,
      totalCreditHours: calculation.totalCreditHours.toString(),
      totalqualityPoints: calculation.totalQualityPoints.toString(),
      cgpaValue: calculation.cgpaValue,
    );

    await _saveCgpa(newCalculation);

    setState(
      () {
        fname.clear();
        regno.clear();
        calculation = CGPACalculation();
        calculation.setNoOfSmesters(0);
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
              child: (calculation.numberOfSmesters > 0)
                  ? const Text('press clear to enter again')
                  : const Text('No of smesters:  '),
            ),
            smesterDropDownButton()
          ],
        ),
        listHeader('Semester', 'Credit Unit', 'Quality Pt'),
        Expanded(
          child: ListView.separated(
            separatorBuilder: (context, index) => const Divider(
              color: Colors.transparent,
            ),
            itemCount: calculation.numberOfSmesters,
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
                    padding: const EdgeInsets.all(4),
                    child: row(calculation.semesterList[index]),
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
              stream: calculation.validSemesters,
              builder: (context, snapshot) {
                return Expanded(
                  child: ElevatedButton(
                    onPressed: (calculation.numberOfSmesters == 0)
                        ? null
                        : (snapshot.hasData && enableCalculateButton == true)
                            ? () {
                                calculation.calculateCgpa();
                                showPopUp(context, _showCgpa(), "CGPA Cgpa");
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
                      calculation = CGPACalculation();
                      calculation.setNoOfSmesters(0);
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
            )
          ],
        )
      ],
    );
  }

  Widget _showCgpa() {
    return Container(
      padding: const EdgeInsets.only(top: 10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
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
              controller: fname,
              decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: 'Full Name',
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
                  hintText: 'Reg No',
                  hintStyle:
                      TextStyle(fontFamily: numberFont, color: numberColor)),
              autofocus: true,
              style: TextStyle(fontFamily: numberFont, color: numberColor),
              keyboardType: TextInputType.text,
            ),
          ),
          _rowForResullt(
              'Credit Hours   :', calculation.totalCreditHours.toString()),
          _rowForResullt(
              'Quality Points :', calculation.totalQualityPoints.toString()),
          _rowForResullt('Cgpa           :', calculation.cgpaValue),
          InkWell(
            onTap: _addCgpa,
            child: _rowForResullt("", 'SAVE'),
          )
        ],
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

  Widget smesterDropDownButton() {
    return DropdownButton<int>(
      value: calculation.numberOfSmesters,
      style: TextStyle(fontFamily: numberFont, color: numberColor),
      onChanged: (value) {
        setState(
          () {
            smesterCount = 1;
            calculation = CGPACalculation();
            calculation.setNoOfSmesters(value!);
          },
        );
      },
      items: (calculation.numberOfSmesters > 0)
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

  Widget row(CgpaBloc bloc) {
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
                hintText: 'Semester ${smesterCount++}',
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
              left: BorderSide(
                color: listLineColor,
              ),
              right: BorderSide(
                color: listLineColor,
              ),
            ),
          ),
          child: Center(
            child:
                numberInputWidget(bloc.creditHour, bloc.changeCreditHour, '00'),
          ),
        ),
        SizedBox(
          width: 100,
          height: 35,
          child: Center(
            child: numberInputWidget(
                bloc.qualityPoint, bloc.changeQualityPoint, '0.0'),
          ),
        ),
      ],
    );
  }

  Widget numberInputWidget(Stream stream, Function changeValue, String hint) {
    return StreamBuilder(
      stream: stream,
      builder: (context, snapshot) {
        return SizedBox(
          width: 50,
          child: Center(
            child: TextField(
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: hint,
                hintStyle: TextStyle(
                  fontFamily: numberFont,
                  color: Colors.purple[200],
                ),
              ),
              onChanged: (value) {
                changeValue(value);
                enableCalculateButton = true;
              },
              autofocus: true,
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
