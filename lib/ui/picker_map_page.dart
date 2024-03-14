import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart' as geo;
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:provider/provider.dart';
import 'package:story_app/data/provider/picture_provider.dart';
import 'package:story_app/route/router.dart';
import 'package:story_app/utils/utils.dart';
import 'package:story_app/utils/widgets.dart';

class PickerMapPage extends StatefulWidget {
  const PickerMapPage({super.key});

  @override
  State<PickerMapPage> createState() => _PickerMapPageState();
}

class _PickerMapPageState extends State<PickerMapPage> {
  final indonesia = const LatLng(-4.8621853319304895, 117.3782450787306);
  late GoogleMapController mapController;
  late final Set<Marker> markers = {};
  LatLng? latLon;
  geo.Placemark? placemark;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Stack(
          children: [
            SafeArea(
              child: GoogleMap(
                initialCameraPosition: CameraPosition(
                  target: indonesia,
                  zoom: 4,
                ),
                markers: markers,
                myLocationEnabled: true,
                myLocationButtonEnabled: false,
                zoomControlsEnabled: false,
                rotateGesturesEnabled: false,
                onMapCreated: (controller) async {
                  setState(() {
                    mapController = controller;
                  });
                },
                onLongPress: (LatLng latLng) => onTapGoogleMap(latLng),
                onTap: (LatLng latLng) {
                  if (placemark != null) {
                    setState(() {
                      placemark = null;
                      markers.clear();
                    });
                  } else {
                    onTapGoogleMap(latLng);
                  }
                },
              ),
            ),
            Positioned(
              top: 16.0,
              left: 16.0,
              child: SafeArea(
                child: GestureDetector(
                  onTap: () => context.goNamed(Routes.upload),
                  child: backButton(),
                ),
              ),
            ),
            Positioned(
              bottom: 16.0,
              right: 16.0,
              child: FloatingActionButton(
                child: const Icon(Icons.my_location),
                onPressed: () => onMyLocationButtonPress(context),
              ),
            ),
          ],
        ),
      ),
      bottomSheet: placemark != null
          ? _showBottomSheet(context, placemark!)
          : const SizedBox(),
    );
  }

  Widget _showBottomSheet(BuildContext context, geo.Placemark placemark) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 1000),
      curve: Curves.bounceInOut,
      color: Colors.white,
      width: MediaQuery.of(context).size.width,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              placemark.name!,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            Text(
              '${placemark.subLocality}, ${placemark.locality}, ${placemark.subAdministrativeArea}, ${placemark.administrativeArea}, ${placemark.country}',
              style: Theme.of(context).textTheme.bodySmall,
            ),
            const SizedBox(height: 8,),
            Consumer<PictureProvider>(
              builder: (context, provider, state) {
                return ElevatedButton(
                  onPressed: () {
                    context.goNamed(Routes.upload);
                    provider.setLocation(placemark.subLocality, latLon);
                  },
                  style: ElevatedButton.styleFrom(
                    elevation: 0,
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white
                  ),
                  child: const Text('Gunakan lokasi ini'),
                );
              },
            )
          ],
        ),
      ),
    );
  }

  void onTapGoogleMap(LatLng latLng) async {
    final info =
        await geo.placemarkFromCoordinates(latLng.latitude, latLng.longitude);

    final place = info[0];
    final street = place.street!;
    final address =
        '${place.subLocality}, ${place.locality}, ${place.postalCode}, ${place.country}';

    setState(() {
      placemark = place;
    });

    makeMarker(latLng, street, address);

    mapController.animateCamera(
      CameraUpdate.newLatLng(latLng),
    );
  }

  void onMyLocationButtonPress(BuildContext context) async {
    final Location location = Location();
    late bool gpsEnabled;
    late PermissionStatus permissionGranted;
    late LocationData locationData;

    gpsEnabled = await location.serviceEnabled();
    if (!gpsEnabled) {
      gpsEnabled = await location.requestService();
      if (!gpsEnabled) {
        if (context.mounted) showSnackBar(context, 'Lokasi tidak aktif');
        return;
      }
    }

    permissionGranted = await location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) {
        if (context.mounted) showSnackBar(context, 'Izin lokasi tidak ada');
        return;
      }
    }

    locationData = await location.getLocation();
    final latLng = LatLng(locationData.latitude!, locationData.longitude!);

    final info =
        await geo.placemarkFromCoordinates(latLng.latitude, latLng.longitude);

    final place = info[0];
    final street = place.street!;
    final address =
        '${place.subLocality}, ${place.locality}, ${place.postalCode}, ${place.country}';

    setState(() {
      placemark = place;
    });

    makeMarker(latLng, street, address);

    mapController.animateCamera(
      CameraUpdate.newLatLngZoom(latLng, 16),
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
      latLon = latLng;
      markers.clear();
      markers.add(marker);
    });
  }
}
