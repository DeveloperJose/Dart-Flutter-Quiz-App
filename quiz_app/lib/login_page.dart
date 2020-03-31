// Author: Jose G. Perez
import 'package:progress_dialog/progress_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'model/networking.dart';
import 'model/question.dart';

class LoginPage extends StatefulWidget {
  LoginPage({Key key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String mUsername = '';
  String mPassword = '';

  final GlobalKey<FormState> _formKey = GlobalKey();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();

  void onSignInPressed() async {
    // Check if form is valid first
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();

      // Get the question pool from the network now so we don't have to do this later
      List<Question> allQuestions;

      var progressDialog = ProgressDialog(context, type: ProgressDialogType.Normal, isDismissible: false);
      progressDialog.show();
      try {
        // Check if login is valid with quiz00
        progressDialog.update(message: 'Checking username and password...');
        await fetchQuiz(mUsername, mPassword, 0);

        // Load all the quizzes and combine the questions to form the pool
        progressDialog.update(message: 'Loading all quizzes to form question pool...');
        allQuestions = await fetchWholeQuestionPool(mUsername, mPassword);
      } catch (ex) {
        _scaffoldKey.currentState.hideCurrentSnackBar();
        _scaffoldKey.currentState.showSnackBar(SnackBar(content: Text(ex.toString()), duration: Duration(seconds: 2)));
      } finally {
        progressDialog.dismiss();
      }

      // Move to create quiz screen if we got questions
      if (allQuestions != null) {
        print('Questions loaded:  ${allQuestions.length}');
        Navigator.pushNamed(context, 'create_quiz', arguments: allQuestions);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text('Login Page'),
      ),
      body: Container(
        padding: EdgeInsets.all(30.0),
        child: Column(
          children: [buildDescriptionWidget(), this.buildFormWidget(context), buildHintTextWidget()],
        ),
      ),
    );
  }

  Widget buildFormWidget(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          buildUsernameWidget(),
          buildPasswordWidget(),
          buildSubmitWidget(),
        ],
      ),
    );
  }

  Widget buildDescriptionWidget() {
    return Center(
      child: Text(
        "CS 4381/5381",
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
      onSaved: (value) => mUsername = value,
      validator: (value) {
        if (value.isEmpty) return 'Username cannot be empty';
        return null;
      },
      keyboardType: TextInputType.text,
      decoration: InputDecoration(
        hintText: 'username',
        labelText: 'Username*',
        icon: Icon(Icons.person),
      ),
    );
  }

  Widget buildPasswordWidget() {
    return TextFormField(
      onSaved: (value) => mPassword = value,
      validator: (value) {
        if (value.isEmpty) return 'Password cannot be empty';
        return null;
      },
      keyboardType: TextInputType.text,
      obscureText: true,
      decoration: InputDecoration(
        hintText: 'password',
        labelText: 'Password',
        icon: Icon(Icons.lock),
      ),
    );
  }

  Widget buildSubmitWidget() {
    return RaisedButton(
      child: Text('Sign In'),
      onPressed: onSignInPressed,
    );
  }

  Widget buildHintTextWidget() {
    return Text('*User name of your primary email address provided to by UTEP, typically your @miners email address',
        style: TextStyle(fontSize: 10));
  }
}
