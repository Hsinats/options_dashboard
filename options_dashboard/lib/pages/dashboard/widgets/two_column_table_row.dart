import 'package:flutter/material.dart';

TableRow buildTwoColumnTableRow(String col1, String col2) {
  return TableRow(
    children: [
      Text(col1),
      Text(col2),
    ],
  );
}

TableRow buildFourColumnTableRow(
    String col1, String col2, String col3, String col4) {
  return TableRow(
    children: [
      Text(col1),
      Text(col2),
      Text(col3),
      Text(col4),
    ],
  );
}

TableRow buildSixColumnTableRow(String col1, String col2, String col3,
    String col4, String col5, String col6) {
  return TableRow(
    children: [
      Text(col1),
      Text(col2),
      Text(col3),
      Text(col4),
      Text(col5),
      Text(col6),
    ],
  );
}
