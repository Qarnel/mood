import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:easy_dynamic_theme/easy_dynamic_theme.dart';
import 'package:go_router/go_router.dart';
import 'package:localization/localization.dart';
import 'package:reactive_forms/reactive_forms.dart';

import 'models/event.dart';
import 'utils/theme_data.dart';
import 'pages/home_page.dart';
import 'pages/event_page.dart';
import 'pages/settings_page.dart';

void main() {
  LocalJsonLocalization.delegate.directories.clear();
  LocalJsonLocalization.delegate.directories.add("assets/i18n/");
  runApp(
    EasyDynamicThemeWidget(
      child: ReactiveFormConfig(
        validationMessages: {
          ValidationMessage.required: (error) => 'Field must not be empty',
          ValidationMessage.email: (error) => 'Must enter a valid email',
        },
        child: const MyApp(),
      ),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  /// The route configuration.
  final GoRouter routerConfig = GoRouter(
    initialLocation: HomePage.routeName,
    routes: <RouteBase>[
      GoRoute(
        path: HomePage.routeName,
        builder: (BuildContext context, GoRouterState state) {
          return const HomePage();
        },
      ),
      GoRoute(
        path: SettingsPage.routeName,
        builder: (BuildContext context, GoRouterState state) {
          return SettingsPage();
        },
      ),
      GoRoute(
        path: EventPage.routeName,
        builder: (BuildContext context, GoRouterState state) {
          if (state.extra is Event) {
            return EventPage(event: state.extra as Event);
          } else {
            return const EventPage();
          }
        },
      ),
    ],
  );

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      theme: lightThemeData,
      darkTheme: darkThemeData,
      themeMode: EasyDynamicTheme.of(context).themeMode,
      title: 'QarnelBet',
      routerConfig: routerConfig,
      supportedLocales: const [
        Locale('en', 'US'),
        Locale('fr', 'FR'),
        Locale('pt', 'BR'),
      ],
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        LocalJsonLocalization.delegate,
      ],
      localeResolutionCallback: (locale, supportedLocales) {
        if (supportedLocales.contains(locale)) {
          return locale;
        }

        // Locale by language
        if (locale?.languageCode == 'en') {
          return const Locale('en', 'US');
        } else if (locale?.languageCode == 'pt') {
          return const Locale('pt', 'BR');
        } else if (locale?.languageCode == 'fr') {
          return const Locale('fr', 'FR');
        }

        // Default locale
        return const Locale('en', 'US');
      },
    );
  }
}
