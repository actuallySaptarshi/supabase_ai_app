import 'package:supabase_ai_app/home_page_navigation.dart';
import 'package:supabase_ai_app/layout_scaffold.dart';
import 'package:supabase_ai_app/pages/authentication/auth_handler.dart';
import 'package:supabase_ai_app/pages/authentication/authgate.dart';
import 'package:supabase_ai_app/pages/chat_pages/chat_page.dart';
import 'package:supabase_ai_app/pages/login_page.dart';
import 'package:supabase_ai_app/pages/chat_pages/new_chat_page.dart';
import 'package:supabase_ai_app/pages/signup_page.dart';
import 'package:supabase_ai_app/settings.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import 'package:supabase_flutter/supabase_flutter.dart';

Future<void> main() async {
  await Supabase.initialize(
    url: 'https://YOUR_SUPABASE_URL',
    anonKey:
        'YOUR_SUPABASE_ANON_KEY',
  );
  runApp(MainApp());
}

class MainApp extends StatelessWidget {
  MainApp({super.key});

  // GoRouter configuration
  final _router = GoRouter(
    routes: [
      GoRoute(path: '/', builder: (context, state) => Authgate()),
      StatefulShellRoute.indexedStack(
        builder:
            (context, state, navigationShell) =>
                LayoutScaffold(shell: navigationShell),
        branches: [
          // First branch for the first tab
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: "/home",
                builder: (context, state) => const HomePageNavigation(),
              ),
            ],
          ),
          // Second branch for the second tab
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: "/settings",
                builder: (context, state) => Settings(),
              ),
            ],
          ),
        ],
      ),
      GoRoute(path: '/signup', builder: (context, state) => SignupPage()),
      GoRoute(path: '/login', builder: (context, state) => LoginPage()),
      //GoRoute(path: '/home', builder: (context, state) => HomePage()),
      GoRoute(path: '/chat', builder: (context, state) => NewChatPage()),
      GoRoute(
        path: '/chat/:id',
        builder:
            (context, state) => ChatPage(id: state.pathParameters['id'] ?? ""),
      ),
    ],
  );

  @override
  Widget build(BuildContext context) {
    //return MaterialApp.router(routerConfig: _router);
    return MultiProvider(
      providers: [ChangeNotifierProvider(create: (context) => AuthHandler())],
      child: MaterialApp.router(routerConfig: _router),
    );
  }
}
