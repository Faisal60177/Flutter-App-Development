import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: HomePage());
  }
}

class HomePage extends StatelessWidget {
  void showSnack(BuildContext context, String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Flutter Batch 04"),
        elevation: 15,
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            onPressed: () {},
            icon: Icon(Icons.notification_add_outlined),
          ),
          IconButton(onPressed: () {}, icon: Icon(Icons.person)),
          IconButton(onPressed: () {}, icon: Icon(Icons.search)),
        ],
      ),
      body: Center(
        child: Column(
          children: [
            ElevatedButton(
              onPressed: () {
                showSnack(context, "This is Elevated Button");
              },
              child: Text("Click Me"),
            ),

            SizedBox(height: 20),

            OutlinedButton(
              onPressed: () {
                showSnack(context, "This is Outline Button");
              },
              child: Text("Click Me"),
            ),

            SizedBox(height: 20),

            TextButton(
              onPressed: () {
                showSnack(context, "This is Text Button");
              },
              child: Text("Click Me"),
            ),

            SizedBox(height: 20),

            IconButton(onPressed: () {}, icon: Icon(Icons.access_alarm)),

            SizedBox(height: 20),

            InkWell(
              onDoubleTap: () {
                showSnack(context, "Double Tap");
              },
              onLongPress: () {
                showSnack(context, "Long Press");
              },
              child: IconButton(onPressed: () {}, icon: Icon(Icons.settings)),
            ),

            SizedBox(height: 20),

            TextFormField(
              decoration: InputDecoration(labelText: "Enter Your Name"),
              onFieldSubmitted: (value) {
                showSnack(context, value);
              },
            ),

            SizedBox(height: 20),

            DropdownButton(
              hint: Text("Choose City Name"),
              items: [
                DropdownMenuItem(value: "Dhaka", child: Text("Dhaka")),
                DropdownMenuItem(value: "Rajshahi", child: Text("Rajshahi")),
                DropdownMenuItem(value: "Khulna", child: Text("Khulna")),
              ],
              onChanged: (value) {
                showSnack(context, value.toString());
              },
            ),

            SizedBox(height: 20),

            CheckboxListTile(
              title: Text("Accept Terms & Condition"),
              value: true,
              onChanged: (value) {
                if (value == true) {
                  showSnack(context, "Yes");
                } else {
                  showSnack(context, "No");
                }
              },
            ),

            SizedBox(height: 20),

            SwitchListTile(
              title: Text("Accept Terms & Condition"),
              value: true,
              onChanged: (value) {
                if (value == true) {
                  showSnack(context, "Yes");
                } else {
                  showSnack(context, "No");
                }
              },
            ),

            SizedBox(height: 20),

            Slider(
              value: 10,
              min: -100,
              max: 100,
              divisions: 10,
              onChanged: (value) {
                showSnack(context, value.toString());
              },
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          showSnack(context, "I am Floating");
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
    );
  }
}
