import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase_auth/screens/register.dart';
import 'package:flutter_firebase_auth/screens/signin.dart';
import 'package:flutter_auth_buttons/flutter_auth_buttons.dart';

class AuthScreen extends StatefulWidget {
  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text('Firebase Auth'),
      ),
      body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              alignment: Alignment.center,
              child: OutlineButton(
                  shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(30.0)),
                borderSide: BorderSide(color: Theme.of(context).primaryColor, width: 1, style: BorderStyle.solid),
                onPressed: () {
                  _push(context, SignIn());
                },
                child: Text('Sign In', ),
                padding: EdgeInsets.all(5),

              ),
            ),
            SizedBox(
              height: 10,
            ),
            Container(
              alignment: Alignment.center,
              child: OutlineButton(
                shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(30.0)),
                borderSide: BorderSide(color: Theme.of(context).primaryColor, width: 1, style: BorderStyle.solid),
                onPressed: () {
                  _push(context, Register());
                },
                child: Text('Register'),
                padding: EdgeInsets.all(5),
              ),
            ),
          ],
        ),
    );
  }

  void _push(BuildContext context, Widget page){
    Navigator.of(context).push(MaterialPageRoute(builder: (context){
      return page;
    }));
  }
}
