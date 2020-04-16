import 'package:flutter/material.dart';
import 'auth.dart';
import 'dialogbox.dart';

class Login extends StatefulWidget {
  final AuthImplementation auth;
  final VoidCallback onSignedIn;
  Login({
    this.auth,
    this.onSignedIn,
  });
  @override
  _LoginState createState() => _LoginState();
}

enum FormType { login, register }

class _LoginState extends State<Login> {
  DialogBox dialogBox = DialogBox();

  final formKey = GlobalKey<FormState>();
  FormType _formType = FormType.login;
  String _email = "";
  String _password = "";

  bool formValidateAndSave() {
    final form = formKey.currentState;
    //print("valsave" + _email + " " + _password);
    if (form.validate()) {
      form.save();
      return true;
    } else {
      return false;
    }
  }

  void formSubmit() async {
    if (formValidateAndSave()) {
      try {
        if (_formType == FormType.login) {
          String userId = await widget.auth.signIn(_email, _password);
          dialogBox.information(
              context, "Congratulations", "You are logged in successfully");
          print(userId);
        } else {
          String userId = await widget.auth.signUp(_email, _password);
          dialogBox.information(context, "Congratulations",
              "Your account has been created successfully");
          print(userId);
        }
        widget.onSignedIn();
      } catch (e) {
        dialogBox.information(context, "Error", e.toString());
        print("error in formSubmit: " + e.toString());
      }
    }
  }

  void moveToRegister() {
    formKey.currentState.reset();

    setState(() {
      _formType = FormType.register;
    });
  }

  void moveToLogin() {
    formKey.currentState.reset();

    setState(() {
      _formType = FormType.login;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
        margin: EdgeInsets.all(25),
        child: Form(
          key: formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              SizedBox(
                height: 5,
              ),
              Image(
                image: AssetImage('assets/logo.png'),
                height: 250,
              ),
              Container(
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8.0),
                    boxShadow: [
                      BoxShadow(
                          color: Colors.black12,
                          offset: Offset(0.0, 15.0),
                          blurRadius: 15.0),
                      BoxShadow(
                          color: Colors.black12,
                          offset: Offset(0.0, -10.0),
                          blurRadius: 10.0),
                    ]),
                child: Padding(
                  padding: EdgeInsets.only(left: 20, right: 20, bottom: 25),
                  child: Column(
                    children: createInputs(),
                  ),
                ),
              ),
              Container(
                child: Column(
                  children: createButtons(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> createInputs() {
    return [
      TextFormField(
        decoration: InputDecoration(labelText: 'Email'),
        validator: (value) {
          return value.isEmpty ? 'Email is required' : null;
        },
        onSaved: (value) {
          return _email = value;
        },
      ),
      SizedBox(
        height: 10,
      ),
      TextFormField(
        decoration: InputDecoration(labelText: 'Password'),
        obscureText: true,
        validator: (value) {
          return value.isEmpty ? 'Password is required' : null;
        },
        onSaved: (value) {
          return _password = value;
        },
      ),
    ];
  }

  List<Widget> createButtons() {
    if (_formType == FormType.login) {
      return [
        SizedBox(
          height: 20,
        ),
        InkWell(
          onTap: formSubmit,
          child: Container(
            width: 100,
            decoration: BoxDecoration(
                gradient: LinearGradient(colors: [Colors.cyan, Colors.blue]),
                borderRadius: BorderRadius.circular(6.0),
                boxShadow: [
                  BoxShadow(
                      color: Color(0xFF6078ea).withOpacity(.3),
                      offset: Offset(0.0, 8.0),
                      blurRadius: 8.0)
                ]),
            child: Center(
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 10),
                child: Text(
                  "LOGIN",
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.5),
                ),
              ),
            ),
          ),
        ),
        FlatButton(
          child: Text("Don't have an account? Register"),
          onPressed: moveToRegister,
        )
      ];
    } else {
      return [
        SizedBox(
          height: 20,
        ),
        InkWell(
          onTap: formSubmit,
          child: Container(
            width: 100,
            decoration: BoxDecoration(
                gradient: LinearGradient(colors: [Colors.cyan, Colors.blue]),
                borderRadius: BorderRadius.circular(6.0),
                boxShadow: [
                  BoxShadow(
                      color: Color(0xFF6078ea).withOpacity(.3),
                      offset: Offset(0.0, 8.0),
                      blurRadius: 8.0)
                ]),
            child: Center(
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 10),
                child: Text(
                  "REGISTER",
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.5),
                ),
              ),
            ),
          ),
        ),
        FlatButton(
          child: Text("Already have an account ? Login"),
          onPressed: moveToLogin,
        )
      ];
    }
  }
}
