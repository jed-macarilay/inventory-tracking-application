import 'dart:convert';

import 'package:denlee_app/const.dart';
import 'package:denlee_app/controllers/delivery_controller.dart';
import 'package:denlee_app/controllers/user_controller.dart';
import 'package:denlee_app/models/api_response.dart';
import 'package:flutter/material.dart';
import '../models/delivery.dart';
import '../models/user.dart';
import 'login.dart';
import 'vehicle_map.dart';
import 'package:http/http.dart' as http;

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});
  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  
  List<dynamic> _deliveries = [];
  User? user;


  Future<void> retriveDeliveries() async {
    ApiResponse response = await getDeliveries();

    if(response.error == null){
      setState(() {
        _deliveries = response.data as List<dynamic>;
      });
    }
    else if (response.error == unauthorized){
      logout().then((value) => {
        Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context)=>Login()), (route) => false)
      });
    }
    else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('${response.error}'),
      ));
    }
  }

  @override
  void initState() {
    retriveDeliveries();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Dashboard'),
        actions: [
          IconButton(
            onPressed: (){
              logout().then((value) => {
                Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context)=>Login()), (route) => false)
              });

              // Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context)=>Login()), (route) => false);
            },
            icon: Icon(Icons.exit_to_app),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.all(18.0),
              child: Text('Welcome to Denlee App',
                style: TextStyle(
                  color: Colors.lightBlue,
                  fontSize: 28.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(18.0),
              child: Text('Delivery List Today:',
                style: TextStyle(
                  color: Colors.lightBlue,
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            ListView.builder(
              shrinkWrap: true,
              physics: ClampingScrollPhysics(),
              itemCount: _deliveries.length,
              itemBuilder: (BuildContext context, int index) {
                DeliveryModel deliveryModel = _deliveries[index];
                return Card(
                  elevation: 8.0,
                  margin: new EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
                  child: Container(
                    decoration: BoxDecoration(color: Colors.lightBlue),
                    child: ListTile(
                      contentPadding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                      leading: Container(
                        padding: EdgeInsets.only(right: 12.0),
                        decoration: new BoxDecoration(
                            border: new Border(
                                right: new BorderSide(width: 1.0, color: Colors.white24))),
                        child: Icon(Icons.assistant_direction_outlined, color: Colors.white),
                      ),
                      title: Text(
                        "Delivery ID ${deliveryModel.id}",
                        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                      subtitle: Row(
                        children: <Widget>[
                          Text("Status ${deliveryModel.status}",
                          style: TextStyle(
                            color: Colors.white, 
                            fontSize: 14.0
                          )),
                        ],
                      ),
                      trailing:
                          Icon(Icons.keyboard_arrow_right, color: Colors.white, size: 30.0)),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}