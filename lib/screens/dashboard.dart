import 'dart:convert';

import 'package:denlee_app/const.dart';
import 'package:denlee_app/controllers/delivery_controller.dart';
import 'package:denlee_app/controllers/user_controller.dart';
import 'package:denlee_app/models/api_response.dart';
import 'package:flutter/material.dart';
import '../models/delivery.dart';
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
      body: ListView.builder(
        itemCount: _deliveries.length,
        itemBuilder: (BuildContext context, int index) {
          DeliveryModel deliveryModel = _deliveries[index];
          return Text('${deliveryModel.status}');
        },
      ),
    );
  }
}