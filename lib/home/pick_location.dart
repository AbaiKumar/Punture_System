// ignore_for_file: use_key_in_widget_constructors, depend_on_referenced_packages

import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

Future<List?> pick(context) async {
  Location location = Location();
  late LatLng post = LatLng(9.0, 78.0);
  await location.getLocation().then((currentLocation) {
    post.latitude = currentLocation.latitude ?? 0.0;
    post.longitude = currentLocation.longitude ?? 0.0;
  });
  return await showDialog(
    context: context,
    builder: (ctx) {
      return WillPopScope(
        onWillPop: () async {
          return true;
        },
        child: SizedBox(
          height: MediaQuery.of(context).size.height / 2.4,
          width: MediaQuery.of(context).size.height / 2,
          child: Map(post),
        ),
      );
    },
  );
}

class Map extends StatefulWidget {
  final LatLng post;
  const Map(this.post);
  @override
  State<Map> createState() => _MapState();
}

class _MapState extends State<Map> {
  late LatLng post;

  @override
  void initState() {
    super.initState();
    post = widget.post;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      actionsAlignment: MainAxisAlignment.spaceEvenly,
      title: const FittedBox(
        fit: BoxFit.fitWidth,
        child: Padding(
          padding: EdgeInsets.all(10),
          child: Text(
            "Pick Location",
          ),
        ),
      ),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(2.0),
        ),
      ),
      contentPadding: EdgeInsets.zero,
      content: SizedBox(
        height: MediaQuery.of(context).size.height / 2.5,
        width: MediaQuery.of(context).size.height / 2,
        child: FlutterMap(
          //map widget start here
          options: MapOptions(
            interactiveFlags: InteractiveFlag.pinchZoom | InteractiveFlag.drag,
            center: post,
            zoom: 14.0,
            onTap: (position, val) {
              //move location
              setState(() {
                post.latitude = val.latitude;
                post.longitude = val.longitude;
              });
            },
          ),
          children: [
            TileLayer(
              //tile map show
              urlTemplate: "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
              subdomains: const ['a', 'b', 'c'],
            ),
            MarkerLayer(
              markers: [
                Marker(
                  //click position marker
                  point: post,
                  builder: (ctx) => const Icon(
                    Icons.location_on,
                    color: Colors.green,
                    size: 40,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      actions: [
        ElevatedButton(
          style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
          onPressed: () async {
            Navigator.pop(context, [post.latitude, post.longitude]);
          },
          child: const Text("Pick"), //select location picked
        ),
      ],
    );
  }
}
