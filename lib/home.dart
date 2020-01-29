import 'package:flutter/material.dart';
import 'login.dart';

class homepage extends StatefulWidget {
  final String name;
  homepage(this.name);
  @override
  _homepageState createState() => _homepageState(name);
}

class _homepageState extends State<homepage> {
  String name;
  _homepageState(this.name);
  void logout(){
    Navigator.push(context, MaterialPageRoute(builder: (context)=>login()));
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
            FocusScopeNode currentFocus = FocusScope.of(context);
            if (!currentFocus.hasPrimaryFocus)
            {
              currentFocus.unfocus();
            }
      },
    child: MaterialApp(
       debugShowCheckedModeBanner: false,
    home: WillPopScope(
      child: Scaffold(
        appBar: AppBar(
        title: Text('Hello, '+(' $name!').toUpperCase()),
        actions: <Widget>[
          new FlatButton(onPressed: logout, child: Text('Logout'))
        ]
      )
      ),
      onWillPop: () => showDialog<bool>(
      context: context,
      builder: (c) => AlertDialog(
        title: Text('Warning'),
        content: Text('Do you really want to logout?'),
        actions: [
          FlatButton(
            child: Text('Yes'),
            onPressed: () => Navigator.pop(c, true),
          ),
          FlatButton(
            child: Text('No'),
            onPressed: () => Navigator.pop(c, false),
          ),
        ],
      ),
    ),
    )
    )
    );
  }
}
