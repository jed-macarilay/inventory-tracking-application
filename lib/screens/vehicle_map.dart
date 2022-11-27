import 'dart:async';
import 'package:denlee_app/screens/dashboard.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
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
  int currentIndex = 0;

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
      body: GoogleMap(
        myLocationButtonEnabled: false,
        zoomControlsEnabled: false,
        initialCameraPosition: _initialCameraPosition,
        onMapCreated: (controller) => _googleMapController = controller,
        markers: {
          _origin,
          _destination,
        }
      ),
      // floatingActionButton: FloatingActionButton(
      //   backgroundColor: Theme.of(context).primaryColor,
      //   foregroundColor: Colors.white,
      //   onPressed: () => _googleMapController.animateCamera(
      //     CameraUpdate.newCameraPosition(_initialCameraPosition)
      //   ),
      //   child: const Icon(Icons.center_focus_strong),
      // ),
      // floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
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
              _googleMapController.animateCamera(CameraUpdate.newCameraPosition(_initialCameraPosition));
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