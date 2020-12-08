import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_auth_buttons/flutter_auth_buttons.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:flutter_firebase_auth/screens/firebaseauth.dart';
import 'package:flutter_firebase_auth/screens/login_with_facebook.dart';
import 'package:flutter_firebase_auth/screens/mainPage.dart';
import 'package:google_sign_in/google_sign_in.dart';

class SignIn extends StatefulWidget {
  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final gooleSignIn = GoogleSignIn();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final GlobalKey<ScaffoldState> _scaffoldkey = GlobalKey<ScaffoldState>();
  bool _islogin = false;
  User _user;
  FacebookLogin _facebookLogin = FacebookLogin();

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

        key: _scaffoldkey,
        body: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              withEmailPassword(),
            ],
          ),
    );
  }
  Widget withEmailPassword(){
    return SingleChildScrollView(
      child: Form(
          key: _formkey,
            child: Padding(
              padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  alignment: Alignment.center,
                  child: const Text('Sign in with email and password',
                    style: TextStyle(fontSize: 15, color: Colors.black),),
                ),
                SizedBox(
                  height: 10,
                ),
                TextFormField(
                  controller: _emailController,
                  decoration: const InputDecoration(
                    labelText:'Email',
                  ),
                  validator: _validateEmail,
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
                  height: 10,
                ),
                Container(
                  //color: Colors.lightBlue,
                  alignment: Alignment.center,
                  padding: EdgeInsets.symmetric(vertical: 10),
                  child: OutlineButton(
                    shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(30.0)),
                    borderSide: BorderSide(color: Theme.of(context).primaryColor, width: 1, style: BorderStyle.solid),

                    onPressed: () async {
                      if(_formkey.currentState.validate()){}
                      _signinwithEmailPassword();
                    },
                    child: Text('Sign In', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),),
                  ),
                ),
                Container(
                  //height: 100,
                  margin: EdgeInsets.only(left: 30,right: 30),
                  alignment: Alignment.center,

                    child: GoogleSignInButton(onPressed: () => _googleSignIn(),
                      borderRadius: 10,
                    ),

                ),
                // Container(
                //   //height: 100,
                //   //margin: EdgeInsets.only(left: 30,right: 10),
                //   alignment: Alignment.center,
                //
                //   child: FacebookSignInButton(onPressed: () {
                //     Navigator.of(context).pushNamed(LoginWithFacebook.routeName);
                //   },
                //     borderRadius: 10,
                //   ),
                //
                // ),
                SizedBox(
                  height: 10,
                ),
                 Container(
                   margin: EdgeInsets.only(left: 15,right: 10),
                   //height: 200,
                      child: FacebookSignInButton(
                        borderRadius: 10,
                        onPressed: () async {
                          await _handlelogin();
                        },
                      ),
                    //Center(
                    //  child: Text('Password'),
                      // child: Column(
                      //   mainAxisAlignment: MainAxisAlignment.center,
                      //   children: [
                      //     CircleAvatar(
                      //       radius: 40,
                      //       backgroundImage: NetworkImage(_user.photoURL),
                      //     ),
                      //     Text(_user.displayName, style: TextStyle(fontSize: 18,),),
                      //     SizedBox(
                      //       height: 10,
                      //     ),
                      //     OutlineButton(onPressed: () async {
                      //       await signOut();
                      //     },
                      //       child: Text('LogOut', style: TextStyle(fontSize: 20,),),
                      //     ),
                      //   ],
                      // ),
                    //),

                //  ),
                  ),
              ],
            ),
            ),
      ),
    );
  }

  Future _handlelogin() async {
    FacebookLoginResult _result = await _facebookLogin.logIn(['email']);
    switch(_result.status){
      case FacebookLoginStatus.cancelledByUser:
        print('cancelledBuser');
        break;
      case FacebookLoginStatus.error:
        print('error');
        break;
      case FacebookLoginStatus.loggedIn:
        await _loginwithfacebook(_result);
        break;
    }
  }
  Future _loginwithfacebook(FacebookLoginResult _result) async {
    FacebookAccessToken _accessToken = _result.accessToken;
    AuthCredential _credential = FacebookAuthProvider.credential(_accessToken.token);
    var a = await _auth.signInWithCredential(_credential);

    // setState(() {
    //   //_islogin = true;
    //   _user = a.user;
    // });

    Navigator.of(context).push(MaterialPageRoute(builder: (_){
      return MainPage(user: a.user,
      );
    }));
  }

  // Future signOut() async {
  //   await _auth.signOut().then((value) {
  //     setState(() {
  //       _facebookLogin.logOut();
  //       _islogin = false;
  //     });
  //   });
  // }


  void _signinwithEmailPassword() async {
    try{
    final User user = (await _auth.signInWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text,
    )).user;
    if(!user.emailVerified){
      await user.sendEmailVerification();
    }
    Navigator.of(context).push(MaterialPageRoute(builder: (_){
      return MainPage(user: user,
      );
    }));
    } catch(e){
_scaffoldkey.currentState.showSnackBar(SnackBar(content: Text('Failed to sign in with email and password'),
));
print(e);
    }
  }

 void _googleSignIn() async {
    try {
      GoogleSignInAccount googleSignInAccount = await gooleSignIn.signIn();
      if (googleSignInAccount != null) {
        GoogleSignInAuthentication googleSignInAuthentication = await googleSignInAccount
            .authentication;
        AuthCredential credential = GoogleAuthProvider.credential(
            idToken: googleSignInAuthentication.idToken,
            accessToken: googleSignInAuthentication.accessToken);
         //User result = (await _auth.signInWithCredential(credential)).user;
         var result = await _auth.signInWithCredential(credential);
          User user = await _auth.currentUser;
        print(user.uid);
        Navigator.of(context).push(MaterialPageRoute(builder: (_){
          return MainPage(user: user,
          );
        }));
      }
    }catch(e){
      _scaffoldkey.currentState.showSnackBar(SnackBar(content: Text('Failed to sign in with google'),
      ));
      print(e);
    }
    }
  }



