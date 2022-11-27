import 'dart:async';
// import 'package:denlee_app/models/directions_model.txt';
import 'package:denlee_app/screens/dashboard.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
// import '../repositories/direction_repository.txt';
import 'dashboard.dart';

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
  static const _initialCameraPosition = CameraPosition(
    target: LatLng(12.8797, 121.7740),
    zoom: 8.0,
  );

  late GoogleMapController _googleMapController;

  Marker _origin = Marker(
    markerId: const MarkerId('origin'),
    infoWindow: InfoWindow(title: 'origin'),
    icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
    // position: LatLng(14.6734, 121.0206),
    position: LatLng(12.8797, 121.7740),
  );

  Marker _destination = Marker(
    markerId: const MarkerId('origin'),
    infoWindow: InfoWindow(title: 'origin'),
    icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
    position: LatLng(14.654367, 120.983894),
  );

  // late Directions _info;

  @override
  void dispose() {
    _googleMapController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Vehicle Location'),
        actions: [
          TextButton(onPressed: () => _googleMapController.animateCamera(
            CameraUpdate.newCameraPosition(
              CameraPosition(
                target: _origin.position,
                zoom: 14.5,
                tilt: 50.0,
              ),
            ),
          ),
          child: Text('Start Point'),
          style: TextButton.styleFrom(
            foregroundColor: Colors.white,
            textStyle: TextStyle(fontWeight: FontWeight.w600),
          ),),
          TextButton(onPressed: () => _googleMapController.animateCamera(
            CameraUpdate.newCameraPosition(
              CameraPosition(
                target: _destination.position,
                zoom: 14.5,
                tilt: 50.0,
              ),
            ),
          ), 
          child: Text('End Point'),
          style: TextButton.styleFrom(
            foregroundColor: Colors.white,
            textStyle: TextStyle(fontWeight: FontWeight.w600),
          ),
          ),
        ],
        leading: new IconButton(
          icon: new Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => {
            Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context)=>Dashboard()), (route) => false)
          },
        ),
      ),
      body: Padding(
        padding: EdgeInsets.only(bottom: 250.0),
        child: Stack(
          alignment: Alignment.center,
          children: [
            GoogleMap(
              myLocationButtonEnabled: false,
              zoomControlsEnabled: false,
              initialCameraPosition: _initialCameraPosition,
              onMapCreated: (controller) => _googleMapController = controller,
              markers: {
                _origin,
                _destination,
              }
            ),
            // Positioned(
            //   top: 20.0,
            //   child: Container(
            //     padding: const EdgeInsets.symmetric(
            //       vertical: 6.0,
            //       horizontal: 12.0,
            //     ),
            //     decoration: BoxDecoration(
            //       color: Colors.yellowAccent,
            //       borderRadius: BorderRadius.circular(20.0),
            //       boxShadow: const [
            //         BoxShadow(
            //           color: Colors.black26,
            //           offset: Offset(0, 2),
            //           blurRadius: 6.0,
            //         )
            //       ],
            //     ),
            //     child: Text(
            //       '100m, 100mins',
            //       style: const TextStyle(
            //         fontSize: 18.0,
            //         fontWeight: FontWeight.w600,
            //       ),
            //     ),
            //   ),
            // ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.white,
        onPressed: () => _googleMapController.animateCamera(
          CameraUpdate.newCameraPosition(_initialCameraPosition)
        ),
        child: const Icon(Icons.center_focus_strong),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        child: BottomNavigationBar(
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.bookmark),
              label: 'Delivered',
            ),
          ],
        ),
      ),
    );
  }
}