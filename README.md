# flutter_project

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.




Flutter Layout Widgets - Showcase and Best Use Cases
This project demonstrates the usage of the following Flutter layout widgets:

Expandable (via Expanded)
Flexible
Wrap
Padding
Align
Center
FittedBox
🧱 Widget Examples and Best Use Cases
1. Expanded
   Row(
   children: [
   Expanded(
   child: Container(color: Colors.red, height: 100),
   ),
   Container(width: 100, color: Colors.blue, height: 100),
   ],
   )
   Use Case: When you want a widget to take all the remaining space in a Row or Column.

2. Flexible
   Row(
   children: [
   Flexible(
   flex: 2,
   child: Container(color: Colors.green, height: 100),
   ),
   Flexible(
   flex: 1,
   child: Container(color: Colors.yellow, height: 100),
   ),
   ],
   )
   Use Case: When you want proportional space distribution with flexibility to shrink.

3. Wrap
   Container(
   color: Colors.grey[200],
   width: double.infinity,
   height: 300,
   child: Wrap(
   spacing: 12,
   runSpacing: 12,
   alignment: WrapAlignment.center,
   runAlignment: WrapAlignment.center,
   crossAxisAlignment: WrapCrossAlignment.end,
   children: [
   Container(color: Colors.red, height: 40, width: 80),
   Container(color: Colors.green, height: 60, width: 80),
   Container(color: Colors.blue, height: 30, width: 80),
   Container(color: Colors.orange, height: 50, width: 80),
   Container(color: Colors.purple, height: 70, width: 80),
   Container(color: Colors.cyan, height: 40, width: 80),
   ],
   ),
   )
   Use Case: Layout for chips/tags or any widgets that wrap to next line if not enough space.

4. Padding
   Padding(
   padding: const EdgeInsets.all(16.0),
   child: Text('Padded content'),
   )
   Use Case: To give space around your widget without affecting its alignment.

5. Align
   Align(
   alignment: Alignment.bottomRight,
   child: Text("Bottom Right"),
   )
   Use Case: To precisely position a child inside a parent using alignment values.

6. Center
   Center(
   child: Text('Centered Text'),
   )
   Use Case: Simplest way to center a widget both vertically and horizontally.

7. FittedBox
   FittedBox(
   child: Text(
   'This is a very long text',
   style: TextStyle(fontSize: 50),
   ),
   )
   Use Case: Scale the child widget to fit within its parent's constraints.

✅ Summary
Widget	Best Use Case
Expanded	Fill remaining space
Flexible	Share space proportionally with flexibility
Wrap	Multi-line flow layout
Padding	Add space around content
Align	Precisely align inside parent
Center	Quickly center a widget
FittedBox	Scale widget inside tight constraints
🚀 Run the Examples
Use each widget inside a Scaffold body and hot reload to test layout behavior.

flutter run
📁 Folder Structure
main.dart: Try one example at a time.
widgets/: Each widget example in separate files (optional modularization).
README.md: This documentation.

