import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'login_page.dart';

class AnonymousSignUpPage extends StatefulWidget {
  const AnonymousSignUpPage({super.key});

  @override
  State<AnonymousSignUpPage> createState() => _AnonymousSignUpPageState();
}

class _AnonymousSignUpPageState extends State<AnonymousSignUpPage> {
  String _status = "Signing up anonymously...";

  @override
  void initState() {
    super.initState();
    _signUpAnon();
  }

  Future<void> _signUpAnon() async {
    try {
      final result = await FirebaseAuth.instance.signInAnonymously();
      if (result.user != null) {
        setState(() {
          _status = "Signed in anonymously as ${result.user!.uid}";
        });

        Future.delayed(const Duration(seconds: 2), () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (_) => const LinkEmailPage()));
        });
      }
    } catch (e) {
      setState(() {
        _status = "Failed: $e";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Signing Up")),
      body: Center(child: Text(_status)),
    );
  }
}

class LinkEmailPage extends StatefulWidget {
  const LinkEmailPage({super.key});

  @override
  State<LinkEmailPage> createState() => _LinkEmailPageState();
}

class _LinkEmailPageState extends State<LinkEmailPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  String _status = "";

  Future<void> _linkEmail() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null && user.isAnonymous) {
        final credential = EmailAuthProvider.credential(
          email: _emailController.text.trim(),
          password: _passwordController.text.trim(),
        );

        await user.linkWithCredential(credential);

        setState(() {
          _status = "Email linked successfully!";
        });

        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (_) => const MainHomePage()));
      } else {
        setState(() {
          _status = "No anonymous user found.";
        });
      }
    } catch (e) {
      setState(() {
        _status = "Error: $e";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Link Email")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const Text("Link your email to save progress"),
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(labelText: "Email"),
            ),
            TextField(
              controller: _passwordController,
              decoration: const InputDecoration(labelText: "Password"),
              obscureText: true,
            ),
            ElevatedButton(
              onPressed: _linkEmail,
              child: const Text("Link Email"),
            ),
            Text(_status),
          ],
        ),
      ),
    );
  }
}

class MainHomePage extends StatelessWidget {
  const MainHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Moodie Home")),
      body: const Center(
        child: Text("Welcome to the main app page!"),
      ),
    );
  }
}
