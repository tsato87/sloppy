import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:latlong2/latlong.dart';
import 'package:flutter_map/flutter_map.dart';


class MapViewModel {
  final GlobalKey mapKey = GlobalKey<MapPageState>();

  LatLng getCurrentLatLng() {
    return const LatLng(45.521563, -122.677433);
  }
}

final mapViewModelProvider =
    Provider<MapViewModel>((ref) => MapViewModel());

class MapPage extends ConsumerStatefulWidget {
  const MapPage({Key? key}) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() {
    return MapPageState();
  }
}

class MapPageState extends ConsumerState {

  @override
  Widget build(BuildContext context) {
    MapViewModel viewModel = ref.read(mapViewModelProvider);
    return Scaffold(
      body: Stack(
        children: [
          FlutterMap(
      options: MapOptions(
      initialCenter: viewModel.getCurrentLatLng(),
      initialZoom: 5,
      cameraConstraint: CameraConstraint.contain(
        bounds: LatLngBounds(
          const LatLng(-90, -180),
          const LatLng(90, 180),
        ),
      ),
    ),
    children: [
    TileLayer(
    urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
    userAgentPackageName: 'com.example.sloppy',
    ),],
          ),
        ],
      ),
    );
  }
}