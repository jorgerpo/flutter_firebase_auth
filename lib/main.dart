import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_firebase_auth/screens/auth_screen.dart';
import 'package:flutter_firebase_auth/screens/login_with_facebook.dart';

 Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      //themeMode: Theme.of(context).primaryColor,
      theme: ThemeData(
        primarySwatch: Colors.purple,

        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: AuthScreen(),
    routes: {
        LoginWithFacebook.routeName: (ctx) => LoginWithFacebook(),
    },
    );

  }
}

