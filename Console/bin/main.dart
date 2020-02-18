import 'dart:io' as io;

import 'package:DQuiz_Console/networking.dart';

void main(List<String> arguments) async {
  // Select quiz
  print('Please select the quiz you will be taking: [1-4]');
  var quizNumber = io.stdin.readLineSync();

  var quiz = await fetchQuiz(quizNumber);
  var currentAnswers = List.filled(quiz.questions.length, '');
  var currentIDX = 0;

  print('***** Now taking ${quiz.name} *****');
  print('Type < to navigate to the previous question');
  print('Type > to navigate to the next question');
  print('');

  var isTakingQuiz = true;
  while (isTakingQuiz) {
    var currentQuestion = quiz.questions[currentIDX];
    var prevAnswer = currentAnswers[currentIDX];

    // Display question number and then the question
    print('Q${currentIDX}: ${currentQuestion.display()}');

    // Display the previously filled answer if it exists
    if (prevAnswer.isNotEmpty) {
      print('Previous Answer: ${currentAnswers[currentIDX]}');
    }

    // Get the user input and process it
    var userInput = io.stdin.readLineSync();
    if (userInput == '<' && currentIDX > 0) {
      currentIDX--;
    } else if (userInput == '>' && currentIDX < quiz.questions.length) {
      currentIDX++;
    } else {
      currentAnswers[currentIDX] = userInput;
      currentIDX++;
    }

    // Check if this is the last question and prompt the user to finish the quiz
    if (currentIDX >= quiz.questions.length) {
      print('* That was the last question of the quiz. Grade it? [Y/N] *');
      var shouldGrade = io.stdin.readLineSync().toLowerCase();
      if (shouldGrade == 'y') {
        isTakingQuiz = false;
      } else {
        currentIDX = quiz.questions.length - 1;
      }
    }
  }
  var totalQuestions = quiz.questions.length;
  var totalCorrect = 0;
  for (var i = 0; i < totalQuestions; i++) {
    var userAnswer = currentAnswers[i];
    var question = quiz.questions[i];
    if (question.evaluateInput(userAnswer)) totalCorrect++;
  }
  print('You got ${totalCorrect} out of ${totalQuestions} correct.');
  print(
      'Your numerical grade is: ${(totalCorrect / totalQuestions * 100).toStringAsFixed(2)}%');

  if (totalCorrect < totalQuestions) {
    print('Want to review your incorrect answers?');
    var shouldReview = io.stdin.readLineSync().toLowerCase();
    if (shouldReview == 'y') {
      for (var i = 0; i < totalQuestions; i++) {
        var userAnswer = currentAnswers[i];
        var question = quiz.questions[i];
        var isCorrect = question.evaluateInput(userAnswer);
        if (!isCorrect){
          print('Q${i}: ${question.display()}');
          print('* Your Answer: ${userAnswer} *');
          print('* Correct Answer: ${question.answer} *');
        }
      }
    }
  }
}
