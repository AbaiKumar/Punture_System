// ignore_for_file: prefer_typing_uninitialized_variables, depend_on_referenced_packages, must_be_immutable, avoid_init_to_null, use_key_in_widget_constructors

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Rating extends StatelessWidget {
  final phone, path;
  final Function force;
  const Rating({
    super.key,
    required this.phone,
    this.path,
    required this.force,
  });

  @override
  Widget build(BuildContext context) {
    //build stat here
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          margin: const EdgeInsets.all(12),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
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
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
              Container(
                margin: const EdgeInsets.all(
                  15,
                ),
                child: FittedBox(
                  fit: BoxFit.fitWidth,
                  child: Text(
                    "Thank you for choosing our service",
                    style: TextStyle(
                      color: Colors.redAccent,
                      fontSize: size.width * 0.055,
                    ),
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.all(
                  15,
                ),
                child: FittedBox(
                  fit: BoxFit.fitWidth,
                  child: Text(
                    "RATE US NOW!!!",
                    style: TextStyle(
                      fontSize: size.width * 0.055,
                    ),
                  ),
                ),
              ),
              StarReview(phone: phone, path: path, force: force),
            ],
          ),
        ),
      ),
      appBar: AppBar(
        //AppBar
        elevation: 0,
        backgroundColor: const Color(
          0xFFf9fd37,
        ),
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarBrightness: Brightness.light,
          statusBarColor: Color(
            0xFFf9fd37,
          ),
          statusBarIconBrightness: Brightness.dark,
        ),
      ),
      backgroundColor: const Color(
        0xFFf9fd37,
      ),
    );
  }
}

class StarReview extends StatefulWidget {
  final phone, path;
  final Function force;
  const StarReview({
    super.key,
    required this.phone,
    this.path,
    required this.force,
  });

  @override
  State<StarReview> createState() => _StarReviewState();
}

class _StarReviewState extends State<StarReview> {
  int value = -1;
  TextEditingController txt1 = TextEditingController();

  Future<void> writeReview() async {
    if (txt1.text != "" && value != -1) {
      FirebaseFirestore.instance
          .collection('user')
          .doc(widget.phone)
          .collection("review")
          .doc()
          .set(
        {
          "text": txt1.text,
          "val": value,
        },
      );
      FirebaseFirestore.instance.doc(widget.path).update(
        {
          "done": true,
        },
      );
      Navigator.of(context).pop();
      widget.force();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData(
        iconTheme: const IconThemeData(size: 30, color: Colors.amber),
      ),
      child: Column(
        children: [
          SizedBox(
            width: double.infinity,
            height: 85,
            child: Card(
              margin: const EdgeInsets.all(15),
              elevation: 0,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(5, (index) {
                      return IconButton(
                        onPressed: () {
                          setState(() {
                            value = index;
                          });
                        },
                        icon: Icon(
                          index <= value ? Icons.star : Icons.star_border,
                          size: 40,
                        ),
                      );
                    }),
                  ),
                ],
              ),
            ),
          ),
          Container(
            margin: const EdgeInsets.all(15),
            child: TextField(
              style: const TextStyle(
                fontFamily: "OpenSans",
              ),
              cursorColor: Colors.redAccent,
              decoration: const InputDecoration(
                fillColor: Colors.white,
                filled: true,
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.white,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.white,
                  ),
                ),
                label: Text(
                  "Write a review",
                  style: TextStyle(
                    color: Colors.grey,
                    fontStyle: FontStyle.normal,
                  ),
                ),
              ),
              textInputAction: TextInputAction.done,
              controller: txt1,
              maxLines: 2,
              maxLength: 75,
              keyboardType: TextInputType.text,
            ),
          ),
          SizedBox(
            width: double.infinity,
            child: Center(
              child: ElevatedButton(
                onPressed: () {
                  writeReview();
                },
                style: ElevatedButton.styleFrom(
                  elevation: 0,
                  backgroundColor: const Color.fromARGB(
                    255,
                    102,
                    227,
                    106,
                  ),
                ),
                child: const Text(
                  "Submit",
                  style: TextStyle(color: Colors.black),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
