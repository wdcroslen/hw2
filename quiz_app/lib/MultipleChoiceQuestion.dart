import 'Question.dart';
import 'dart:io';

class MultipleChoiceQuestion extends Question {
  var _options = [];

  MultipleChoiceQuestion.option(this._options) {
    setOptions(this._options);
  }

  List getOptions() {
    return this._options;
  }

  void setOptions(List options) {
    this._options = options;
  }
}
