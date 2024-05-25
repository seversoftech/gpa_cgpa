import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GPAHistory extends StatefulWidget {
  const GPAHistory({super.key});

  @override
  _GPAHistoryState createState() => _GPAHistoryState();
}

class _GPAHistoryState extends State<GPAHistory> {
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

  Future<void> _removeResult(int index) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<Map<String, dynamic>> results = await _loadResults();
    results.removeAt(index);
    String resultsJson = json.encode(results);
    await prefs.setString('results', resultsJson);
    setState(() {}); // Refresh the UI
  }

  Future<void> _clearResults() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('results');
    setState(() {}); // Refresh the UI
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _loadResults(),
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
            final results = snapshot.data!;
            if (results.isEmpty) {
              return const Center(child: Text('No Results found'));
            }
            return ListView.builder(
              itemCount: results.length,
              itemBuilder: (context, index) {
                final result = results[index];
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
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Credit Hours: ${result['creditHours']}'),
                            Text('Quality Points: ${result['qualityPoints']}'),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Obtain Marks: ${result['obtainNumbers']}'),
                            Text('Total Marks: ${result['totalNumbers']}'),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Percentage: ${result['percentageStr']} %'),
                            Text('GPA: ${result['gpaStr']}'),
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
                            title: const Text('Delete Result'),
                            content: const Text(
                                'Are you sure you want to delete this GPA?'),
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
              content: const Text('Are you sure you want to clear all items?'),
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
            _clearResults();
          }
        },
        label: const Text('Clear History'),
      ),
    );
  }
}
