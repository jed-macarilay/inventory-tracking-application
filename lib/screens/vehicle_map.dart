// ignore_for_file: unused_local_variable

import 'dart:async';
import 'package:denlee_app/controllers/delivery_controller.dart';
import 'package:denlee_app/models/delivery.dart';
import 'package:denlee_app/screens/dashboard.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:location/location.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/api_response.dart';
import 'dashboard.dart';
import 'package:denlee_app/.env.dart';

class Map extends StatefulWidget {
  final int? deliveryId;

  Map({this.deliveryId});

  @override
  _MapState createState() => _MapState();
}

class _MapState extends State<Map> {
  final Completer<GoogleMapController> _controller = Completer();

  int currentIndex = 0;

  DeliveryModel? _deliveryModel;
  double _origin_latitude = 0;
  double _origin_longtitude = 0;
  double _destination_latitude = 0;
  double _destination_longtitude = 0;

  List<LatLng> polylineCoordinates = [];
  LocationData? currentLocation;

  Future<void> _fetchDelivery() async {
    int id = await getDeliveryId();
    ApiResponse response = await getDelivery(id);

    if(response.error == null) {
      setState(() {
        _deliveryModel = response.data as DeliveryModel;
        _origin_latitude = double.parse('${_deliveryModel?.origin_latitude}');
        _origin_longtitude = double.parse('${_deliveryModel?.origin_longtitude}');
        _destination_latitude = double.parse('${_deliveryModel?.destination_latitude}');
        _destination_longtitude = double.parse('${_deliveryModel?.destination_longtitude}');
      });
    } else {
      setState(() {});
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('${response.error}'),
      ));
    }
  }

  void getCurrentLocation() async {
    Location location = Location();

    location.getLocation()
      .then((location) => {
        currentLocation = location
      });

    GoogleMapController googleMapController = await _controller.future;

    location.onLocationChanged.listen((newLocation) {
      currentLocation = newLocation;

      googleMapController.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
        target: LatLng(
          newLocation.latitude!,
          newLocation.longitude!,
        ),
        zoom: 13.5,
      )));
      setState(() {});
     });
  }

  void getPolyPoints() async {
    PolylinePoints polylinePoints = PolylinePoints();
    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(googleAPIKey, PointLatLng(_origin_latitude!, _origin_longtitude!), PointLatLng(_destination_latitude!, _destination_longtitude!),);

    if(result.points.isNotEmpty) {
      result.points.forEach((PointLatLng point) => polylineCoordinates.add(LatLng(point.latitude, point.longitude)));
      print(polylineCoordinates);
      setState(() {});
    }
  }

  @override
  void initState() {
    _fetchDelivery();
    getPolyPoints();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Vehicle Location'),
        leading: new IconButton(
          icon: new Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => {
            Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context)=>Dashboard()), (route) => false)
          },
        ),
      ),
      body: 
        // currentLocation == null ? const Center(child: Text('Loading'),) : 
        GoogleMap(
        myLocationButtonEnabled: false,
        initialCameraPosition: CameraPosition(
          target: LatLng(
            14.6773, 
            121.0304,
          ),
          zoom: 13.5,
        ),
        markers: {
          Marker(
            markerId: const MarkerId('currentLocation'),
            position: LatLng(
              14.6773, 
              121.0304,
            ),
          ),
          Marker(
            markerId: MarkerId('origin'),
            position: LatLng(
              _origin_latitude!,
              _origin_longtitude!
            ),
          ),
          Marker(
            markerId: MarkerId('destination'),
            position: LatLng(
              _destination_latitude!,
              _destination_longtitude!,
            ),
          ),
        },
        polylines: {
          Polyline(
            polylineId: PolylineId('route'),
            points: polylineCoordinates,
            color: Colors.blueAccent,
            width: 6,
          ),
        },
        onMapCreated: (mapController) {
          _controller.complete(mapController);
        },
      ),
      bottomNavigationBar: BottomAppBar(
        clipBehavior: Clip.antiAlias,
        child: BottomNavigationBar(
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.center_focus_strong),
              label: 'Re-center',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.airport_shuttle),
              label: 'Set as Delivered',
            ),
          ],
          onTap: (v) {
            if (v == 1) {
              // _controller.animateCamera(CameraUpdate.newCameraPosition(_initialCameraPosition));
            } else if (v == 2) {
              
            } else {
              Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context)=>Dashboard()), (route) => false);
            }
          },
        ),
      ),
    );
  }
}