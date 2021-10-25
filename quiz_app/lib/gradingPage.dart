import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:quizapp/createQuiz.dart';
import 'package:http/http.dart' as http;
import 'package:quizapp/takeQuiz.dart';

var questionsWrongIndexes = [];

class GradingPage extends StatelessWidget {
  const GradingPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      themeMode: ThemeMode.dark,
      theme: ThemeData(
        primarySwatch: Colors.purple,
      ),
      home: GradePage(title: 'Grading'),
    );
  }
}

class GradePage extends StatefulWidget {
  GradePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _GradePageState createState() => _GradePageState();
}

class _GradePageState extends State<GradePage> {

  int _getScore() {
    int score = 0;
    int numQuestions = questions.length;
    for(int i=0; i<questions.length; i++){
      print(questions[i].getAnswer().toString());
      questions[i].setUserAnswer(answers[i]);
      if (questions[i].isCorrect()){
        score+=1;
      } else {
        questionsWrongIndexes.add(i);
      }
    }
    print(answers);
    print(score);
    return score;
  }

  Widget _confirmExit(BuildContext context) {
    return new AlertDialog(
      title: const Text('Are you sure you would like to exit?'),
      actions: <Widget>[
        new ElevatedButton(
          style: ElevatedButton.styleFrom(
            primary: Colors.red,
          ),
          onPressed: () {
            SystemNavigator.pop();
          },
          child: Center(child: const Text('Exit')),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),),
        body: Center(child: Column(children: <Widget> [
          SizedBox(height:40),
          Text("You Scored: ", style: TextStyle(color: Colors.black,fontSize: 30,fontWeight: FontWeight.bold)),
          SizedBox(height:20),
          Row(crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget> [

          Text("${_getScore()} / ${questions.length}", style: TextStyle(color: Colors.green,fontSize: 20,fontWeight: FontWeight.bold)),
                SizedBox(width:10),
          Text("points", style: TextStyle(color: Colors.black,fontSize: 20,fontWeight: FontWeight.bold))
            ]),
          SizedBox(height:80),
            ElevatedButton(
                style: ElevatedButton.styleFrom(
                  primary: Colors.blue,
                ),
                child: Text('Review Quiz'),
                onPressed: () {}
                ),
          SizedBox(height:40),
          ElevatedButton(
              style: ElevatedButton.styleFrom(
                primary: Colors.red,
              ),
              child: Text('Exit'),
              onPressed: () {
                showDialog(
                    context: context,
                    builder: (BuildContext context) => _confirmExit(context),);
              }
          ),
        ]))
    );
  }
}