import 'package:flutter/material.dart';

import 'appbar_widget.dart';

// ignore: must_be_immutable
class PageWidget extends StatefulWidget {
  final String title;
  final bool backButton;
  final Widget? floatingActionButton;
  Widget child;

  PageWidget(
      {required this.title,
      required this.child,
      this.backButton = true,
      this.floatingActionButton,
      super.key});

  @override
  // ignore: library_private_types_in_public_api
  _PageWidgetState createState() => _PageWidgetState();
}

class _PageWidgetState extends State<PageWidget> {
  late ScrollController _scrollController;

  @override
  void initState() {
    _scrollController = ScrollController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //backgroundColor: Theme.of(context).backgroundColor,
      //extendBodyBehindAppBar: false,
      appBar: AppBarWidget(
        widget.title,
        backButton: widget.backButton,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          controller: _scrollController,
          physics: const ClampingScrollPhysics(),
          child: widget.child,
        ),
      ),
      floatingActionButton: widget.floatingActionButton,
    );
  }
}
