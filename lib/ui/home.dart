import 'package:flutter/material.dart';
import '../model/todo.dart';

class TodoScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return TodoScreenState();
  }
}

class TodoScreenState extends State {
  TodoProvider todo = TodoProvider();
  int _index = 0;

  @override
  Widget build(BuildContext context) {
    final List btnList = <Widget>[
      IconButton(
        icon: Icon(Icons.add),
        onPressed: () async {
          Navigator.pushNamed(context, '/add');
        },
      ),
      IconButton(
        icon: Icon(Icons.delete),
        onPressed: () async {
          setState(() {
            todo.deleteDone();
          });
        },
      )
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text("Todo"),
        actions: <Widget>[btnList[_index]],
      ),
      body: FutureBuilder<List<Todo>>(
        future: _index == 0
            ? TodoProvider.db.getNotDone()
            : TodoProvider.db.getDone(),
        builder: (BuildContext context, AsyncSnapshot<List<Todo>> snapshot) {
          if (snapshot.data.length > 0) {
            return ListView.builder(
              itemCount: snapshot.data.length,
              itemBuilder: (BuildContext context, int index) {
                Todo item = snapshot.data[index];
                return CheckboxListTile(
                  title: Text(item.title),
                  value: item.done,
                  onChanged: (bool value) {
                    TodoProvider.db.swapper(item);
                    setState(() {});
                  },
                );
              },
            );
          } else {
            return Center(
              child: Text('No data found..'),
            );
          }
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _index,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.list), title: Text("Task")),
          BottomNavigationBarItem(
              icon: Icon(Icons.done_all), title: Text("Completed")),
        ],
        onTap: (int index) {
          setState(() {
            _index = index;
          });
        },
      ),
    );
  }
}
