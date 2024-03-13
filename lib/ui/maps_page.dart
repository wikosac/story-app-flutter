import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:story_app/route/router.dart';
import 'package:story_app/utils/widgets.dart';

class MapsPage extends StatefulWidget {
  const MapsPage({super.key, this.lat, this.lon});

  final double? lat;
  final double? lon;

  @override
  State<MapsPage> createState() => _MapsPageState();
}

class _MapsPageState extends State<MapsPage> {
  final dicodingOffice = const LatLng(-6.8957473, 107.6337669);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: GoogleMap(
            initialCameraPosition: CameraPosition(
              target: dicodingOffice,
              zoom: 10
            ),
          ),
        ),
      ),
    );
  }
}
