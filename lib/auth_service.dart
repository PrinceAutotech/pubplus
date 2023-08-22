import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'admin/dashboard.dart';
import 'view/startup/login_page.dart';

class AuthService {

  handleAuth() => StreamBuilder(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return const Dashboard();
        } else {
          return const LoginPage();
        }
      },
    );

}
