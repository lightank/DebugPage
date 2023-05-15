// Copyright 2013 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:debug_page/debug_page.dart';
import 'package:go_router/go_router.dart';
import 'package:oktoast/oktoast.dart';

// Project imports:
import 'package:debug_page_examples/debug_page_source.dart';

/// This sample app shows an app with two screens.
///
/// The first route '/' is mapped to [HomeScreen], and the second route
/// '/details' is mapped to [DetailsScreen].
///
/// The buttons use context.go() to navigate to each destination. On mobile
/// devices, each destination is deep-linkable and on the web, can be navigated
/// to using the address bar.
void main() => runApp(const MyApp());

/// The route configuration.
final GoRouter _router = GoRouter(
  routes: <RouteBase>[
    GoRoute(
      path: '/',
      builder: (BuildContext context, GoRouterState state) {
        return const HomeScreen();
      },
      routes: <RouteBase>[
        GoRoute(
          path: 'details',
          builder: (BuildContext context, GoRouterState state) {
            final String? title = state.extra as String?;
            return DetailsScreen(
              title: title,
            );
          },
        ),
        GoRoute(
          path: 'debug_page',
          builder: (BuildContext context, GoRouterState state) {
            return DebugPage(
              dataSource: DebugPageDataSource(
                  title: "测试界面",
                  appBarBuilder: (_) => AppBar(
                        title: const Text("测试界面标题"),
                      ),
                  sectionsBuilder: debugPageSectionsBuilder,
                  tabBarProperty: const TabBarProperty(
                      selectedLabelColor: Colors.lightBlueAccent,
                      unselectedLabelColor: Colors.black45,
                      indicator: UnderlineTabIndicator(
                          borderSide: BorderSide(
                              width: 6.0, color: Colors.lightBlueAccent))),
                  popupProperty: const PopupProperty(
                      unSelectedLabelTextStyle:
                          TextStyle(color: Colors.black45),
                      selectedLabelTextStyle:
                          TextStyle(color: Colors.lightBlueAccent))),
            );
          },
        ),
      ],
    ),
  ],
);

/// The main app.
class MyApp extends StatelessWidget {
  /// Constructs a [MyApp]
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return OKToast(
      textStyle: const TextStyle(fontSize: 19.0, color: Colors.white),
      backgroundColor: Colors.grey,
      animationCurve: Curves.easeIn,
      animationDuration: const Duration(milliseconds: 200),
      duration: const Duration(seconds: 3),
      child: MaterialApp.router(
        routerConfig: _router,
      ),
    );
  }
}

/// The home screen
class HomeScreen extends StatelessWidget {
  /// Constructs a [HomeScreen]
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Home Screen')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              onPressed: () => context.push('/debug_page'),
              child: const Text('Go to the debug page'),
            ),
          ],
        ),
      ),
    );
  }
}

/// The details screen
class DetailsScreen extends StatelessWidget {
  /// Constructs a [DetailsScreen]
  const DetailsScreen({Key? key, this.title}) : super(key: key);
  final String? title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title ?? 'Details Screen')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <ElevatedButton>[
            ElevatedButton(
              onPressed: () => context.pop(),
              child: const Text('Go back to debug page'),
            ),
          ],
        ),
      ),
    );
  }
}
