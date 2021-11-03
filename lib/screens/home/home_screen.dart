import 'package:flutter/material.dart';
import 'package:flutter_map/plugin_api.dart';
import 'package:flutter_map_location_marker/flutter_map_location_marker.dart';
import 'package:geo_app/config.dart';
import 'package:geo_app/widgets/rounded_icon_button.dart';
import 'package:geo_app/widgets/rounded_icon_textformfield.dart';

import "package:latlong2/latlong.dart" as lat_lng2;
import 'package:location/location.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // variables

  // initializing the plugin and listening to the changes in location
  Location location = Location();

  // to update the current location. Destination latlong values
  // has been given as inital values.
  double? latitude = -37.818488, longitude = 144.96592;

  // creating a list of LatLang for creating the route
  var wayPoints = <lat_lng2.LatLng>[];

  // used to check if the service is enabled or disabled.
  bool? _serviceEnabled;
  PermissionStatus? _permissionGranted;
  LocationData? _locationData;

  final TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    // init Configs
    Config().init(context);

    // requesting permission and current location
    locationServicePermission();

    // adding way points
    wayPoints.add(lat_lng2.LatLng(latitude!, longitude!));
    wayPoints.add(lat_lng2.LatLng(-37.818488, 144.965928));

    return Scaffold(
      body: Stack(
        children: [
          FlutterMap(
            options: MapOptions(
              center: lat_lng2.LatLng(latitude!, longitude!),
              zoom: 11.0,
              plugins: [
                const LocationMarkerPlugin(), // Plugin to get the current location
              ],
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
              // way point creator
              PolylineLayerOptions(
                polylines: [
                  Polyline(
                    points: wayPoints,
                    color: kBlue,
                    strokeWidth: 5.0,
                  ),
                ],
              ),
              // marker generator
              MarkerLayerOptions(
                markers: [
                  // destination marker
                  // this will be fixed and points can be assigned using a variable
                  // to dynamically assign to which ever the location user prefers.
                  // At the moment points given is static
                  Marker(
                    width: Config.screenWidth! * 0.15,
                    height: Config.screenHeight! * 0.15,
                    point: lat_lng2.LatLng(-37.818488, 144.965928),
                    builder: (ctx) => Padding(
                      padding:
                          EdgeInsets.only(bottom: Config.screenHeight! * .03),
                      child: const Icon(
                        Icons.location_on,
                        color: kRed,
                      ),
                    ),
                  ),

                  // current location marker
                  // The point values will be constantly changing hence moving
                  // the marker when traveling
                  Marker(
                    width: Config.screenWidth! * 0.15,
                    height: Config.screenHeight! * 0.15,
                    point: lat_lng2.LatLng(latitude!, longitude!),
                    builder: (ctx) => Transform.rotate(
                      angle: -20, // This value should be mapped with gryo
                      child: Icon(
                        Icons.navigation,
                        color: latitude != null ? kOrange : Colors.transparent,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),

          // search bar
          Positioned(
            top: Config.screenHeight! * 0.09,
            left: Config.screenWidth! * 0.05,
            child: IconTextFormField(
              controller: _searchController,
              hintText: 'Search',
              prefixIcon: Icon(
                Icons.search,
                color: kGrey,
                size: Config.screenWidth! < 710 // checking for the screensize
                    ? Config.screenWidth! * 0.07
                    : Config.screenWidth! * 0.02,
              ),
            ),
          ),

          // location button - find the current location
          Positioned(
            bottom: Config.screenHeight! * 0.12,
            left: Config.screenWidth! * 0.05,
            child: Stack(
              children: [
                RoundedIconButton(
                  backGroundColor: Colors.white,
                  icon: const Icon(
                    Icons.layers,
                    color: kRed,
                  ),
                  // call in the location service to get the current location
                  // and if the permission is not given permission will be requested
                  onPressed: () => print('Change layers dialog here'),
                ),
              ],
            ),
          ),

          // location button - find the current location
          Positioned(
            bottom: Config.screenHeight! * 0.03,
            left: Config.screenWidth! * 0.05,
            child: Stack(
              children: [
                RoundedIconButton(
                  backGroundColor: Colors.white,
                  icon: const Icon(
                    Icons.location_on_outlined,
                    color: kRed,
                  ),
                  // call in the location service to get the current location
                  // and if the permission is not given permission will be requested
                  onPressed: () => locationServicePermission(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // checking if the location service is enabled and the application has permission
  // to track the location. If not request permission to enable. Then if enabled
  // it will read the current location else return.
  locationServicePermission() async {
    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled!) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled!) {
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
    latitude = _locationData!.latitude;
    longitude = _locationData!.longitude;

    setState(() {});
  }
}
