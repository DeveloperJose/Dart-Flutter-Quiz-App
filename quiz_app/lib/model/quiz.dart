// Author: Jose G. Perez
import 'question.dart';

/// Represents a quiz, which is a collection of fill-in-the-blank and multiple-choice questions
class Quiz {
  /// The name of the quiz given by the website
  String name;

  /// The questions of the quiz
  List<Question> questions;

  Quiz(this.name, this.questions);

  QuizGrade grade(answers) {
    var totalQuestions = questions.length;
    var totalCorrect = 0;
    for (var i = 0; i < totalQuestions; i++) {
      var userAnswer = answers[i];
      var question = questions[i];
      if (question.evaluateInput(userAnswer.toString())) totalCorrect++;
    }
    return QuizGrade(totalCorrect, totalQuestions);
  }

  /// Creates a quiz by parsing a JSON
  static Quiz fromJSON(var json) {
    var jsonName = json['quiz']['name'];
    var jsonQuestions = json['quiz']['question'];
    var parsedQuestions = <Question>[];

    jsonQuestions.forEach((question) {
      var stem = question['stem'];
      var type = question['type'];
      var answer = question['answer'];
      // MultipleChoice
      if (type == 1) {
        var options = question['option'];
        parsedQuestions.add(MultipleChoice(stem, answer, options));
      }
      // FillInBlank
      else {
        parsedQuestions.add(FillInTheBlank(stem, answer));
      }
    });

    // Scramble the questions
    parsedQuestions.shuffle();
    return Quiz(jsonName, parsedQuestions);
  }
}

/// Contains the information regarding a quiz grade
class QuizGrade {
  /// The numerical grade, which is defined as the correct / total
  double numericalGrade;

  /// The total number of correct questions
  int totalCorrect;

  /// The total number of questions
  int totalQuestions;

  QuizGrade(this.totalCorrect, this.totalQuestions) {
    numericalGrade = totalCorrect / totalQuestions;
  }

  /// Checks if this was a perfect score, that is, if you got all questions correctly
  bool isPerfect() {
    return totalCorrect == totalQuestions;
  }

  /// Converts this grade into percentage with two decimals
  String formatNumerical() {
    return (numericalGrade * 100).toStringAsFixed(2) + '%';
  }

  /// Converts this grade into the letter format [A,B,C,D,F]
  String formatLetter() {
    if (numericalGrade < 0 || numericalGrade > 100) {
      return 'Invalid';
    } else if (numericalGrade < 0.6) {
      return 'F';
    } else if (numericalGrade < 0.7) {
      return 'D';
    } else if (numericalGrade < 0.8) {
      return 'C';
    } else if (numericalGrade < 0.9) {
      return 'B';
    } else {
      return 'A';
    }
  }
}
