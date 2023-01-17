// ignore_for_file: depend_on_referenced_packages, prefer_typing_uninitialized_variables, avoid_init_to_null
import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'package:location/location.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart' as http;

class Vehicle {
  //Base class
  Map<String, dynamic> data;
  double distance;
  Vehicle(this.data, this.distance);
}

class Data with ChangeNotifier {
  //default variables
  dynamic phone = null, type = null, prefs = null;
  late String lat = "0.0", lon = "0.0";
  late FirebaseFirestore firestore;
  List<Vehicle> request = [], confirm = [];
  List<List<dynamic>> godown = [];
  Location location = Location();

  Data() {
    //constructor to initialize object
    () async {
      firestore = FirebaseFirestore.instance;
      prefs = await SharedPreferences.getInstance(); //cookie
      phone = prefs.getString('phone');
      type = prefs.getString('type');
      await getlocation();
      getRequest();
      getConfirm();
      notifyListeners();
    }();
  }

  double calculateDistance(double lat1, double lon1, double lat2, double lon2) {
    //calculate distance bwteen two points
    var p = 0.017453292519943295;
    var c = cos;
    var a = 0.5 -
        c((lat2 - lat1) * p) / 2 +
        c(lat1 * p) * c(lat2 * p) * (1 - c((lon2 - lon1) * p)) / 2;
    return 12742 * asin(sqrt(a));
  }

  Future updateLocation() async {
    //update location to firestore
    if (lat == "0.0" || lon == "0.0") {
      if (type == "Customer") {
        getlocation();
      }
      return;
    }
    firestore.collection("user").doc(phone).update(
      {'lat': lat, 'lon': lon},
    );
  }

  Future getlocation() async {
    //get location
    location.enableBackgroundMode(enable: false);
    await location.getLocation().then(
      (currentLocation) {
        lat = currentLocation.latitude.toString();
        lon = currentLocation.longitude.toString();
      },
    );
    await updateLocation();
    if (type != "Customer") {
      //
      Timer.periodic(
        const Duration(seconds: 60),
        (e) async {
          if (type == "Customer") {
            e.cancel();
          }
          await location.getLocation().then(
            (currentLocation) {
              lat = currentLocation.latitude.toString();
              lon = currentLocation.longitude.toString();
            },
          );
          await updateLocation();
        },
      );
    }
  }

  Future<void> getRequest() async {
    //requested data
    final path1 = await firestore.collection("problem").get();
    dynamic l, d;
    var e, val1;
    double dis;
    if (type == "Customer") {
      //Customer
      godown = [];
      for (val1 in path1.docs) {
        l = val1.data();
        List chunk = [];
        chunk.add(Vehicle(l, 0));
        if (l['phone'] == phone && !l['confirm']) {
          List data = l['list'];
          for (e in data) {
            await firestore.collection("user").doc(e).get().then((value) {
              d = value.data() as Map<String, dynamic>;
              dis = calculateDistance(
                double.parse(d['lat'].toString()),
                double.parse(d['lon'].toString()),
                double.parse(lat),
                double.parse(lon),
              );
              if (dis.toInt() <= 5) {
                chunk.add(Vehicle(d, dis));
              }
            }); //end of collection...
          }
          godown.add(chunk);
        }
      }
    } else {
      //mechanic
      request = [];
      for (val1 in path1.docs) {
        final l = val1.data();
        dis = calculateDistance(
          double.parse(l['lat']),
          double.parse(l['lon']),
          double.parse(lat),
          double.parse(lon),
        );
        if (!l['confirm'] && (dis <= 5)) {
          try {
            if (!l['list'].contains(phone)) {
              request.add(Vehicle(l, dis));
            }
          } catch (error) {
            request.add(Vehicle(l, dis));
          }
        }
      }
    }
    notifyListeners();
  }

  Future<void> getConfirm() async {
    //confirmation data from firestore
    confirm = [];
    final path1 = await firestore.collection("problem").get();
    late var l;
    if (type == "Customer") {
      //Customer
      late var val1;
      for (val1 in path1.docs) {
        l = val1.data();
        if (l['phone'] == phone && l['confirm']) {
          confirm.add(Vehicle(l, 0));
        }
      }
    } else {
      //mechanic
      for (var val1 in path1.docs) {
        l = val1.data();
        if (l['phone2'] == phone) {
          confirm.add(Vehicle(l, 0));
        } else if (!l['confirm']) {
          confirm.add(Vehicle(l, 1));
        }
      }
    }
    notifyListeners();
  }

  Future<void> setConfirm(Vehicle val) async {
    //set confirmation by mechanic to task and upadate in firebase
    try {
      final path = firestore.doc(val.data["path"]);
      await path.get().then((value) {
        var data = value.data()!['list'];
        if (data != null) {
          data.add(phone);
          path.update({"list": data});
        } else {
          path.update(
            {
              "list": [phone]
            },
          );
        }
      });
      //set notification
      firestore.doc("/user/${val.data["phone"]}").get().then(
        (value) {
          final id = value.data()?["msgid"];
          if (id != null) {
            sendNotification(
              "REQUEST ARRIVED!!",
              "Mechanic Requested.",
              id,
            );
          }
        },
      );
      getRequest();
      notifyListeners();
    } catch (error) {
      //none
    }
  }

  Future<void> sendNotification(
      String msg, String reason, String msgToken) async {
    //notificatin sending function by http
    String url = "https://fcm.googleapis.com/fcm/send";
    try {
      await http.post(
        Uri.parse(url),
        body: json.encode(
          {
            "to": msgToken,
            "notification": {
              "title": msg,
              "body": reason,
              "mutable_content": true,
              "sound": "Tri-tone",
              "priority": "high"
            },
          },
        ),
        headers: {
          "Content-Type": "application/json",
          "Authorization":
              "key=AAAAhzBkLaA:APA91bEpMPQ0IBqc4c-YVUPfUV7Du9b399yvt5SnOwtTRzpmd3fNnYBWpd8KGpYGFNnRuo83Vp002ntwIJmr3laiMMwHEqg5mcJn9P-k_myPO0n3H-XxIBZPILYgfoZ8FBS5usbEDqkY",
        },
      );
    } catch (e) {
      //none
    }
  }

  Future<void> fullConfirm(String path, String phone2) async {
    //complete cnfirmation by Customer at last
    try {
      firestore.doc(path).update(
        {"confirm": true, "phone2": phone2, "list": []},
      );
      firestore.doc("/user/$phone2").get().then(
        (value) {
          final id = value.data()?["msgid"];
          if (id != null) {
            sendNotification(
              "REQUEST ACCEPTED!!",
              "Customer Accepted Your Request..",
              id,
            );
          }
        },
      );
      getRequest();
      getConfirm();
      notifyListeners();
    } catch (error) {
      //none
    }
  }

  void clear() async {
    // Remove cokie data...
    final prefs = await SharedPreferences.getInstance(); //cookie
    await prefs.clear();
  }
}
