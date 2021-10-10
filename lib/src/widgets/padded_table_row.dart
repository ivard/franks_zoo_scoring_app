import 'package:flutter/cupertino.dart';

class PaddedTableRow extends TableRow {
  PaddedTableRow({
    LocalKey? key,
    required EdgeInsets padding,
    Decoration? decoration,
    required List<Widget> children,
  }) : super(
          key: key,
          decoration: decoration,
          children: children
              .map((w) => Padding(
                    padding: padding,
                    child: w,
                  ))
              .toList(),
        );
}
