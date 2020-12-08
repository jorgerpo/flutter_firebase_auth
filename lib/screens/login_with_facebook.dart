import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:flutter_auth_buttons/flutter_auth_buttons.dart';

class LoginWithFacebook extends StatefulWidget {
  static const routeName = '/route-fb';
  @override
  _LoginWithFacebookState createState() => _LoginWithFacebookState();
}

class _LoginWithFacebookState extends State<LoginWithFacebook> {
 bool _islogin = false;
 User _user;
 FirebaseAuth _auth = FirebaseAuth.instance;
 FacebookLogin _facebookLogin = FacebookLogin();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: !_islogin ? Center(
        child: FacebookSignInButton(
          onPressed: () async {
            await _handlelogin();
          },
        ),
      ) : Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
CircleAvatar(
  radius: 80,
  backgroundImage: NetworkImage(_user.photoURL),
),
            Text(_user.displayName, style: TextStyle(fontSize: 25,),),
            SizedBox(
              height: 30,
            ),
            OutlineButton(onPressed: () async {
              await _signOut();
            },
            child: Text('LogOut', style: TextStyle(fontSize: 20,),),
            ),
          ],
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
setState(() {
  _islogin = true;
  _user = a.user;
});
  }

  Future _signOut() async {
    await _auth.signOut().then((value) {
      setState(() {
        _facebookLogin.logOut();
        _islogin = false;
      });
    });
  }
}
