import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'home.dart';
import 'dart:async';
import 'dart:convert';
import 'register.dart';
import 'package:flutter/services.dart';
import 'dart:io';

class login extends StatefulWidget {
  @override
  _loginState createState() => _loginState();
}

class _loginState extends State<login> {

  final nameController = TextEditingController();
  final passwordController = TextEditingController();
  bool visible = false;
  bool isFilled1 = false;
  bool isFilled2 = false;
  FocusNode node1 = FocusNode();
  FocusNode node2 = FocusNode();

  void handle1(String text){
    setState(() {
      isFilled1 = false;
    });
  }
  void handle2(String text){
    setState((){
      isFilled2 = false;
    });
  }

  bool validate1(){
    if (nameController.text.contains(' '))
    return true;
    else
    return false;
  }

  Future checkLogin() async {
    SystemChannels.textInput.invokeMethod('TextInput.hide');
    setState((){
      visible=true;
    });
    node1.unfocus();
    node2.unfocus();
    String name = nameController.text;
    String password = passwordController.text;
    var url = 'https://allodial-automobile.000webhostapp.com/loginapi2.php';
    Map data = {'Name':name, 'Password': password};
    print (json.encode(data));
    var response = await http.post(url, body: json.encode(data));
    var message = jsonDecode(response.body);
    print(message);
    if(message[0]==1) {
      setState(() {
      visible = false;
    });
      Navigator.push(context, MaterialPageRoute(builder: (context)=>homepage(name)));
    }
    else
      {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: new Text("User credentials not found"),
              actions: <Widget>[
                FlatButton(
                  child: new Text("OK"),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
      }
    setState(() {
      visible = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope( //prevent back button accidental touch, has exit app option
      onWillPop: () => showDialog<bool>(
      context: context,
      builder: (c) => AlertDialog(
        title: Text('Warning'),
        content: Text('Do you really want to exit?'),
        actions: [
          FlatButton(
            child: Text('Yes'),
            onPressed: () => exit(0), //terminate app
          ),
          FlatButton(
            child: Text('No'),
            onPressed: () => Navigator.pop(c, false),
          ),
        ],
      ),
    ),
    child: MaterialApp(
       debugShowCheckedModeBanner: false,
      home: GestureDetector( //to close keyboard on tapping anywhere
        onTap: (){
            FocusScopeNode currentFocus = FocusScope.of(context);
            if (!currentFocus.hasPrimaryFocus)
            {
              currentFocus.unfocus();
            }
      },
        child: Scaffold(
          backgroundColor: Colors.white,
            appBar: AppBar(
              title: Text('Login'),
              centerTitle: true,
              toolbarOpacity: 0,
            ),
            body: Center(
                child: Column(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Text('User login'),
                    ),
                    Divider(),
                    Container(
                        width: 280,
                        padding: EdgeInsets.all(10.0),
                        child: TextField(
                          focusNode: node1,
                          controller: nameController,
                          autocorrect: true,
                          onChanged: (String text){
                            setState((){
                              isFilled1 = text.length>0;
                            });
                          },
                          onSubmitted: handle1,
                          decoration: InputDecoration(hintText: 'Username', errorText: validate1() ? 'No spaces allowed' : null),
                        )
                    ),
                    Container(
                        width: 280,
                        padding: EdgeInsets.all(10.0),
                        child: TextField(
                          focusNode: node2,
                          controller: passwordController,
                          autocorrect: true,
                          obscureText: true,
                          onChanged: (String text){
                            setState((){
                              isFilled2 = text.length>0;
                            });
                          },
                          onSubmitted: handle2,
                          decoration: InputDecoration(hintText: 'Password'),
                        )
                    ),
                    RaisedButton(
                      onPressed: (isFilled1 && isFilled2) ? () => checkLogin() : null,
                      color: Colors.green,
                      textColor: Colors.white,
                      padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                      child: Text('Login'),
                    ),
                    GestureDetector(
                      onTap: (){
                        SystemChannels.textInput.invokeMethod('TextInput.hide');
                        Navigator.push(context, MaterialPageRoute(builder: (context)=>register()));
                      },
                      child: Text('Click here to register', style: TextStyle(fontSize: 15.0, color: Colors.grey),)
                    ),
                    Visibility(
                        visible: visible,
                        child: Container(
                            margin: EdgeInsets.only(bottom: 30),
                            child: CircularProgressIndicator()
                        )
                    ),
                  ],
                )
            )
        ),
      )
    )
    );
  }
}

