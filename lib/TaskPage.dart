import 'package:flutter/material.dart';
import 'action/action.dart';

class TaskPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState()=>TaskPageState();
}

class TaskPageState extends State<TaskPage>{

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Task Manager"),),
      body: Column(
        children: [
          Expanded(
              child: StreamBuilder(
                  stream:  TaskAction.fetchTasks(),
                  builder: (context,snapshot) {
                    if(snapshot.connectionState==ConnectionState.waiting){
                      return Center(child: CircularProgressIndicator());
                    }
                    if(snapshot.hasError){
                      return Center(child: Text("Error:${snapshot.error}"));
                    }
                    if(!snapshot.hasData || snapshot.data!.docs.isEmpty){
                      return Center(child: Text("No Data"));
                    }
                    final docs=snapshot.data!.docs;
                    return ListView.builder(
                        itemCount: docs.length,
                        itemBuilder: (context,index){
                          final name=docs[index]['name'];
                          return ListTile(
                            title: Text(name),
                          );
                        }
                    );
                  }
              )
          ),
        ],
      ),
    );
  }

}