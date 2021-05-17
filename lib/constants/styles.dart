import 'package:flutter/material.dart';

final boxDecorationStyle = BoxDecoration(
  color: Color(0xFFFFFFFF),
  borderRadius: BorderRadius.circular(10.0),
  boxShadow: [
    BoxShadow(
      color: Colors.black12,
      blurRadius: 6.0,
      offset: Offset(0, 2),
    ),
  ],
);
final textStyle = TextStyle(
  color: Colors.black,
  fontWeight: FontWeight.bold,
  fontFamily: 'OpenSans',
);
final hintTextStyle = TextStyle(
  color: Colors.black54,
  fontFamily: 'OpenSans',
);
const hintStyle = TextStyle(
  color: Colors.black54,
  fontFamily: 'OpenSans',
);
