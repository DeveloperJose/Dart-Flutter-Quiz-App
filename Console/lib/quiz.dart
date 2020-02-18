import 'question.dart';

class Quiz {
  String name;
  List<Question> questions;

  Quiz(this.name, this.questions);

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

    return Quiz(jsonName, parsedQuestions);
  }
}
