import 'package:http/http.dart' as http;
import 'dart:convert';

import 'quiz.dart';

var quizURL = 'http://www.cs.utep.edu/cheon/cs4381/homework/quiz?quiz=quiz';

Future<Quiz> fetchQuiz(var quizNumber) async {
  var httpResponse = await http.get(quizURL + quizNumber.toString().padLeft(2, '0'));

  if (httpResponse.statusCode != 200) {
    throw Exception('HTTP Request gave an invalid status code: ' +
        httpResponse.statusCode.toString());
  }
  var decode = json.decode(httpResponse.body);
  var quizResponse = decode['response'];

  if (quizResponse) {
    return Quiz.fromJSON(decode);
  }
  else{
    var reason = decode['reason'];
    throw Exception('Quiz request was false with reason: ' + reason);
  }
}