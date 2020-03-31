// Author: Jose G. Perez
import 'package:edit_distance/edit_distance.dart';

/// Edit Distance algorithm used to evaluate if an answer is correct for fill in the blank
/// Doing this allows for 1 to 2 character typos
var levenshtein = Levenshtein();
var allowedTypos = 2;

/// General question class
abstract class Question {
  /// The stem presents the problem to be solved or the question to be answered
  var stem;

  // The possible answer or list of possible answers
  var correctAnswer;

  // The URL of the provided figure
  var figureURL;

  // Is this question being reviewed?
  bool isUnderReview = false;

  // The attempted answer used when grading
  String attemptedAnswer = '';

  /// Creates a new question with the given stem and answer
  Question(this.stem, this.correctAnswer, this.figureURL);

  /// String representation of question stem and answers for output display
  String display();

  /// Evaluates whether the user input is the correct answer for this question
  bool isCorrectAnswer();

}

/// A question where multiple options are given
class MultipleChoice extends Question {
  /// The choice options of this question
  List options;

  MultipleChoice(stem, answer, figureURL, this.options) : super(stem, answer, figureURL);

  @override
  String display() {
    String result = stem + '\n';

    for (var i = 0; i < options.length; i++) {
      result += '\t${i + 1}: ${options[i]} \n';
    }

    return result;
  }

  @override
  bool isCorrectAnswer() {
    return attemptedAnswer.toLowerCase() == options[correctAnswer-1].toString().toLowerCase();
  }
}

// A question where the user must fill in a blank
class FillInTheBlank extends Question {
  FillInTheBlank(stem, answer, figureURL) : super(stem, answer, figureURL);

  @override
  String display() {
    return stem + '\n';
  }

  @override
  bool isCorrectAnswer() {
    for (var ans in correctAnswer) {
      // Allow for small typos using edit distance
      var editDistance = levenshtein.distance(attemptedAnswer, ans.toString());
      if (editDistance <= allowedTypos) {
        return true;
      }
    }
    return false;
  }
}
