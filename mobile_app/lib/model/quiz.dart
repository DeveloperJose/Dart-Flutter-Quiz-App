/// Author: Jose G. Perez
import 'question.dart';

/// Represents a quiz, which is a collection of fill-in-the-blank and multiple-choice questions
class Quiz {
  /// The name of the quiz given by the website
  String name;

  /// The questions of the quiz
  List<Question> questions;

  // Whether or not this quiz is currently being reviewed
  bool _isReviewing = false;

  get isReviewing => _isReviewing;

  set isReviewing(newValue) {
    _isReviewing = newValue;
    questions.forEach((question) => question.isUnderReview = newValue);
  }

  Quiz(this.name, this.questions);

  /// Grades this quiz using the provided answers
  QuizGrade grade() {
    var totalQuestions = questions.length;
    var totalCorrect = 0;
    for (var i = 0; i < totalQuestions; i++) {
      var question = questions[i];
      print('[Grading] Given ${question.attemptedAnswer}, Correct: ${question.correctAnswer}');
      if (question.isCorrectAnswer()) totalCorrect++;
    }
    return QuizGrade(totalCorrect, totalQuestions);
  }

  /// Clears all the previously written answers of this quiz
  void resetAnswers() {
    questions.forEach((question) => question.attemptedAnswer = '');
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
      var figureURL = question['figure'];
      print('Figure: $figureURL');

      // MultipleChoice
      if (type == 1) {
        var options = question['option'];
        parsedQuestions.add(MultipleChoice(stem, answer, figureURL, options));
      }
      // FillInBlank
      else {
        parsedQuestions.add(FillInTheBlank(stem, answer, figureURL));
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
