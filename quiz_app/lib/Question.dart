class Question {
  String _stem = '';
  var _answer = '';
  var _userAnswer = '';
  var _figure = '';

  getAnswer() {
    return this._answer;
  }

  void setAnswer(var answer) {
    this._answer = answer;
  }

  getFigure() {
    return this._answer;
  }

  void setFigure(var figure) {
    this._figure = figure;
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
