import 'dart:async';
import 'package:denlee_app/screens/dashboard.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:location/location.dart';
import 'dashboard.dart';
import 'package:denlee_app/.env.dart';

class Map extends StatefulWidget {
  const Map({super.key});

  @override
  _MapState createState() => _MapState();
}

class _MapState extends State<Map> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: MapScreen(),
    );
  }
}

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {

  final Completer<GoogleMapController> _controller = Completer();

  int currentIndex = 0;

  static const LatLng sourceLocation = LatLng(14.6773, 121.0195);
  static const LatLng destination = LatLng(14.5679, 121.0659);
  List<LatLng> polylineCoordinates = [];
  LocationData? currentLocation;

  void getCurrentLocation() async {
    Location location = Location();

    location.getLocation()
      .then((location) => {
        currentLocation = location
      });

    GoogleMapController googleMapController = await _controller.future;

    location.onLocationChanged.listen((newLocation) {
      currentLocation = newLocation;
      // googleMapController.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(zoom: 13.5, target: LatLng(newLocation.latitude!, newLocation.longitude!))));
      setState(() {});
     });
  }

  void getPolyPoints() async {
    PolylinePoints polylinePoints = PolylinePoints();
    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(googleAPIKey, PointLatLng(sourceLocation.latitude, sourceLocation.longitude,), PointLatLng(destination.latitude, destination.longitude),);

    if(result.points.isNotEmpty) {
      result.points.forEach((PointLatLng point) => polylineCoordinates.add(LatLng(point.latitude, point.longitude)));
      setState(() {});
    }
  }

  @override
  void initState() {
    getCurrentLocation();
    getPolyPoints();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Vehicle Location'),
        // actions: [
        //   TextButton(onPressed: () => _controller.animateCamera(
        //     CameraUpdate.newCameraPosition(
        //       CameraPosition(
        //         target: sourceLocation,
        //         zoom: 14.5,
        //         tilt: 50.0,
        //       ),
        //     ),
        //   ),
        //   child: Text('Start Point'),
        //   style: TextButton.styleFrom(
        //     foregroundColor: Colors.white,
        //     textStyle: TextStyle(fontWeight: FontWeight.w600),
        //   ),),
        //   TextButton(onPressed: () => _googleMapController.animateCamera(
        //     CameraUpdate.newCameraPosition(
        //       CameraPosition(
        //         target: destination,
        //         zoom: 14.5,
        //         tilt: 50.0,
        //       ),
        //     ),
        //   ), 
        //   child: Text('End Point'),
        //   style: TextButton.styleFrom(
        //     foregroundColor: Colors.white,
        //     textStyle: TextStyle(fontWeight: FontWeight.w600),
        //   ),
        //   ),
        // ],
        leading: new IconButton(
          icon: new Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => {
            Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context)=>Dashboard()), (route) => false)
          },
        ),
      ),
      body: currentLocation == null ? const Center(child: Text('Loading'),) : 
        GoogleMap(
        myLocationButtonEnabled: false,
        initialCameraPosition: CameraPosition(
          target: LatLng(currentLocation!.latitude!, currentLocation!.longitude!),
          zoom: 13,
        ),
        markers: {
          Marker(
            markerId: const MarkerId('currentLocation'),
            position: LatLng(currentLocation!.latitude!, currentLocation!.longitude!),
          ),
          const Marker(
            markerId: MarkerId('origin'),
            position: sourceLocation,
          ),
          const Marker(
            markerId: MarkerId('destination'),
            position: destination,
          ),
        },
        polylines: {
          Polyline(
            polylineId: PolylineId('route'),
            points: polylineCoordinates,
            color: Colors.red,
            width: 6,
          ),
        },
        // onMapCreated: (mapController) {
        //   _controller.complete(mapController);
        // },
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