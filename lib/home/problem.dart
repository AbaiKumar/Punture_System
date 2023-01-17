// ignore_for_file: prefer_typing_uninitialized_variables, depend_on_referenced_packages, must_be_immutable, avoid_init_to_null

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:punture_system_app/model/data.dart';
import 'pick_location.dart';

class UserApp extends StatefulWidget {
  Data a;
  UserApp(this.a, {super.key});

  @override
  State<UserApp> createState() => _UserApp();
}

class _UserApp extends State<UserApp> {
  var formkey = GlobalKey<FormState>();
  var usr = FocusNode();
  var pass = FocusNode();
  dynamic vechicle, model;
  ValueNotifier<List> notifier = ValueNotifier([0.0, 0.0]);

  void fun(ctx) async {
    List? p = await pick(ctx);
    if (p != null) {
      notifier.value = p.toList();
    }
  }

  void saved(String phone, context) async {
    //save problems
    formkey.currentState!.save();
    if (formkey.currentState!.validate() == false) {
      return;
    }
    try {
      //necessary data to update in firestore
      final firestore = FirebaseFirestore.instance;
      final docs = firestore.collection("problem").doc();
      docs.set({
        "phone": phone,
        "phone2": "",
        "veh_num": vechicle,
        "model": model,
        "lat": notifier.value[0].toString(),
        "lon": notifier.value[1].toString(),
        "confirm": false,
        "done": false,
        "path": docs.path,
        "list": []
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: SizedBox(
            width: MediaQuery.of(context).size.width * 0.9,
            child: const Text(
              "Success",
            ),
          ),
        ),
      );
      Navigator.of(context).pop();
    } catch (error) {
      //none
    }
  }

  @override
  Widget build(BuildContext context) {
    //build stat here
    var a = widget.a;
    Size size = MediaQuery.of(context).size;
    final width = size.width;
    final height = size.height;

    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          margin: const EdgeInsets.all(12),
          child: Column(
            children: [
              Row(
                children: [
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
                        child: Image.asset(
                          "assets/images/scooty_image.jpeg",
                          alignment: Alignment.center,
                        ),
                      ),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.all(10),
                    height: size.height * 0.25,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        FittedBox(
                          fit: BoxFit.fitWidth,
                          child: Text(
                            "TYRES FLAT??\n\nDON'T WORRY",
                            style: TextStyle(
                              fontSize: size.width * 0.055,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
              SizedBox(
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey, width: 0.5),
                    borderRadius: BorderRadius.circular(30),
                    color: Colors.white,
                  ),
                  padding: const EdgeInsets.all(20),
                  width: width * 0.85,
                  child: Form(
                    //form widget to collect data
                    key: formkey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        TextFormField(
                          keyboardType: TextInputType.url,
                          focusNode: usr,
                          cursorColor: Colors.black,
                          decoration: InputDecoration(
                            errorBorder: OutlineInputBorder(
                              borderSide: const BorderSide(
                                color: Colors.red,
                              ),
                              borderRadius: BorderRadius.circular(50.0),
                            ),
                            focusedErrorBorder: OutlineInputBorder(
                              borderSide: const BorderSide(
                                color: Colors.red,
                              ),
                              borderRadius: BorderRadius.circular(50.0),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(50.0),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: const BorderSide(
                                color: Color(0xFFb3f53b),
                              ),
                              borderRadius: BorderRadius.circular(50.0),
                            ),
                            label: const FittedBox(
                              fit: BoxFit.fitWidth,
                              child: Text(
                                "Vehicle Number",
                                style: TextStyle(
                                    color: Color(0xFFb3f53b),
                                    fontWeight: FontWeight.w500),
                              ),
                            ),
                            prefixIcon: const Icon(
                              Icons.pin,
                              color: Color(0xFFb3f53b),
                            ),
                          ),
                          onFieldSubmitted: (_) {
                            FocusScope.of(context).requestFocus(pass);
                          },
                          onSaved: (str) {
                            vechicle = str!;
                          },
                          validator: (str) {
                            if (str == null || str == "") {
                              return "Enter Vechicle Number";
                            }
                            return null;
                          },
                        ),
                        SizedBox(
                          height: height * 0.01,
                        ),
                        TextFormField(
                          cursorColor: Colors.black,
                          keyboardType: TextInputType.text,
                          focusNode: pass,
                          decoration: InputDecoration(
                            errorBorder: OutlineInputBorder(
                              borderSide: const BorderSide(
                                color: Colors.red,
                              ),
                              borderRadius: BorderRadius.circular(50.0),
                            ),
                            focusedErrorBorder: OutlineInputBorder(
                              borderSide: const BorderSide(
                                color: Colors.red,
                              ),
                              borderRadius: BorderRadius.circular(50.0),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(50.0),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: const BorderSide(
                                color: Color(0xFFb3f53b),
                              ), //<-- SEE HERE
                              borderRadius: BorderRadius.circular(50.0),
                            ),
                            label: const FittedBox(
                              fit: BoxFit.fitWidth,
                              child: Text(
                                "Vehicle Type",
                                style: TextStyle(
                                    color: Color(0xFFb3f53b),
                                    fontWeight: FontWeight.w500),
                              ),
                            ),
                            prefixIcon: const Icon(Icons.car_crash_outlined,
                                color: Color(0xFFb3f53b)),
                          ),
                          onFieldSubmitted: (_) {
                            model = _;
                          },
                          onSaved: (str) {
                            model = str!;
                          },
                          validator: (str) {
                            if (str == null || str == "") {
                              return "Enter Vechicle Type(Model)";
                            }
                            return null;
                          },
                        ),
                        SizedBox(
                          height: height * 0.01,
                        ),
                        TextButton.icon(
                          //location select icon
                          onPressed: () {
                            fun(context);
                          },
                          icon: const Icon(
                            Icons.location_history,
                            color: Colors.blue,
                          ),
                          label: const FittedBox(
                            fit: BoxFit.fitWidth,
                            child: Text(
                              "Select Location",
                              style: TextStyle(color: Colors.blue),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: height * 0.01,
                        ),
                        SizedBox(
                          width: width * 0.4,
                          child: ElevatedButton(
                            onPressed: () {
                              saved(a.phone, context);
                              a.getRequest();
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  const Color(0xFFb3f53b), // #b3f53b
                              elevation: 0,
                              padding: const EdgeInsets.all(10),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                            ),
                            child: const Text(
                              "Proceed",
                              style: TextStyle(color: Colors.black),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      appBar: AppBar(
        //AppBar
        elevation: 0,
        backgroundColor: const Color(0xFFf9fd37),
        systemOverlayStyle: const SystemUiOverlayStyle(
            statusBarBrightness: Brightness.light,
            statusBarColor: Color(0xFFf9fd37),
            statusBarIconBrightness: Brightness.dark),
      ),
      backgroundColor: const Color(0xFFf9fd37),
    );
  }
}
