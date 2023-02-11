import 'package:flutter/material.dart';

import 'package:go_router/go_router.dart';

import '../pages/event_list_page.dart';

class AppBarWidget extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final bool backButton;

  const AppBarWidget(this.title, {this.backButton = true, super.key});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  PreferredSizeWidget build(BuildContext context) {
    return AppBar(
      leading: backButton
          ? BackButton(
              onPressed: () => context.go(EventListPage.routeName),
            )
          : null,
      //toolbarHeight: 70,
      //backgroundColor: Theme.of(context).bottomAppBarColor,
      elevation: 0,
      centerTitle: !backButton,
      titleSpacing: 0,
      title: Text(
        title,
        style: TextStyle(
          color: Colors.blueGrey[100],
          fontSize: 20,
          fontFamily: 'Montserrat',
          fontWeight: FontWeight.w400,
          letterSpacing: 3,
        ),
      ),
      actions: const <Widget>[
        //SettingsLinkWidget(),
      ],
    );
  }
}
