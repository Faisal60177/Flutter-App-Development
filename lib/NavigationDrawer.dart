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
  MySnackBar(context, msg) {
    return ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(msg)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Text("Flutter Project"),
      ),
      body: Column(),
      drawer: Drawer(
        child: ListView(
          children: [
            DrawerHeader(
              padding: EdgeInsets.all(0),
              child: UserAccountsDrawerHeader(
                decoration: BoxDecoration(color: Colors.blue),
                accountName: Text("Arman"),
                accountEmail: Text("arman@gmail.com"),
                currentAccountPicture: CircleAvatar(
                  backgroundImage: NetworkImage(
                    "https://scontent.fcgp4-1.fna.fbcdn.net/v/t39.30808-1/350538039_3518847965059738_5681808355925629456_n.jpg?stp=dst-jpg_s200x200_tt6&_nc_cat=109&ccb=1-7&_nc_sid=1d2534&_nc_eui2=AeGtcp957iA7jrz4dTNuh3pExRMfgYweZMnFEx-BjB5kydbUp9-_seofXHEzeb70mkmhKsVlkTfggeKAVrsOqtpp&_nc_ohc=LTyUx23cjl8Q7kNvwGfQdDC&_nc_oc=Adkxw1Nj4NrWvhaLLUahYXImCJ1Xw-OmPV0wkHwDK5nWHA9hXniCWVbFV1wdG5hZbK8&_nc_zt=24&_nc_ht=scontent.fcgp4-1.fna&_nc_gid=VnoO20AZhEbBsz3YOeyZyw&oh=00_Afp-BBiZQqRNC3Pcu3As15MT73HuWwUN0MCukr-eTRncRA&oe=697F4EAD",
                  ),
                ),
              ),
            ),
            ListTile(
              leading: Icon(Icons.home),
              title: Text("Home"),
              onTap: () {
                MySnackBar(context, "This is home");
              },
            ),
            ListTile(
              leading: Icon(Icons.search),
              title: Text("search"),
              onTap: () {
                MySnackBar(context, "This is search");
              },
            ),
            ListTile(
              leading: Icon(Icons.settings),
              title: Text("settings"),
              onTap: () {
                MySnackBar(context, "This is settings");
              },
            ),
            ListTile(
              leading: Icon(Icons.alarm),
              title: Text("alarm"),
              onTap: () {
                MySnackBar(context, "This is alarm");
              },
            ),
          ],
        ),
      ),
    );
  }
}
