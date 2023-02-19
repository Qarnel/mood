import 'package:flutter/material.dart';

class StatisticsWidget extends StatelessWidget {
  final String? message;

  const StatisticsWidget({this.message, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12.0),
      child: Column(
        children: [
          const Icon(Icons.error_outline_rounded),
          Text(message ?? "")
        ],
      ),
    );
  }
}
