import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:flutter_firebase_auth/screens/auth_screen.dart';

class MainPage extends StatefulWidget {
  final User user;

  const MainPage({Key key, this.user}) : super(key: key);
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  final GlobalKey<ScaffoldState> _scaffoldkey = GlobalKey<ScaffoldState>();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  FacebookLogin _facebookLogin = FacebookLogin();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldkey,
      body: Container(
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            child: Text('You are succeeded'),
          ),
          SizedBox(
            height: 30,
          ),
          CircleAvatar(
            radius: 40,
            backgroundImage: NetworkImage(widget.user.photoURL),
          ),
          Container(
            child: Text(widget.user.displayName,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25,color: Colors.black87),),
          ),
          Container(
            child: OutlineButton(
              shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(30.0)),
              borderSide: BorderSide(color: Theme.of(context).primaryColor, width: 1, style: BorderStyle.solid),
              onPressed: () async {
                _signOut().whenComplete(()
                {
                  Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_){
                    return AuthScreen();
                  }));
                });
              },
              child: Text('LogOut'),
            ),
          ),
        ],
        ),
      ),
    );
  }

  Future _signOut() async {
    await _auth.signOut().then((value) {
      setState(() {
        _facebookLogin.logOut();
      });
    });
  }
  // Future _signOut() async {
  //   await _auth.signOut();
  // }
}
