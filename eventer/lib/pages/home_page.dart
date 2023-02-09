import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../widgets/page_widget.dart';
import 'event_page.dart';

class HomePage extends StatefulWidget {
  static const String routeName = '/';
  final String title = 'Eventer';

  const HomePage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return PageWidget(
      title: widget.title,
      backButton: false,
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          context.go(EventPage.routeName);
        },
      ),
      child: SizedBox(
        height: 800,
        child: ListView.builder(
          itemCount: 40,
          itemBuilder: (context, index) {
            return const ListTile(
              title: Text("Hello"),
            );
          },
        ),
      ),
    );
  }
}
