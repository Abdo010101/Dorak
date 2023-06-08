import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:sizer/sizer.dart';

class ButtonMap extends StatelessWidget {
  ButtonMap({
    Key? key,
    required this.position,
  }) : super(key: key);

  final LatLng position;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 25.h,
      child: GoogleMap(
        markers: {
          Marker(
            markerId: const MarkerId('1'),
            position: position,
          )
        },
        mapType: MapType.normal,
        scrollGesturesEnabled: false,
        myLocationButtonEnabled: false,
        zoomControlsEnabled: false,
        zoomGesturesEnabled: false,
        initialCameraPosition: CameraPosition(
          target: position,
          zoom: 16,
        ),
        onMapCreated: onCreated,
      ),
    );
  }

  Completer<GoogleMapController> mapCompleter = Completer();
  void onCreated(GoogleMapController controller) {
    if (!mapCompleter.isCompleted) {
      mapCompleter.complete(controller);
    }
  }
}
