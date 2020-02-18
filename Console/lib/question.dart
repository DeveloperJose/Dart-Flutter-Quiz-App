abstract class Question {
  var stem;
  var answer;

  Question(this.stem, this.answer);

  String display();

  bool evaluateInput(String userInput);
}

class MultipleChoice extends Question {
  List options;

  MultipleChoice(stem, answer, this.options) : super(stem, answer);

  @override
  String display() {
    String result = stem + '\n';

    for (var i = 0; i < options.length; i++) {
      result += '\t${i + 1}: ${options[i]} \n';
    }

    return result;
  }

  @override
  bool evaluateInput(String userInput) {
    return userInput.toLowerCase() == answer.toString().toLowerCase();
  }
}

class FillInTheBlank extends Question {
  FillInTheBlank(stem, answer) : super(stem, answer);

  @override
  String display() {
    return stem + '\n';
  }

  @override
  bool evaluateInput(String userInput) {
    for (var ans in answer) {
      if (ans.toString().toLowerCase() == userInput.toLowerCase()) {
        return true;
      }
    }
    return false;
  }
}
