import 'package:flutter/material.dart';
import 'login.dart';
import 'auth.dart';
import 'feed.dart';

class Linker extends StatefulWidget {
  final AuthImplementation auth;
  Linker({
    this.auth,
  });
  @override
  _LinkerState createState() => _LinkerState();
}

enum authStatus { notSignedIn, signedIn }

class _LinkerState extends State<Linker> {
  authStatus _authStatus = authStatus.notSignedIn;

  @override
  void initState() {
    super.initState();
    widget.auth.getCurrentUser().then((firebaseUserId) {
      setState(() {
        _authStatus = firebaseUserId == null
            ? authStatus.notSignedIn
            : authStatus.signedIn;
      });
    });
  }

  void _signedIn(){
    setState(() {
      _authStatus = authStatus.signedIn;
    });
  }
  void _signedOut(){
    setState(() {
      _authStatus = authStatus.notSignedIn;
    });
  }
  @override
  Widget build(BuildContext context) {
    switch(_authStatus){
      case authStatus.notSignedIn:
      return Login(
        auth: widget.auth,
        onSignedIn: _signedIn,
      );
      case authStatus.signedIn:
      return Feed(
        auth: widget.auth,
        onSignedOut: _signedOut,
      );
    }

    return null;
  }
}
