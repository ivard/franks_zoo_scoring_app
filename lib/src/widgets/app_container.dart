import 'package:flutter/material.dart';

class AppContainer extends StatelessWidget {
  static const double _maxBodyWidth = 500;
  static const double _padding = 15;

  final String title;
  final Widget child;

  const AppContainer({
    Key? key,
    required this.title,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: Text(title),
        ),
        body: SingleChildScrollView(
          child: Container(
            constraints: BoxConstraints.loose(
              const Size.fromWidth(_maxBodyWidth),
            ),
            padding: const EdgeInsets.all(_padding),
            child: child,
          ),
        ),
      );
}
