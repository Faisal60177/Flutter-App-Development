import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(debugShowCheckedModeBanner: false, home: HomePage());
  }
}

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Hello"), backgroundColor: Colors.blue),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: Text("Alert Dialogue"),
                    content: Text("This is Alert Dialogue"),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: Text("Cancel"),
                      ),
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: Text("OK"),
                      ),
                    ],
                  ),
                );
              },
              child: Text("Alert Dialogue"),
            ),

            SizedBox(height: 40),

            ElevatedButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) => SimpleDialog(
                    title: Text("Choose"),
                    children: [
                      SimpleDialogOption(
                        onPressed: () {},
                        child: Text("Option 1"),
                      ),
                      SimpleDialogOption(
                        onPressed: () {},
                        child: Text("Option 2"),
                      ),
                    ],
                  ),
                );
              },
              child: Text("Simple Dialogue"),
            ),

            SizedBox(height: 40),

            ElevatedButton(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text("Successfully"),
                    action: SnackBarAction(label: 'Undo', onPressed: () {}),
                  ),
                );
              },
              child: Text("Snack Bar"),
            ),

            SizedBox(height: 40),

            ElevatedButton(
              onPressed: () {
                showModalBottomSheet(
                  context: context,
                  builder: (context) => Container(
                    height: 400,
                    width: double.infinity,
                    padding: EdgeInsets.all(20),
                    child: Column(
                      children: [Text("Hello this is bottom sheet")],
                    ),
                  ),
                );
              },
              child: Text("Bottom Dialogue"),
            ),
          ],
        ),
      ),
    );
  }
}
