// Author: Jose G. Perez
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  LoginPage({Key key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login Page'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            this.buildFormWidget(context),
          ],
        ),
      ),
    );
  }

  Widget buildFormWidget(BuildContext context){
    return Form(child: Column(children: [
      buildUsernameWidget(),
      buildPasswordWidget(),
      buildSubmitWidget(),
    ]));
  }

  Widget buildUsernameWidget(){
    return TextFormField(
      keyboardType: TextInputType.text,
      decoration: InputDecoration(hintText: 'utep', labelText: 'Username'),
    );
  }

  Widget buildPasswordWidget(){
    return TextFormField(
      keyboardType: TextInputType.text,
      obscureText: true,
      decoration: InputDecoration(hintText: 'password', labelText: 'Password'),
    );
  }

  Widget buildSubmitWidget(){
    return RaisedButton(
      child: Text('Log In')
    );
  }
}
