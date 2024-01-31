import 'package:bionic_test/tile_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_marker_popup/flutter_map_marker_popup.dart';
import 'package:geocoding/geocoding.dart';
import 'package:latlong2/latlong.dart';
import 'package:share_plus/share_plus.dart';

class MapScreen extends StatefulWidget {
  static const String route = '/markers';

  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  Alignment selectedAlignment = Alignment.topCenter;
  bool counterRotate = false;
  PopupController popupController = PopupController();

  late final customMarkers = <Marker>[
    buildPin(const LatLng(-6.221555, 106.828488)),
  ];

  Marker buildPin(LatLng point) => Marker(
        point: point,
        child: const Icon(Icons.location_pin, size: 48, color: Colors.purple),
        width: 48,
        height: 48,
      );

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(title: const Text('Markers')),
      body: Column(
        children: [
          Flexible(
            child: FlutterMap(
              options: const MapOptions(
                initialCenter: LatLng(-6.221555, 106.828488),
                initialZoom: 10,
                interactionOptions: InteractionOptions(
                  flags: ~InteractiveFlag.doubleTapZoom,
                ),
              ),
              children: [
                openStreetMapTileLayer,
                MarkerLayer(
                  markers: const [],
                  rotate: counterRotate,
                  alignment: selectedAlignment,
                ),
                PopupMarkerLayer(
                  options: PopupMarkerLayerOptions(
                    markerCenterAnimation: const MarkerCenterAnimation(),
                    markers: customMarkers,
                    popupController: popupController,
                    popupDisplayOptions: PopupDisplayOptions(
                      builder: (context, marker) {
                        return Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.white,
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text('Latitude : ${marker.point.latitude}'),
                              Text('Longitude : ${marker.point.longitude}'),
                              ElevatedButton(
                                onPressed: () async {
                                  var placemarks =
                                      await placemarkFromCoordinates(
                                          marker.point.latitude,
                                          marker.point.longitude);
                                  var location =
                                      '${placemarks[0].thoroughfare} ${placemarks[0].locality} ${placemarks[0].subLocality} ${placemarks[0].country}';
                                  Share.share(location,
                                      subject: 'Share Location');
                                },
                                child: const Text('Share Location'),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                    markerTapBehavior: MarkerTapBehavior.togglePopup(),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
