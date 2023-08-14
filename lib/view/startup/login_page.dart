import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../admin/dashboard.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController emailController =
      TextEditingController(text: '');
  TextEditingController passwordController =
      TextEditingController(text: '');

  Future<void> _login() async {
    String email = emailController.text.trim();
    String password = passwordController.text.trim();

    if (email == '' || password == '') {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Please fill all the fields!'),
      ));
    } else {
      try {
        UserCredential userCredential = await FirebaseAuth.instance
            .signInWithEmailAndPassword(email: email, password: password);
        if (userCredential.user != null) {
          if (!mounted) return;
          Navigator.popUntil(context, (route) => route.isFirst);
          unawaited(Navigator.pushReplacement(context,
              CupertinoPageRoute(builder: (_) => const Dashboard())));
          ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Login successfully !!')));

        }
      } on FirebaseAuthException catch (ex) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(ex.code.toString())));
      }
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: const Text('Login'),
        ),
        body: Container(
          alignment: Alignment.center,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 10),
              const Text(
                'Sign In',
                style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              SizedBox(
                width: 350,
                child: TextField(
                  controller: emailController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Enter the Email',
                  ),
                ),
              ),
              const SizedBox(height: 10),
              SizedBox(
                width: 350,
                child: TextField(
                  controller: passwordController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Enter the Password',
                  ),
                ),
              ),
              const SizedBox(height: 10),
              SizedBox(
                width: 120,
                height: 40,
                child: ElevatedButton(
                  onPressed: _login,
                  style: ElevatedButton.styleFrom(
                    elevation: 8.0,
                    textStyle: const TextStyle(color: Colors.white),
                  ),
                  child: const Text('Sign In'),
                ),
              ),
            ],
          ),
        ),
      );
}
