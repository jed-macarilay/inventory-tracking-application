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
      body: new Center(child: GestureDetector(  
          onTap: () {  
            Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context)=>Map()), (route) => false); 
          },  
          child: Container(  
            height: 60.0,  
            width: 120.0,  
            padding: EdgeInsets.all(10.0),  
            decoration: BoxDecoration(  
              color: Colors.blueGrey,  
              borderRadius: BorderRadius.circular(15.0),  
            ),  
            child: Center(child: Text('Click Me')),  
          )  
      )), 
    );
  }
}