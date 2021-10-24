import 'package:http/http.dart' as http;
import 'dart:convert';
import 'FillInQuestion.dart';
import 'MultipleChoiceQuestion.dart';

/// Class that interacts with the server
class WebClient {
  /// Returns the json response from a server
//  this.questions = Future<List<Question>>;

  Future<String> getResponse(var url) async {
    var response;
    if (url == null) {
      print("Oh NO your url isn't right!!");
    } else {
      response = await http.get(url);
    }
    response = parseJson(response.body);
    return response;
  }

  String getQuiz(var userChoice, var webService) {
    print(userChoice);
    if (userChoice < 10) {
      webService = webService + '?quiz=quiz0' + userChoice.toString();
    } else {
      webService = webService + '?quiz=quiz' + userChoice.toString();
    }
    return webService;
  }

  /// returns a list of question objects based on the url of the quiz
  Future generateQuiz(var response) async {
    var questionList = [];
    var quizLength = response['quiz']['question'].length;
    for (var i = 0; i < quizLength; i++) {
      var type = response['quiz']['question'][i]['type'];
      var question = (type == 1)
          ? MultipleChoiceQuestion.option(
          response['quiz']['question'][i]['option'])
          : FillInQuestion();

      question.setStem(response['quiz']['question'][i]['stem']);
      question.setAnswer(response['quiz']['question'][i]['answer'].toString());
      questionList.add(question);
    }
    return questionList;
  }

  dynamic parseJson(var response) {
    return json.decode(response);
  }
}
