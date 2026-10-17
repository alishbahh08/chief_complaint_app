import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../services/auth_service.dart';
import '../../services/progress_service.dart';
import '../dashboard/dashboard_screen.dart';
import 'sign_in_screen.dart';

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthService>();

    if (!auth.isSignedIn) return const SignInScreen();

    // Signed in: load this user's progress once, then show the dashboard.
    return FutureBuilder(
      future: context.read<ProgressService>().loadAll(),
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const Scaffold(body: Center(child: CircularProgressIndicator()));
        }
        return const DashboardScreen();
      },
    );
  }
}
