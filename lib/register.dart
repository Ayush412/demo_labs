import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'home.dart';
import 'dart:async';
import 'dart:convert';
import 'package:flutter/services.dart';

class register extends StatefulWidget {
  @override
  _registerState createState() => _registerState();
}

class _registerState extends State<register> {

  bool visible = false;
  bool isFilled1 = false;
  bool isFilled2 = false;
  bool isFilled3 = false;
  final nameController = TextEditingController();
  final passwordController1 = TextEditingController();
  final passwordController2 = TextEditingController();
  FocusNode node1 = FocusNode();
  FocusNode node2 = FocusNode();
  FocusNode node3 = FocusNode();
  void handle1(String text){
    setState(() {
      isFilled1 = false;
    });
  }
  void handle2(String text){
    setState(() {
      isFilled1 = false;
    });
  }
  void handle3(String text){
    setState(() {
      isFilled1 = false;
    });
  }
  bool validatename(){
    if (nameController.text.contains(' '))
    {
      setState(() {
      isFilled1 = false;
    });
          return true;
    }
    else
    {
      setState(() {
      isFilled1 = true;
    });
    return false;
    }
  }
  bool validatePass(){
    if (passwordController1.text.isEmpty || passwordController2.text.isEmpty)
    return false;
    else if(passwordController1.text!=passwordController2.text && (node2.hasFocus==false || node3.hasFocus==false))
    {
      setState(() {
      isFilled2 = false;
      isFilled3 = false;
    });
          return true;
    }
    else
    {
      setState(() {
      isFilled2 = true;
      isFilled3 = true;
    });
    return false;
    }
  }
Future addUser() async{
    node1.unfocus();
    node2.unfocus();
    node3.unfocus();
    SystemChannels.textInput.invokeMethod('TextInput.hide');
    String name = nameController.text;
    String password = passwordController1.text;
    setState((){
      visible=true;
      isFilled1=false;
      isFilled2=false;
      isFilled3=false;
    });
    var url = 'https://allodial-automobile.000webhostapp.com/existingUser.php';
    Map data = {'Name':name};
    print (json.encode(data));
    var response = await http.post(url, body: json.encode(data));
    var message1 = jsonDecode(response.body);
    print(message1);
    if(message1[0]==1) {
      var url = 'https://allodial-automobile.000webhostapp.com/register.php';
      Map data = {'Name': name, 'Password': password};
      print (json.encode(data));
      var response = await http.post(url, body: json.encode(data));
      var message2= jsonDecode(response.body);
      if(message2[0]==1)
      {
        Navigator.push(context, MaterialPageRoute(builder: (context)=>homepage(name)));
      }
    }
      else{
        setState((){
        visible=false;
      });
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: new Text("Username already exists. Try another one."),
              actions: <Widget>[
                FlatButton(
                  child: new Text("OK"),
                  onPressed: () {
                    Navigator.of(context).pop();
                    FocusScope.of(context).requestFocus(node1);
                    setState(() {
                      isFilled1=false;
                    });
                  },
                ),
              ],
            );
          }
        );
        return false;
      }
      setState((){
      visible=false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
            node1.unfocus();
            node2.unfocus();
            node3.unfocus();
            FocusScopeNode currentFocus = FocusScope.of(context);
            if (!currentFocus.hasPrimaryFocus)
            {
              currentFocus.unfocus();
            }
      },
    child: MaterialApp(
       debugShowCheckedModeBanner: false,
        home: Scaffold(
            appBar: AppBar(
              title: Text('New User'),
              centerTitle: true,
              leading: new IconButton(icon: Icon(Icons.arrow_back), onPressed: (){Navigator.of(context).pop();})
            ),
            body: Center(
                child: Column(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Text('Enter Credentials'),
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
                          decoration: InputDecoration(hintText: 'Username', errorText: validatename() ? 'No blank spaces allowed' : null),
                        )
                    ),
                    Container(
                        width: 280,
                        padding: EdgeInsets.all(10.0),
                        child: TextField(
                          focusNode: node2,
                          controller: passwordController1,
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
                    Container(
                        width: 280,
                        padding: EdgeInsets.all(10.0),
                        child: TextField(
                          focusNode: node3,
                          controller: passwordController2,
                          autocorrect: true,
                          obscureText: true,
                          onChanged: (String text){
                            setState((){
                              isFilled3 = text.length>0;
                            });
                          },
                          onSubmitted: handle3,
                          decoration: InputDecoration(hintText: 'Re-type Password', errorText: validatePass() ? "Passwords don't match" : null),
                        )
                    ),
                    RaisedButton(
                      onPressed: (isFilled1 && isFilled2 && isFilled3) ? () => addUser() : null,
                      color: Colors.green,
                      textColor: Colors.white,
                      padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                      child: Text('Create'),
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
        )
    )
    );
  }
}