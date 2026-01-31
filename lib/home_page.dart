import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'main.dart';

class HomePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return HomePageState();
  }
}

class HomePageState extends State<HomePage> {
  final TextEditingController _textController = TextEditingController();

  String item = "";
  List toDo = [];

  setItem(value) {
    setState(() {
      item = value;
    });
  }

  addItem() {
    setState(() {
      toDo.add({'key': item});
    });
    _textController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("This is App bar"),
        backgroundColor: Colors.deepPurple,
      ),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            TextFormField(
              controller: _textController,
              decoration: const InputDecoration(
                hintText: 'Add new task...',
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                setItem(value);
              },
            ),

            SizedBox(height: 30),

            ElevatedButton(
              onPressed: () {
                addItem();
              },
              child: Text("Add"),
            ),

            SizedBox(height: 50),

            Expanded(
              child: ListView.builder(
                itemCount: toDo.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(toDo[index]['key'].toString() ?? ""),
                    leading: Icon(Icons.add),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
