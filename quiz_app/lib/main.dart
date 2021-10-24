import 'package:flutter/material.dart';
import 'createQuiz.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: LoginPage(title: 'QuizApp'),
    );
  }
}

class LoginPage extends StatefulWidget {
  LoginPage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final GlobalKey<FormFieldState<String>> _usernameFormFieldKey = GlobalKey();
  final GlobalKey<FormFieldState<String>> _passwordFormFieldKey = GlobalKey();

  _notEmpty(String value) => value != null && value.isNotEmpty;

//  http://cheon.atwebpages.com/quiz/login.php?user=wdcroslen&pin=7569
  get _values =>
      ({
        'username': _usernameFormFieldKey.currentState?.value,
        'password': _passwordFormFieldKey.currentState?.value
      });

  validateUser(BuildContext ctx) async{
    print("BEFORE HELP");
    if (_values['username'] != "" && _values['password'] != "") {
      print("Middle HELP");
      var url = 'http://cheon.atwebpages.com/quiz/login.php?user=wdcroslen&pin=7569';
      var response = await http.get(Uri.parse(url),headers: {
        "Accept": "application/json",
        "Access-Control-Allow-Origin": "*"
      });
      print('after help');

      var body = jsonDecode(response.body);

      print(body);

      if (body['response'] == true) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => SecondPage()),);
      }
    }
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
        body:
        Form(
          child: Column(
            children: <Widget>[
              SizedBox(height: 50),
              Container(
                  width: 400,
                  child:
                  TextFormField(
                    key: _usernameFormFieldKey,
                    decoration:
                    InputDecoration(
                        icon: Icon(Icons.send),
                        hintText: 'Username',
                        border: OutlineInputBorder(),
                        labelText: 'Username'
                    ),
                    validator: (value) =>
                    !_notEmpty(value.toString()) ? 'Username is required' : null,
                  )
              ),
              SizedBox(height: 10),
              Container(
                  width: 400,
                  child:
                  TextFormField(
                    key: _passwordFormFieldKey,
                    obscureText: true,
                    decoration:
                    InputDecoration(
                      icon: Icon(Icons.send),
                      hintText: 'Password',
                      border: OutlineInputBorder(),
                      labelText: 'Password',
                    ),
                    validator: (value) =>
                    !_notEmpty(value.toString()) ? 'Password is required' : null,
                  )
              ),
              SizedBox(height: 20),

              Builder(builder: (context) {
                return
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      SizedBox(width: 40),
                      Container(
                          width: 300,
                          child:
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              primary: Colors.orange,
                            ),
                            child: Text('Log In'),
                            onPressed: () => validateUser(context),
                          )
                      ),

                    ],
                  );
              }),

            ],
          ),
        )
    );
  }
}
