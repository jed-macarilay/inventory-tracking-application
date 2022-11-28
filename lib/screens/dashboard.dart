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
  int userId = 0;

  Future<void> fetchDeliveries() async {
    userId = await getUserId();
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

  Future<List> fetchJSON() async {
    String token = await getToken();
    http.Response response = await http.get(Uri.parse(getDeliveryURL),
    headers: {
      'Accept': 'application/json',
      'Authorization': 'Bearer $token'
    });

    var data = jsonDecode(response.body)['deliveries'];

    return data;
  }

  @override
  void initState() {
    // fetchDeliveries();
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
      body: FutureBuilder<List>(
        future: fetchJSON(),
        builder: (BuildContext context, res) {
          if (res.connectionState == ConnectionState.done) {
            if (res.hasData) {
              // Success case
              return ListView.builder(
                itemBuilder: (context, index) {
                  return ListTile(
                    leading: const Icon(Icons.assistant_direction),
                    title: Text("Delivery #: ${res.data![index]['id']}"),
                    subtitle: Text("Receiver: ${res.data![index]['receiver']} | Origin: ${res.data![index]['origin']} | Destination: ${res.data![index]['destination']} | Status: ${res.data![index]['status']} "),
                    onTap: () {
                      Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context)=>Map()), (route) => false);
                    },
                  );
                },
                itemCount: res.data!.length,
              );
            }
            // Error case
            return Text('Something went wrong');
          } else {
            // Loading data
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }
}