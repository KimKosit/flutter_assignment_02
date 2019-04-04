import 'package:flutter/material.dart';

class Add extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return AddState();
  }
}

class AddState extends State<Add> {
  final _formkey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
        appBar: AppBar(
          title: Text("New Subject"),
        ),
        body: Padding(
          padding: EdgeInsets.all(13),
          child: Form(
            key: _formkey,
            child: Column(
              children: <Widget>[
                TextFormField(
                  decoration: InputDecoration(labelText: "Subject"),
                  validator: (value) {
                    if (value.isEmpty) {
                      return "Please fill subject";
                    }
                  },
                ),
                Row(
                  children: <Widget>[
                    Expanded(
                      child: RaisedButton(
                        child: Text("Save"),
                        onPressed: () {
                          _formkey.currentState.validate();
                        },
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
        ));
  }
}
