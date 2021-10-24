class Question {
  String _stem = '';
  var _answer = '';
  var _userAnswer = '';

  getAnswer() {
    return this._answer;
  }

  void setAnswer(var answer) {
    this._answer = answer;
  }

  String getStem() {
    return this._stem;
  }

  void setStem(String stem) {
    this._stem = stem;
  }

  getUserAnswer() {
    return this._userAnswer;
  }

  void setUserAnswer(var answer) {
    this._userAnswer = answer;
  }

  bool isCorrect() {
    return getAnswer() == getUserAnswer();
  }
}
