import 'package:flutter/material.dart';
import 'package:quizapp/createQuiz.dart';
import 'package:http/http.dart' as http;
import 'package:quizapp/gradingPage.dart';

import 'Question.dart';

int i = 0;
int last = questions.length-1;
var answers = List.filled(questions.length, "", growable: true);

class InQuizPage extends StatelessWidget {
  const InQuizPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      themeMode: ThemeMode.dark,
      theme: ThemeData(
        primarySwatch: Colors.grey,
      ),
      home: DuringQuizPage(title: 'LockDownBrowser'),
    );
  }
}

class DuringQuizPage extends StatefulWidget {
  DuringQuizPage({Key? key, required this.title}) : super(key: key);


  final String title;
  Question a = questions[0];


  @override
  _DuringQuizPageState createState() => _DuringQuizPageState();
}

class _DuringQuizPageState extends State<DuringQuizPage> {
  final GlobalKey<FormFieldState<String>> _userAnswer = GlobalKey();
  int _value = 0;
  String radioSelected="";
  get _values =>
      ({
        'userAns': _userAnswer.currentState?.value,
      });

  Widget _confirmSubmit(BuildContext context) {
    return new AlertDialog(
      title: const Text('Are you sure you would like to submit?'),
      actions: <Widget>[
        new ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => GradingPage()),);
          },
          child: Center(child: const Text('Confirm')),
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
                        color: Colors.tealAccent,
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Column(
                          children: [
                            Text(questions[i].getStem().toString(), style: TextStyle(color: Colors.black,fontSize: 14,fontWeight: FontWeight.bold)),
                            // Text("${index+1}.",style: TextStyle(color: Colors.black,fontSize: 14,fontWeight: FontWeight.bold),)
                            SizedBox(height:25),
                            if (questions[i].runtimeType.toString() == "FillInQuestion") Container(
                              width: 300,
                              child:
                              TextFormField(
                                initialValue: answers[i],
                                key: _userAnswer,
                                decoration:
                                InputDecoration(
                                  hintText: 'Your Answer',
                                  border: OutlineInputBorder(),
                                ),
                              ),

                            ),

                            SizedBox(height:15),
                            if (questions[i].runtimeType.toString() == "MultipleChoiceQuestion") Container(
                              child:
                                ListView.builder(
                                  shrinkWrap: true
                                  ,itemBuilder: (context,index){
                                  return Column(
                                    children: [
                                      Padding(
                                          padding: const EdgeInsets.fromLTRB(0,0,0,2),
                                          child:
                                          Container(width: 250,
                                              decoration: BoxDecoration(
                                                // color: Colors.white,
                                              ),
                                              child: Row(crossAxisAlignment: CrossAxisAlignment.center,
                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  children: [
                                            Radio(  value: index,
                                              groupValue: _value,
                                              activeColor: Colors.black,
                                              onChanged: (value){
                                                setState((){
                                                  _value = index;
                                                  answers[i] = (index+1).toString();
                                                  // radioSelected = value.toString();
                                                  print(answers);
                                                });
                                              },),

                                            Container(width:190, height: 71, child: Text("${questions[i].getOptions()[index]}",style: TextStyle(color: Colors.black,fontSize: 12,fontWeight: FontWeight.bold),),
                                            ) ,
                                                    Divider(
                                                      height: 2,
                                                      color: Colors.red,
                                                    )]),
                                                       // Text("${questions[i].getOptions()[index]}",style: TextStyle(color: Colors.black,fontSize: 14,fontWeight: FontWeight.bold),)),])
                                          )),
                                    ],
                                  );
                                },itemCount: questions[i].getOptions().length,))


                          ])
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
                            answers[i] = _values['userAns'];
                          });
                        }
                        if (idx == 2){
                          setState(() {
                            if (i<questions.length-1) {
                              i += 1;
                            } else{
                              print(answers);
                              showDialog(
                                  context: context,
                                  builder: (BuildContext context) =>  _confirmSubmit(context),);
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
                        BottomNavigationBarItem(
                        icon: const Icon(Icons.save),
                        title: Text('save answer'),
                        backgroundColor: Colors.yellow,
                      ),
                        if (i == last) BottomNavigationBarItem(
                          icon: const Icon(Icons.upload),
                          title: Text('Submit Quiz'),
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
    )
      )
    );
  }
}