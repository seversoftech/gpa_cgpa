import 'package:flutter/material.dart';

Widget listHeader(String value1, String value2, String value3) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.center,
    crossAxisAlignment: CrossAxisAlignment.center,
    children: [
      listHeaderitem(value1),
      listHeaderitem(value2),
      listHeaderitem(value3)
    ],
  );
}

Widget listHeaderitem(String value) {
  return Container(
    height: 20,
    width: 100,
    color: Colors.purple[700],
    foregroundDecoration: const BoxDecoration(
      border: Border(
        right: BorderSide(width: 5, color: Colors.white),
      ),
    ),
    child: Center(
      child: Text(
        value,
        style: const TextStyle(fontSize: 13, color: Colors.white),
      ),
    ),
  );
}
