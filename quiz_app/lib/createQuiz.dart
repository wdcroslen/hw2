import 'package:flutter/material.dart';
import 'package:quizapp/Question.dart';
import 'package:quizapp/takeQuiz.dart';
import 'WebClient.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

WebClient webClient = WebClient();
List<dynamic> questions = [];

class SecondPage extends StatelessWidget {
  const SecondPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.orange,
      ),
      home: QuizPage(title: 'Quizzes'),
    );
  }
}

class QuizPage extends StatefulWidget {
  QuizPage({Key? key, required this.title}) : super(key: key);
  final String title;
  @override
  _QuizPageState createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {
  final GlobalKey<FormFieldState<String>> _quizNumber = GlobalKey();

  _notEmpty(String value) => value != null && value.isNotEmpty;

  get _values =>
      ({
        'quiz': _quizNumber.currentState?.value,
      });

  setItems() async{
    var response = await webClient.getResponse(Uri.parse(quizURL));
    items = [];
    List<dynamic> list = await webClient.generateQuiz(response);
    questions = list;
    for (int i =0; i<list.length; i++){
      print(list[i].getStem().toString());
      items.add(list[i].getStem().toString());
    }

  }

  List<dynamic> items = [];
  Future<String> response = Future.delayed(const Duration(seconds: 1), () => "No Response.");
  String quizURL = "ab";

  Future<List> getQuestions(var response) async {
    return await webClient.generateQuiz(jsonDecode(response.body));
  }

  Widget _enterNumberDialog(BuildContext context) {
    return new AlertDialog(
      title: const Text('Please Enter A Number'),
      actions: <Widget>[
        new ElevatedButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Center(child: const Text('Close')),
        ),
      ],
    );
  }

  Widget _enterValidNumberDialog(BuildContext context) {
    return new AlertDialog(
      title: const Text('Please Enter A Number [1-10]'),
      actions: <Widget>[
        new ElevatedButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Center(child: const Text('Close')),
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
    body:
        SingleChildScrollView ( child: Column (
          children: <Widget> [
            Form(
                child:
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                      SizedBox(height: 50),
                        Container(
                          width: 300,
                          child:
                          TextFormField(
                            key: _quizNumber,
                            decoration:
                            InputDecoration(
                              icon: Icon(Icons.send),
                              hintText: 'Enter a Quiz number! [1-10]',
                              border: OutlineInputBorder(),
                              labelText: 'Quiz Number'
                              ),
                            validator: (value) =>
                            !_notEmpty(value.toString()) ? 'Quiz is required' : null,
                            )
                        ),
                      SizedBox(height: 10),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            primary: Colors.orange,
                          ),
                          child: Text('Submit'),
                          onPressed: () {
                            if (int.tryParse(_values['quiz']) !=null ) {
                              if (int.parse(_values['quiz'])>10 || int.parse(_values['quiz'])<1) {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) => _enterValidNumberDialog(context),
                                );
                              } else {
                                setState(() {
                                  quizURL = webClient.getQuiz(
                                      int.parse(_values['quiz']),
                                      "http://cheon.atwebpages.com/quiz/");
                                  setItems();
                                });

                              }
                            } else {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) => _enterNumberDialog(context),
                              );
                            }
                          },
                        )
                    ]
                  ),
            ),
            SizedBox(height: 25),
            Column(children: <Widget> [
              if (items.length > 0) Center(child: Text("Quiz Summary",style: TextStyle(color: Colors.blue,fontSize: 24,fontWeight: FontWeight.bold),)),
              SizedBox(height: 25),
              ListView.builder(
                shrinkWrap: true
                ,itemBuilder: (context,index){
                return Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0,0,0,0),
                      child:
                      Container(width: 250,
                      child: Row(crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Q${index+1}",style: TextStyle(color: Colors.orange,fontSize: 14,fontWeight: FontWeight.bold),),
                          Container(width: 200,
                            height: 27, child:
                          Text("${items[index]}",style: TextStyle(color: Colors.black,fontSize: 12,fontWeight: FontWeight.bold),)),])
                      )),
                    Divider(
                      height: 2,
                      color: Colors.blueGrey,
                    )
                  ],
                );
              },itemCount: items.length,),
              SizedBox(height:25),
              if (items.length > 0) ElevatedButton(
                style: ElevatedButton.styleFrom(
                  primary: Colors.blue,
                ),
                child: Text('Start Quiz!'),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => InQuizPage()),);
                },
              )
            ]
            ),
          ]
        )
        )
    );
  }
}