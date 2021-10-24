import 'package:flutter/material.dart';
import 'package:quizapp/Question.dart';
import 'WebClient.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class SecondPage extends StatelessWidget {
  const SecondPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.deepOrange,
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


  List <String> items = ["Q1", "Q2"];

  var questions = [];
  Future<String> response = Future.delayed(const Duration(seconds: 1), () => "No Response.");
  String quizURL = "ab";
  WebClient webClient = WebClient();

  Future<String> getData(var url) async {
      var response;
      if (url == null) {
        print("Oh NO your url isn't right!!");
      } else {
        response = await http.get(url);
      }
      response = json.decode(response.body);
      return response;
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
        Center ( child: Column (
          children: <Widget> [
            Form(
                child:
                  Column(
                      children: <Widget>[
                      SizedBox(height: 50),
                        Container(
                          width: 400,
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
                                  response = getData(Uri.parse(quizURL));
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
            Container( child: Column(children: <Widget> [
              Text(quizURL),
              ListView.builder(
                shrinkWrap: true
                ,itemBuilder: (context,index){
                return Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(7.0),
                      child: Row(crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("${items[index]}",style: TextStyle(color: Colors.red,fontSize: 14,fontWeight: FontWeight.bold),),
                          Icon(Icons.highlight_remove),
                        ],),
                    ),
                    Divider(
                      height: 2,
                      color: Colors.blueGrey,
                    )
                  ],
                );
              },itemCount: items.length,)
            ]
            )
            ),
          ]
        )
        )
    );
  }
}