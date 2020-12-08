import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_firebase_auth/screens/mainPage.dart';

class Register extends StatefulWidget {
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  TextEditingController _displayName = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();


  String _validateName(String value) {
    if(value.isNotEmpty) {
      Pattern pattern =
          r"^([a-zA-Z]{2,}[a-zA-z]{1,}'?-?[a-zA-Z]{2,}?([a-zA-Z]{1,})?)";
      RegExp regex = new RegExp(pattern);
      if (!regex.hasMatch(value))
        return 'Invalid username';
      else
        return null;
    }
    else
      return 'Please enter your full name';
  }
  String _validateEmail(String value) {
   if(value.isNotEmpty) {
     Pattern pattern =
         r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
     RegExp regex = new RegExp(pattern);
     if (!regex.hasMatch(value))
       return 'Enter Valid Email';
     else
       return null;
   }
   else
     return 'Please enter your email';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Form(
          key: _formkey,
          child: Card(
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  TextFormField(
                    controller: _displayName,
                    decoration: const InputDecoration(
                      labelText:'Full Name',
                    ),
                    validator: _validateName,
                  ),
                  TextFormField(
                    controller: _emailController,
                    decoration: const InputDecoration(
                      labelText:'Email',
                    ),
                    validator: _validateEmail
                  ),
                  TextFormField(
                    controller: _passwordController,
                    obscureText: true,
                    decoration: const InputDecoration(
                      labelText:'Password',
                    ),
                    validator: (value) {
                      if (value.isEmpty || value.length < 4) {
                        return 'Password must be at least 5 character!';
                      }
                    },
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Container(
                    //padding: EdgeInsets.symmetric(vertical: ),
                    child: OutlineButton(
                      shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(30.0)),
                      borderSide: BorderSide(color: Theme.of(context).primaryColor, width: 1, style: BorderStyle.solid),
                      onPressed: () async {
                        if(_formkey.currentState.validate()){}
                       _registerAccount();
                        },
                      child: Text('Register'),
                    ),
                  ),
                ],
              ),
            ),
          ),


        ),
      ),
    );
  }

  void _registerAccount() async {
    final User user = (await _auth.createUserWithEmailAndPassword
      (email: _emailController.text, password: _passwordController.text)).user;

    if(user != null){
      if(!user.emailVerified){
        await user.sendEmailVerification();
      }
      await user.updateProfile(displayName: _displayName.text);
      final user1 = _auth.currentUser;
      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context){
        return MainPage(user: user1,);
      }));

    }
  }
}
