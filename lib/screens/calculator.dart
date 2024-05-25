import 'package:cgpa_calc/tabs/gpa_history.dart';
import 'package:flutter/material.dart';
import '../drawer/menu.dart';
import '../tabs/cgpa.dart';
import '../tabs/cgpa_history.dart';
import '../tabs/gpa.dart';

class Calculator extends StatefulWidget {
  const Calculator({super.key});

  @override
  createState() => CalculatorState();
}

class CalculatorState extends State<Calculator> {
  @override
  Widget build(context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        drawer: const Drawer(
          child: Menu(),
        ),
        body: NestedScrollView(
          headerSliverBuilder: (context, innerBoxIsScrolled) {
            return [
              SliverAppBar(
                title: const Text(
                  'Grade Point Calculator',
                  style: TextStyle(fontFamily: 'myFamily1', fontSize: 24),
                ),
                centerTitle: true,
                pinned: true,
                floating: true,
                forceElevated: innerBoxIsScrolled,
                bottom: TabBar(
                  indicatorColor: Colors.purple[900],
                  indicatorWeight: 3,
                  labelColor: Colors.purple[900],
                  labelStyle: const TextStyle(
                      fontSize: 12,
                      fontStyle: FontStyle.normal,
                      fontWeight: FontWeight.bold),
                  unselectedLabelColor: Colors.black38,
                  unselectedLabelStyle: const TextStyle(
                      fontSize: 12,
                      fontStyle: FontStyle.normal,
                      fontWeight: FontWeight.bold),
                  tabs: const [
                    Tab(text: 'GPA'),
                    Tab(text: 'CGPA'),
                    Tab(text: 'GPA History'),
                    Tab(text: 'CGPA History'),
                  ],
                ),
              ),
            ];
          },
          body: const TabBarView(
            children: [
              Gpa(),
              CGPA(),
              GPAHistory(),
              CGPAHistory(),
            ],
          ),
        ),
      ),
    );
  }
}
