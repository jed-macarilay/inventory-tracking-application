import 'package:denlee_app/controllers/user_controller.dart';
import 'package:flutter/material.dart';
import 'login.dart';
import 'vehicle_map.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  final List<String> deliveries = List<String>.generate(10000, (i) => 'Item $i');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Dashboard'),
        actions: [
          IconButton(
            onPressed: (){
              // logout().then((value) => {
              //   Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context)=>Login()), (route) => false)
              // });
              Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context)=>Login()), (route) => false);
            },
            icon: Icon(Icons.exit_to_app),
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: deliveries.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text('Delivery # $index'),
            subtitle: Row(
              children: [
                Text('Origin | '),
                Text('Destination | '),
                Text('Status'),
              ],
            ),
            trailing: Icon(Icons.directions),
            onTap: () { 
              Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context)=>Map()), (route) => false);
            },
          );
        },
      ), 
    );
  }
}