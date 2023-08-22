import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../admin/dashboard.dart';
import '../../admin/viewer_dashboard.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  Future getUserInfo() async {
    await getUser();
    setState(() {});
    if (kDebugMode) {
      print(uid);
    }
  }

  @override
  void initState() {
    getUserInfo();
    super.initState();
  }

  TextEditingController emailController =
      TextEditingController(text: '');
  TextEditingController passwordController =
      TextEditingController(text: '');

  bool _showPassword = true;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  String? email;
  String? uid;

  Future<void> _login() async {
    email = emailController.text.trim();
    String password = passwordController.text.trim();

    if (email == '' || password == '') {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Please fill all the fields!'),
      ));
    } else {
      try {
        UserCredential userCredential = await FirebaseAuth.instance
            .signInWithEmailAndPassword(email: email!, password: password);
        if (userCredential.user != null) {
          if (userCredential.user?.email == 'viewer@gmail.com') {
            if (!mounted) return;
            Navigator.popUntil(context, (route) => route.isFirst);
            unawaited(Navigator.pushReplacement(context,
                CupertinoPageRoute(builder: (_) => const ViewerDashboard())));
            ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Login successfully !!')));
          } else {
            if (!mounted) return;
            Navigator.popUntil(context, (route) => route.isFirst);
            unawaited(Navigator.pushReplacement(context,
                CupertinoPageRoute(builder: (_) => const Dashboard())));
            ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Login successfully !!')));
            SharedPreferences prefs = await SharedPreferences.getInstance();
            await prefs.setBool('auth', true);
            await prefs.setString('email', userCredential.user!.email!);
          }
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
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(12)),
                    ),
                    hintText: 'Enter the Email',
                  ),
                ),
              ),
              const SizedBox(height: 10),
              SizedBox(
                width: 350,
                height: 55,
                child: TextField(
                  controller: passwordController,
                  obscureText: _showPassword,
                  decoration: InputDecoration(
                    border: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(12)),
                    ),
                    hintText: 'Enter the Password',
                    suffix: IconButton(
                      icon: _showPassword
                          ? const Icon(
                              Icons.visibility_outlined,
                              size: 20,
                            )
                          : const Icon(
                              Icons.visibility_off_outlined,
                              size: 20,
                            ),
                      onPressed: () {
                        setState(() {
                          _showPassword = !_showPassword;
                        });
                      },
                    ),
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

  Future getUser() async {
    // Initialize Firebase
    await Firebase.initializeApp();

    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool authSignedIn = prefs.getBool('auth') ?? false;

    final User? user = _auth.currentUser;

    if (authSignedIn == true) {
      if (user != null) {
        uid = user.uid;
        email = user.email;
      }
    }
  }
}
