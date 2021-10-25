import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:quizapp/createQuiz.dart';
import 'package:http/http.dart' as http;
import 'package:quizapp/takeQuiz.dart';
import 'package:quizapp/gradingPage.dart';

int i=0;
class Review extends StatelessWidget {
  const Review({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      themeMode: ThemeMode.dark,
      theme: ThemeData(
        primarySwatch: Colors.purple,
      ),
      home: ReviewPage(title: 'Grading'),
    );
  }
}

class ReviewPage extends StatefulWidget {
  ReviewPage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _ReviewPageState createState() => _ReviewPageState();
}

class _ReviewPageState extends State<ReviewPage> {

  int _value = 0;


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
          title: Text(widget.title),
        ),
        body: SingleChildScrollView( child: Center(child: Column(
          children: [
            SafeArea(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding:
                      const EdgeInsets.fromLTRB(15,20,0,0),
                      child: Text("Question ${i+1}"),
                    ),
                    SizedBox(height: 10),
                    Divider(thickness: 1.5),
                    Container(
                        padding: EdgeInsets.all(30),
                        decoration: BoxDecoration(
                          color: Colors.lightGreen,
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Column(
                            children: [
                              Text(questions[i].getStem().toString(), style: TextStyle(color: Colors.black,fontSize: 14,fontWeight: FontWeight.bold)),
                              SizedBox(height:25),
                              if (questions[i].runtimeType.toString() == "FillInQuestion")
                                Container(
                                   width: 300,
                                   child: Column(children: <Widget> [
                                     Text("UserAnswer: ", style:TextStyle(color: Colors.black,fontSize: 14,fontWeight: FontWeight.bold)),
                                     Text("${questions[i].getUserAnswer()}", style: TextStyle(color: Colors.pink,fontSize: 14,fontWeight: FontWeight.bold)),
                                     Text("CorrectAnswer:",style:TextStyle(color: Colors.black,fontSize: 14,fontWeight: FontWeight.bold)),
                                     Text("${questions[i].getUserAnswer()}", style: TextStyle(color: Colors.blue,fontSize: 14,fontWeight: FontWeight.bold))
                                   ]
                                   ),
                                ),
                              SizedBox(height:15),
                              if (questions[i].runtimeType.toString() == "MultipleChoiceQuestion")
                                Container(
                                  width: 300,
                                  child: Column(children: <Widget> [
                                    Text("UserAnswer: ", style:TextStyle(color: Colors.black,fontSize: 14,fontWeight: FontWeight.bold)),
                                    Text("${questions[i].getOptions()[(int.parse(answers[i])-1)]}", style:TextStyle(color: Colors.pink,fontSize: 14,fontWeight: FontWeight.bold)),
                                    Text("CorrectAnswer:",style:TextStyle(color: Colors.black,fontSize: 14,fontWeight: FontWeight.bold)),
                                    Text("${questions[i].getOptions()[(int.parse(questions[i].getAnswer()))-1]}", style: TextStyle(color: Colors.blue,fontSize: 14,fontWeight: FontWeight.bold)),
                                  ]
                                  ),
                                ),
                              BottomNavigationBar(
                                  onTap: (int idx){
                                    if (idx == 0){
                                      setState(() {
                                        if (i>0) {
                                          i -= 1;
                                        }
                                      });
                                    }
                                    if (idx == 1){
                                      setState(() {
                                        if (i<questions.length-1) {
                                          i += 1;
                                        } else{
                                          showDialog(
                                            context: context,
                                            builder: (BuildContext context) =>  _confirmExit(context),);
                                        }
                                      });
                                    }
                                  },
                                  items: <BottomNavigationBarItem> [
                                    BottomNavigationBarItem(
                                      icon: const Icon(Icons.arrow_back),
                                      title: Text('back'),
                                      backgroundColor: Colors.black,
                                    ),
                                    if (i == last) BottomNavigationBarItem(
                                      icon: const Icon(Icons.local_pizza),
                                      title: Text('Finish Review'),
                                      backgroundColor: Colors.yellow,
                                    ),
                                    if (i != last) BottomNavigationBarItem(
                                      icon: const Icon(Icons.arrow_forward),
                                      title: Text('next'),
                                      backgroundColor: Colors.yellow,
                                    ),
                                  ]

                              ),
                  ]),
            )],
        ),
        )]
        ),
    ),)
    );
  }
}