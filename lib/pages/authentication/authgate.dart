import 'package:supabase_ai_app/pages/authentication/auth_handler.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class Authgate extends StatelessWidget {
  final authHandler = AuthHandler();
  Authgate({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<AuthState>(
      // It's good practice to specify the type for the StreamBuilder
      stream: Supabase.instance.client.auth.onAuthStateChange,
      builder: (context, snapshot) {
        // It's better to handle the snapshot's state rather than just connectionState
        if (!snapshot.hasData) {
          return const Scaffold(
            body: Center(
              child: Column(
                mainAxisAlignment:
                    MainAxisAlignment.center, // Center the content
                children: [
                  Text(
                    "AuthGate",
                    style: TextStyle(fontSize: 50, color: Colors.white),
                  ),
                  SizedBox(height: 20), // Add some spacing
                  CircularProgressIndicator(),
                ],
              ),
            ),
          );
        }

        // Use a variable for the session to avoid multiple calls
        final session = snapshot.data?.session;

        // Schedule navigation to occur after the build is complete
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (session != null) {
            authHandler.listenMessages();
            // Check if the widget is still in the tree
            if (context.mounted) {
              context.go("/home");
            }
          } else {
            if (context.mounted) {
              context.go("/login");
            }
          }
        });

        // While the navigation is being scheduled, show a loading indicator.
        // This screen will only be visible for a fraction of a second.
        return const Scaffold(body: Center(child: CircularProgressIndicator()));
      },
    );
  }
}
