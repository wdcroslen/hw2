import 'Question.dart';

class FillInQuestion extends Question {
  bool isCorrect() {
    var answer = getAnswer().replaceAll("[", "");
    answer = answer.replaceAll("]", "");
    List answerList = answer.split(',');

    for (var i = 0; i < answerList.length; i++) {
      if (answerList[i].toLowerCase() ==
          getUserAnswer().toString().toLowerCase()) {
        return true;
      }
    }
    return false;
  }
}
