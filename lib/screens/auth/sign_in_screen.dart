import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';

import '../../theme/app_theme.dart';
import '../../services/auth_service.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  bool isSignUp = false;
  bool loading = false;
  String? error;

  final nameCtrl = TextEditingController();
  final emailCtrl = TextEditingController();
  final passCtrl = TextEditingController();

  Future<void> _submit() async {
    setState(() { loading = true; error = null; });
    final auth = context.read<AuthService>();
    try {
      if (isSignUp) {
        await auth.signUp(name: nameCtrl.text, email: emailCtrl.text, password: passCtrl.text);
      } else {
        await auth.signIn(email: emailCtrl.text, password: passCtrl.text);
      }
      // AuthGate rebuilds automatically via the authStateChanges listener.
    } on FirebaseAuthException catch (e) {
      setState(() => error = e.message ?? 'Something went wrong. Please try again.');
    } finally {
      if (mounted) setState(() => loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: RadialGradient(
            center: Alignment(-0.6, -1),
            radius: 1.4,
            colors: [AppColors.teal, AppColors.ink],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 380),
                child: Container(
                  padding: const EdgeInsets.all(28),
                  decoration: BoxDecoration(
                    color: AppColors.panel,
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: const [BoxShadow(color: Colors.black38, blurRadius: 36, offset: Offset(0, 16))],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text('Chief Complaint', style: Theme.of(context).textTheme.headlineSmall),
                      const SizedBox(height: 4),
                      const Text('Practice OPD cases and MCQs like the real thing.',
                          style: TextStyle(fontSize: 13, color: Colors.black54)),
                      const SizedBox(height: 22),
                      _buildTabs(),
                      const SizedBox(height: 18),
                      if (error != null) ...[
                        Text(error!, style: const TextStyle(color: AppColors.red, fontSize: 12.5)),
                        const SizedBox(height: 10),
                      ],
                      if (isSignUp) ...[
                        _field('Full name', nameCtrl, hint: 'e.g. Alishba Khan'),
                        const SizedBox(height: 14),
                      ],
                      _field('Email', emailCtrl, hint: 'you@example.com', keyboardType: TextInputType.emailAddress),
                      const SizedBox(height: 14),
                      _field('Password', passCtrl, hint: '••••••••', obscure: true),
                      const SizedBox(height: 18),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: loading ? null : _submit,
                          child: loading
                              ? const SizedBox(height: 18, width: 18, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                              : Text(isSignUp ? 'Create account' : 'Sign in'),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTabs() {
    return Row(
      children: [
        _tab('Sign in', !isSignUp, () => setState(() { isSignUp = false; error = null; })),
        _tab('Sign up', isSignUp, () => setState(() { isSignUp = true; error = null; })),
      ],
    );
  }

  Widget _tab(String label, bool active, VoidCallback onTap) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            border: Border(bottom: BorderSide(color: active ? AppColors.teal : AppColors.line, width: 2)),
          ),
          alignment: Alignment.center,
          child: Text(label,
              style: TextStyle(
                  fontWeight: FontWeight.w600, fontSize: 13.5, color: active ? AppColors.tealInk : Colors.black38)),
        ),
      ),
    );
  }

  Widget _field(String label, TextEditingController ctrl, {String? hint, bool obscure = false, TextInputType? keyboardType}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 12, color: Colors.black54)),
        const SizedBox(height: 5),
        TextField(
          controller: ctrl,
          obscureText: obscure,
          keyboardType: keyboardType,
          decoration: InputDecoration(hintText: hint),
        ),
      ],
    );
  }
}
