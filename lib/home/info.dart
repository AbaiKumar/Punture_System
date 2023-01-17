// ignore_for_file: depend_on_referenced_packages, prefer_typing_uninitialized_variables

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:location/location.dart';
import 'package:latlong2/latlong.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:punture_system_app/rating.dart';
import '../model/data.dart';

class InfoWidget extends StatefulWidget {
  final int index;
  final data;
  const InfoWidget(this.index, this.data, {super.key});

  @override
  State<InfoWidget> createState() => _InfoWidgetState();
}

class _InfoWidgetState extends State<InfoWidget> {
  Location location = Location();
  final FirebaseFirestore obj = FirebaseFirestore.instance;
  late LatLng post = LatLng(9.0, 78.0);
  late Data a;
  final MapController _controller = MapController();

  @override
  void initState() {
    super.initState();
    a = widget.data;
    DocumentReference reference =
        FirebaseFirestore.instance.collection('user').doc(
              a.confirm[widget.index].data["phone2"],
            );
    reference.snapshots().listen((querySnapshot) {
      post.latitude = double.parse(
        querySnapshot.get("lat"),
      );
      post.longitude = double.parse(
        querySnapshot.get("lon"),
      );
      _controller.move(post, 16);
      debugPrint("${post.latitude} ${post.longitude} ${a.lat}");
    });
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(
          0xFFf9fd37,
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(
              height: size.height * 0.7,
              width: double.infinity,
              child: Container(
                margin: const EdgeInsets.all(10),
                child: FlutterMap(
                  //map widget start here
                  mapController: _controller,
                  options: MapOptions(
                    interactiveFlags:
                        InteractiveFlag.pinchZoom | InteractiveFlag.drag,
                    center: post,
                    zoom: 14.0,
                  ),
                  children: [
                    TileLayer(
                      //show tile map
                      urlTemplate:
                          "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
                      subdomains: const ['a', 'b', 'c'],
                    ),
                    PolylineLayer(
                      //add line
                      polylineCulling: false,
                      polylines: [
                        Polyline(
                          points: [
                            post,
                            LatLng(
                              double.parse(a.lat),
                              double.parse(a.lon),
                            ),
                          ],
                          isDotted: true,
                          color: Colors.green,
                          strokeWidth: 5,
                        ),
                      ],
                    ),
                    MarkerLayer(
                      markers: [
                        Marker(
                          //destination
                          point: LatLng(
                            double.parse(a.lat),
                            double.parse(a.lon),
                          ),
                          builder: (ctx) => const Tooltip(
                            message: "Mechanic Location",
                            child: Icon(
                              Icons.stop,
                              color: Colors.red,
                              size: 40,
                              semanticLabel: "You",
                            ),
                          ),
                        ),
                        Marker(
                          //source
                          point: post,
                          builder: (ctx) => const Tooltip(
                            message: "Your Location",
                            child: Icon(
                              Icons.location_on,
                              color: Colors.green,
                              size: 40,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            //Add Review Button
            //need to add and update data['done'] in firestore to stop from watching location
            SizedBox(
              //image widget
              width: size.width * 0.4,
              height: size.height * 0.2,
              child: FittedBox(
                fit: BoxFit.fill,
                child: ClipRRect(
                  borderRadius: BorderRadius.all(
                    Radius.circular(size.width * 0.3),
                  ),
                  child: Tooltip(
                    message: "Click to review",
                    child: GestureDetector(
                      onTap: () {
                        Navigator.of(context).pushReplacement(
                          MaterialPageRoute(
                            builder: (context) {
                              return Rating(
                                phone: a.confirm[widget.index].data["phone2"],
                                path: a.confirm[widget.index].data["path"],
                                force: a.getConfirm,
                              );
                            },
                          ),
                        );
                      },
                      child: Stack(
                        alignment: Alignment.topCenter,
                        children: [
                          Image.asset(
                            "assets/images/smile.jpg",
                            alignment: Alignment.center,
                          ),
                          Text(
                            "Click to review",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontFamily: "OpenSans",
                              fontSize: size.width * 0.16,
                              color: Colors.red,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
