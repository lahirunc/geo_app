import 'package:flutter/material.dart';
import 'package:flutter_map/plugin_api.dart';
import "package:latlong2/latlong.dart" as lat_lng2;
import 'package:location/location.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Location location = Location();

    bool _serviceEnabled;
    PermissionStatus _permissionGranted;
    LocationData _locationData;
    
    locationServicePermission() async {
      _serviceEnabled = await location.serviceEnabled();
      if (!_serviceEnabled) {
        _serviceEnabled = await location.requestService();
        if (!_serviceEnabled) {
          return;
        }
      }

      _permissionGranted = await location.hasPermission();
      if (_permissionGranted == PermissionStatus.denied) {
        _permissionGranted = await location.requestPermission();
        if (_permissionGranted != PermissionStatus.granted) {
          return;
        }
      }

      _locationData = await location.getLocation();
    }

    locationServicePermission();

    return Scaffold(
      body: FlutterMap(
        options: MapOptions(
          center: lat_lng2.LatLng(51.5, -0.09),
          zoom: 13.0,
        ),
        layers: [
          TileLayerOptions(
            urlTemplate:
                "https://api.mapbox.com/styles/v1/lahirunc/ckvj09zji1qes15qlquo4e8po/tiles/256/{z}/{x}/{y}@2x?access_token=pk.eyJ1IjoibGFoaXJ1bmMiLCJhIjoiY2t2aWhwa2M2MmM0aDJucWl6ZGFnMThxdSJ9.bPjWd5YL1vxMxAOddhIJPg",
            additionalOptions: {
              'accessToken':
                  'pk.eyJ1IjoibGFoaXJ1bmMiLCJhIjoiY2t2aWhwa2M2MmM0aDJucWl6ZGFnMThxdSJ9.bPjWd5YL1vxMxAOddhIJPg',
              'id': 'mapbox.mapbox-streets-v8',
            },
          ),
          MarkerLayerOptions(
            markers: [
              Marker(
                width: 80.0,
                height: 80.0,
                point: lat_lng2.LatLng(51.5, -0.09),
                builder: (ctx) => Container(
                  child: FlutterLogo(),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
