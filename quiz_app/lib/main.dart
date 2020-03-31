// Author: Jose G. Perez
// Main entry point of Flutter application
import 'package:flutter/material.dart';
import 'package:quizapp/create_quiz_page.dart';
import 'package:quizapp/navigate_quiz_page.dart';
import 'package:quizapp/results_quiz_page.dart';
import 'package:quizapp/review_quiz_page.dart';
import 'login_page.dart';

void main() => runApp(QuizApp());

class QuizApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Quiz App',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        initialRoute: 'login',
        routes: {
          'login': (context) => LoginPage(),
          'create_quiz': (context) => CreateQuizPage(),
          'navigate_quiz': (context) => NavigateQuizPage(),
          'review_quiz': (context) => ReviewQuizPage(),
          'results_quiz': (context) => ResultsQuizPage()
        });
  }
}
