/**
 * Author: Jose G. Perez
 */
import 'dart:io' as io;

import 'package:DQuiz_Console/networking.dart';
import 'package:DQuiz_Console/quiz.dart';

void main(List<String> arguments) async {
  // Select quiz
  print('██████╗        ██████╗ ██╗   ██╗██╗███████╗');
  print('██╔══██╗      ██╔═══██╗██║   ██║██║╚══███╔╝');
  print('██║  ██║█████╗██║   ██║██║   ██║██║  ███╔╝ ');
  print('██║  ██║╚════╝██║▄▄ ██║██║   ██║██║ ███╔╝  ');
  print('██████╔╝      ╚██████╔╝╚██████╔╝██║███████╗');
  print('╚═════╝        ╚══▀▀═╝  ╚═════╝ ╚═╝╚══════╝');
  print('DQuiz v1.0 by Jose G. Perez');
  print('');
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
      var shouldGrade = promptBool('* That was the last question of the quiz. Grade it? [Y/N] *');
      if (shouldGrade) {
        isTakingQuiz = false;
      } else {
        currentIDX = quiz.questions.length - 1;
      }
    }
  }

  // Quiz results
  var grade = quiz.grade(currentAnswers);
  print('You got ${grade.totalCorrect} out of ${grade.totalQuestions} correct.');
  print('Your numerical grade is: ${grade.formatNumerical()}');
  print('Your letter grade is: ${grade.formatLetter()}');

  // Only review if they got something incorrect and they say yes to reviewing
  if (!grade.isPerfect()) {
    var shouldReview = promptBool('Want to review your incorrect answers? [Y/N]');
    if (shouldReview) {
      review(currentAnswers, quiz);
    }
  }
  print('Finished!');
}

/// Reviews the incorrect answers the user gave for a quiz
void review(List<String> currentAnswers, Quiz quiz) {
  print('Now reviewing. After a question, type anything to move to the next one.');
  for (var i = 0; i < quiz.questions.length; i++) {
    var userAnswer = currentAnswers[i];
    var question = quiz.questions[i];
    var isCorrect = question.evaluateInput(userAnswer);
    if (!isCorrect) {
      print('Q${i}: ${question.display()}');
      print('* Your Answer: ${userAnswer} *');
      print('* Correct Answer: ${question.answer} *');
      io.stdin.readLineSync();
    }
  }
}

/// Prompts the user with the given message and checks if they say yes/y/true
bool promptBool(message) {
  print(message);
  var userInput = io.stdin.readLineSync().toLowerCase();
  return (userInput == 'y' || userInput == 'yes' || userInput == 'true');
}
