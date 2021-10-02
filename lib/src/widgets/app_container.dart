import 'package:flutter/material.dart';

class AppContainer extends StatelessWidget {
  final String title;
  final Widget body;
  final Widget? footer;

  final Widget? action;

  const AppContainer({
    Key? key,
    required this.title,
    required this.body,
    this.footer,
    this.action,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: Text(title),
          actions: action != null ? [action!] : null,
        ),
        body: SingleChildScrollView(
          child: body,
        ),
        persistentFooterButtons: footer != null ? [footer!] : null,
      );
}
