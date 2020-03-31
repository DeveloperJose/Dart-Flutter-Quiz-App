/// Author: Jose G. Perez
import 'dart:convert';

import 'package:http/http.dart' as http;

import 'question.dart';
import 'quiz.dart';

var baseQuizURL = 'http://www.cs.utep.edu/cheon/cs4381/homework/quiz/post.php';
var baseFigureURL = 'http://www.cs.utep.edu/cheon/cs4381/homework/quiz/figure.php?name=';

/// Gets the requested quiz from the class website
///
/// Throws an [Exception] if the HTTP request gives an invalid status or if the quiz request is denied.
Future<Quiz> fetchQuiz(String username, String password, var quizNumber) async {
  String quizString = 'quiz' + quizNumber.toString().padLeft(2, '0');
  var body = '{"user": "$username", "pin": "$password", "quiz": "$quizString" }';
  var httpResponse = await http.post(baseQuizURL, body: body);

  if (httpResponse.statusCode != 200) {
    throw Exception('HTTP request gave an invalid status code: ' + httpResponse.statusCode.toString());
  }
  var decode = json.decode(httpResponse.body);
  var quizResponse = decode['response'];

  if (quizResponse) {
    return Quiz.fromJSON(decode);
  } else {
    var reason = decode['reason'];
    throw Exception(reason);
  }
}

/// Gets all the available questions from the class website
Future<List<Question>> fetchWholeQuestionPool(String username, String password) async {
  List<Question> result = [];

  int quizNumber = 0;
  while (true) {
    try {
      Quiz quiz = await fetchQuiz(username, password, quizNumber);
      result.addAll(quiz.questions);
      print("Loaded quiz $quizNumber succesfully.");
      quizNumber++;
    } catch (ex) {
      return result;
    }
  }
  return result;
}
