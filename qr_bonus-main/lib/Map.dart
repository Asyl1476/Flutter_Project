import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class GoogleMapsMarkerExample extends StatelessWidget {
  final List<Marker> markers;

  const GoogleMapsMarkerExample({Key? key, required this.markers}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Completer<GoogleMapController> _controller = Completer();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Google Maps Markers'),
      ),
      body: GoogleMap(
        mapType: MapType.hybrid,
        markers: Set<Marker>.from(markers),
        onMapCreated: (GoogleMapController controller) {
          _controller.complete(controller);
        },
        initialCameraPosition: CameraPosition(
          target: LatLng(55.7558, 37.6173), // Замените на начальные координаты
          zoom: 14,
        ),
      ),
    );
  }
}
