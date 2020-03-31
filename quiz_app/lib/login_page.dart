// Author: Jose G. Perez
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  LoginPage({Key key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {


  void onSignInPressed(){

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login Page'),
      ),
      body: Container(
        padding: EdgeInsets.all(30.0),
        child: Column(
          children: [
            this.buildFormWidget(context),
          ],
        ),
      ),
    );
  }

  Widget buildFormWidget(BuildContext context) {
    return Form(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          buildDescriptionWidget(),
          buildUsernameWidget(),
          buildPasswordWidget(),
          buildSubmitWidget(),
          buildHintTextWidget(),
        ],
      ),
    );
  }

  Widget buildDescriptionWidget() {
    return Center(
      child: Text(
        "CS 4381",
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 48,
          color: Colors.green,
        ),
      ),
    );
  }

  Widget buildUsernameWidget() {
    return TextFormField(
      keyboardType: TextInputType.text,
      decoration: InputDecoration(hintText: 'username', labelText: 'Username*', icon: Icon(Icons.person)),
    );
  }

  Widget buildPasswordWidget() {
    return TextFormField(
      keyboardType: TextInputType.text,
      obscureText: true,
      decoration: InputDecoration(hintText: 'password', labelText: 'Password', icon: Icon(Icons.lock)),
    );
  }

  Widget buildSubmitWidget() {
    return RaisedButton(
      child: Text('Sign In'),
      onPressed: onSignInPressed,
    );
  }

  Widget buildHintTextWidget() {
    return Text(
        '*User name of your primary email address provided to by UTEP, typically your @miners email address',
        style: TextStyle(fontSize: 10));
  }
}
