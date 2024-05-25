import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

Widget popUpMenu() {
  return PopupMenuButton<int>(
    onSelected: (value) {
      if (kDebugMode) {
        print(value);
      }
    },
    itemBuilder: (BuildContext context) => <PopupMenuEntry<int>>[
      const PopupMenuItem(
        value: 20,
        child: Text('20'),
      ),
      const PopupMenuItem(
        value: 30,
        child: Text('30'),
      )
    ],
  );
}
