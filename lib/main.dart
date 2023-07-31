import 'dart:developer';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pubplus/admin/dashboard.dart';

import 'addcompaian.dart';
import 'firebase_options.dart';

void main() async {
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Campaign',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      debugShowCheckedModeBanner: false,
      home: const MyHomePage(title: 'Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  TextEditingController emailController = TextEditingController(text:'prince@gmail.com');
  TextEditingController passwordController = TextEditingController(text: 'prince@121');

  void login() async {
    String email = emailController.text.trim();
    String password = passwordController.text.trim();

    if(email == "" || password == "") {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Please fill all the fields!"),
      ));
    }
    else {

      try {
        UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(email:email, password: password);
        if(userCredential.user != null) {

          Navigator.popUntil(context, (route) => route.isFirst);
          Navigator.pushReplacement(context, CupertinoPageRoute(
              builder: (context) => const AddCampaign()
          ));
          ScaffoldMessenger.of(context).showSnackBar( const SnackBar(
              content: Text("Login successfully !!")
          ));
        }
      } on FirebaseAuthException catch(ex) {
        ScaffoldMessenger.of(context).showSnackBar( SnackBar(
            content: Text(ex.code.toString())
        ));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Container(
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(
              height: 10,
            ),
            const Text(
              "SingIn",
              style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              height: 10,
            ),
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
            const SizedBox(
              height: 10,
            ),
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
            const SizedBox(
              height: 10,
            ),
            SizedBox(
              width: 120,
              height: 40,
              child: ElevatedButton(
                onPressed: () {
                  login();
                },
                style: ElevatedButton.styleFrom(
                  elevation: 8.0,
                  textStyle: const TextStyle(color: Colors.white),
                ),
                child: const Text('Sing In'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
