import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart' as geo;
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:story_app/route/router.dart';
import 'package:story_app/utils/widgets.dart';

class MapsPage extends StatefulWidget {
  const MapsPage({
    super.key,
    required this.id,
    required this.lat,
    required this.lon,
  });

  final String id;
  final String lat;
  final String lon;

  @override
  State<MapsPage> createState() => _MapsPageState();
}

class _MapsPageState extends State<MapsPage> {
  late final Set<Marker> markers = {};

  @override
  Widget build(BuildContext context) {
    final latLng = LatLng(
      double.parse(widget.lat),
      double.parse(widget.lon),
    );
    return Scaffold(
      body: Center(
        child: Stack(
          children: [
            GoogleMap(
              initialCameraPosition: CameraPosition(
                target: latLng,
                zoom: 8,
              ),
              onMapCreated: (_) {
                _getLocation(latLng);
              },
              markers: markers,
            ),
            Positioned(
              top: 16.0,
              left: 16.0,
              child: SafeArea(
                child: GestureDetector(
                  onTap: () => context.goNamed(
                    Routes.detail,
                    pathParameters: {'id': widget.id},
                  ),
                  child: backButton(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void makeMarker(LatLng latLng, String street, String address) {
    final marker = Marker(
      markerId: const MarkerId("source"),
      position: latLng,
      infoWindow: InfoWindow(
        title: street,
        snippet: address,
      ),
    );

    setState(() {
      markers.clear();
      markers.add(marker);
    });
  }

  Future<void> _getLocation(LatLng latLng) async {
    final info =
        await geo.placemarkFromCoordinates(latLng.latitude, latLng.longitude);
    final place = info[0];
    final street = place.street ?? '';
    final address =
        '${place.subLocality}, ${place.locality}, ${place.postalCode}, ${place.country}';
    makeMarker(latLng, street, address);
  }
}
