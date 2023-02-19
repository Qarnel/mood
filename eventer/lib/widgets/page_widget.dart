import 'package:flutter/material.dart';

import 'appbar_widget.dart';

// ignore: must_be_immutable
class PageWidget extends StatelessWidget {
  final String title;
  final bool backButton;
  final Widget? bottomNavigationBar;
  final Widget? floatingActionButton;
  Widget child;

  PageWidget(
      {required this.title,
      required this.child,
      this.backButton = true,
      this.bottomNavigationBar,
      this.floatingActionButton,
      super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //backgroundColor: Theme.of(context).backgroundColor,
      //extendBodyBehindAppBar: false,
      appBar: AppBarWidget(
        title,
        backButton: backButton,
      ),
      body: SafeArea(
        child: child,
      ),
      bottomNavigationBar: bottomNavigationBar,
      floatingActionButton: floatingActionButton,
    );
  }
}
