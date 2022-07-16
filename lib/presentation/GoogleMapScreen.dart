import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_flutter_example/data/Utils/MapUtils.dart';
import 'package:google_maps_flutter_example/data/Utils/widgets.dart';
import 'package:google_maps_flutter_example/presentation/cubit/google_map_cubit.dart';
import 'package:location/location.dart';

class GoogleMapScreen extends StatefulWidget {
  const GoogleMapScreen({Key? key}) : super(key: key);

  @override
  State<GoogleMapScreen> createState() => _GoogleMapScreenState();
}

class _GoogleMapScreenState extends State<GoogleMapScreen> {
  final Completer<GoogleMapController> _controller = Completer();

  final LatLng destinationLatLng = const LatLng(30.149350, 31.738539);
  final LatLng initialLatLng = const LatLng(30.1541371,31.7397189);

  double lat = 30.1541371;
  double lng = 31.7397189;

  // custom marker
  final Set<Marker> _markers = <Marker>{};
  late BitmapDescriptor customIcon;

  _setMapPins(List<LatLng> markersLocation) {
    _markers.clear();
    setState(() {
      // for (var markerLocation in markersLocation) {
      //   _markers.add(Marker(
      //     markerId: MarkerId(markerLocation.toString()),
      //     position: markerLocation,
      //     icon: customIcon,
      //   ));
      // }
      _markers.add(Marker(
        markerId: MarkerId(destinationLatLng.toString()),
        position: destinationLatLng,
      ));
    });
  }


  // style map
  bool mapDarkMode = true;
  late String _darkMapStyle;
  late String _lightMapStyle;

  Future _loadMapStyles() async {
    _darkMapStyle = await rootBundle.loadString('assets/map_style/dark.json');
    _lightMapStyle = await rootBundle.loadString('assets/map_style/light.json');
  }

  Future _setMapStyle() async {
    final controller = await _controller.future;
    if (mapDarkMode) {
      controller.setMapStyle(_darkMapStyle);
    } else {
      controller.setMapStyle(_lightMapStyle);
    }
  }


  //Adding route to the map
  final Set<Polyline> _polyline = {};
  List<LatLng> polylineCoordinates = [];

  _addPolyLines(BuildContext context) {
    setState(() {
      lat = (initialLatLng.latitude + destinationLatLng.latitude) / 2;
      lng = (initialLatLng.longitude + destinationLatLng.longitude) / 2;
      _moveCamera(13.0);
      _setPolyLine(context);
    });
  }

  _moveCamera([double? zoom]) async {
    final CameraPosition myPosition = CameraPosition(
      target: LatLng(lat, lng),
      zoom: zoom ?? 14.4746,
    );
    final GoogleMapController controller = await _controller.future;
    controller.moveCamera(CameraUpdate.newCameraPosition(myPosition));
  }

  _setPolyLine(BuildContext context) async {

    final result = await GoogleMapCubit().getRouteCoordinates(initialLatLng, destinationLatLng);
    if(result.success) {
      final route = result.data["routes"][0]["overview_polyline"]["points"];
      setState(() {
        _polyline.add(Polyline(
            polylineId: const PolylineId("tripRoute"),
            //pass any string here
            width: 3,
            geodesic: true,
            points: MapUtils.convertToLatLng(MapUtils.decodePoly(route)),
            color: Theme
                .of(context)
                .primaryColor));
      });
    }else{
      showToastt(
          text: result.message,
          state: ToastStates.error,
          context: context);
    }
  }


  // live location
  _updateUserMarker(LocationData currentLocation) {
    if (currentLocation.latitude != null && currentLocation.longitude != null) {
      _markers.removeWhere((marker) => marker.markerId.value == 'user');
      lat = currentLocation.latitude!;
      lng = currentLocation.longitude!;
      _moveCamera();
      setState(() {
        _markers.add(Marker(
            markerId: const MarkerId('user'),
            position: LatLng(currentLocation.latitude!, currentLocation.longitude!)));
      });
    }
  }


  @override
  void initState() {
    // TODO: implement initState
    BitmapDescriptor.fromAssetImage(
        const ImageConfiguration(size: Size(50, 50)),
        'assets/images/marker_car.png')
        .then((icon) {
      customIcon = icon;
    });
    _loadMapStyles();
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    setState(() {
      _setMapStyle();
    });
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('widget.title'),
        actions: [
          IconButton(
            icon: Icon(
              mapDarkMode ? Icons.brightness_4 : Icons.brightness_5,
              color: Colors.white,
            ),
            onPressed: () {
              setState(() {
                mapDarkMode = !mapDarkMode;
                _setMapStyle();
              });
            },
          ),
          IconButton(
            icon: const Icon(
              Icons.send,
              color: Colors.white,
            ),
            onPressed: () {
              GoogleMapCubit.get(context).startService(context);
            },
          )
        ],
      ),
      body: BlocConsumer<GoogleMapCubit, GoogleMapState>(
        listener: (context, state) {
          if (state is CurrentLocationState) {
              _updateUserMarker(state.data!);
          }

        },
        builder: (context, state) => GoogleMap(
        mapType: MapType.normal,
        rotateGesturesEnabled: true,
        zoomGesturesEnabled: true,
        trafficEnabled: false,
        tiltGesturesEnabled: false,
        scrollGesturesEnabled: true,
        compassEnabled: true,
        myLocationButtonEnabled: true,
        zoomControlsEnabled: true,
        mapToolbarEnabled: false,
        markers: _markers,
        polylines: _polyline,
        initialCameraPosition:
        CameraPosition(target: initialLatLng, zoom: 13),
        onMapCreated: (GoogleMapController controller) {
          _controller.complete(controller);
          _setMapPins([const LatLng(30.1541371,31.7397189)]);
          _setMapStyle();
          // _addPolyLines(context);
        },
      ),
    ),
    );
  }

}
