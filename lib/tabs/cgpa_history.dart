import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CGPAHistory extends StatefulWidget {
  const CGPAHistory({super.key});

  @override
  _CGPAHistoryState createState() => _CGPAHistoryState();
}

class _CGPAHistoryState extends State<CGPAHistory> {
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

  Future<void> _removeResult(int index) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<Map<String, dynamic>> cgpa = await _loadcgpa();
    cgpa.removeAt(index);
    String cgpaJson = json.encode(cgpa);
    await prefs.setString('cgpa', cgpaJson);
    setState(() {}); // Refresh the UI
  }

  Future<void> _clearcgpa() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('cgpa');
    setState(() {}); // Refresh the UI
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _loadcgpa(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(
                strokeCap: StrokeCap.round,
                strokeWidth: 2.0,
              ),
            );
          } else if (snapshot.hasError) {
            return const Center(child: Text('Error loading data'));
          } else {
            final cgpa = snapshot.data!;
            if (cgpa.isEmpty) {
              return const Center(child: Text('No cgpa found'));
            }
            return ListView.builder(
              itemCount: cgpa.length,
              itemBuilder: (context, index) {
                final result = cgpa[index];
                return Card(
                  margin: const EdgeInsets.symmetric(
                      vertical: 8.0, horizontal: 12.0),
                  elevation: 4.0,
                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(
                        vertical: 8.0, horizontal: 12.0),
                    title: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          '${result['fname']}',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Text(
                          '${result['regno']}',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    subtitle: Column(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Text('Credit Hours: ${result['totalCreditHours']}'),
                            Text(
                                'Quality Points: ${result['totalQualityPoints']}'),
                            Text('CGPA: ${result['cgpaValue']}'),
                          ],
                        ),
                      ],
                    ),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () async {
                        bool? confirmDelete = await showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: const Text('Delete Item'),
                            content: const Text(
                                'Are you sure you want to delete this CGPA?'),
                            actions: [
                              TextButton(
                                onPressed: () =>
                                    Navigator.of(context).pop(false),
                                child: const Text('Cancel'),
                              ),
                              TextButton(
                                onPressed: () =>
                                    Navigator.of(context).pop(true),
                                child: const Text('Delete'),
                              ),
                            ],
                          ),
                        );

                        if (confirmDelete == true) {
                          _removeResult(index);
                        }
                      },
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          bool? confirmClear = await showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text('Clear All'),
              content: const Text('Are you sure you want to clear all CGPA?'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  child: const Text('Cancel'),
                ),
                TextButton(
                  onPressed: () => Navigator.of(context).pop(true),
                  child: const Text('Clear'),
                ),
              ],
            ),
          );

          if (confirmClear == true) {
            _clearcgpa();
          }
        },
        label: const Text('Clear History'),
      ),
    );
  }
}
