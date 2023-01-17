// ignore_for_file: prefer_typing_uninitialized_variables, depend_on_referenced_packages

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:punture_system_app/home/home_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:punture_system_app/login/login.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:location/location.dart';

Future<void> _messageHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
}

late final prefs;
Future frontTime() async {
  await Firebase.initializeApp();
  FirebaseMessaging.onBackgroundMessage(_messageHandler);
  prefs = await SharedPreferences.getInstance(); //cookie
  return;
}

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  runApp(
    MaterialApp(
      title: 'Punture System',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        textTheme: const TextTheme(
          bodyText1: TextStyle(fontFamily: "Roboto"),
        ),
        primarySwatch: Colors.yellow,
      ),
      home: StretchingOverscrollIndicator(
        axisDirection: AxisDirection.down,
        child: FutureBuilder(
          builder: ((context, snapshot) {
            final size = MediaQuery.of(context).size;
            if (snapshot.connectionState == ConnectionState.waiting) {
              return ListView(
                children: [
                  SizedBox(
                    width: size.width * 0.6,
                    height: size.height * 0.3,
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
                  const CircularProgressIndicator(
                    color: Colors.red,
                  ),
                ],
              );
            } else {
              return const MyApp();
            }
          }),
          future: frontTime(),
        ),
      ),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late String? action, type;
  Location location = Location();
  @override
  void initState() {
    super.initState();
    // Try reading data from the 'phone' key. If it doesn't exist, returns null.
    action = prefs.getString('phone');
    type = prefs.getString('type');

    FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );

    FirebaseMessaging.onMessage.listen((RemoteMessage event) async {
      await showDialog(
        useSafeArea: true,
        context: context,
        builder: (context) => AlertDialog(
          title: Text(
            event.notification!.title.toString(),
            style: const TextStyle(
              color: Colors.orange,
            ),
          ),
          content: Text(
            event.notification!.body.toString(),
            overflow: TextOverflow.visible,
            maxLines: 4,
          ),
          actions: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text("ok"),
            )
          ],
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return (type == null)
        ? const LandingPage()
        : (type == "Customer")
            ? Providers(
                0,
              )
            : Providers(
                1,
              );
  }
}

class LandingPage extends StatelessWidget {
  const LandingPage({super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: const Color(0xFFf9fd37),
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarBrightness: Brightness.dark,
          statusBarIconBrightness: Brightness.dark,
          statusBarColor: Color(0xFFf9fd37),
        ),
      ),
      backgroundColor: const Color(0xFFf9fd37), // #f9fd37
      body: SizedBox(
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              width: size.width * 0.6,
              height: size.height * 0.3,
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
            SizedBox(
              height: size.height * 0.02,
            ),
            Container(
              margin: EdgeInsets.all(size.height * 0.01),
              width: size.width * 0.5,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const LogScreen(0),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  shape: const StadiumBorder(),
                  elevation: 0,
                  padding: EdgeInsets.all(size.width * 0.04),
                  backgroundColor: const Color(0xFFb3f53b), // #b3f53b
                ),
                child: const Text(
                  "Login",
                  style: TextStyle(color: Colors.black),
                ),
              ),
            ),
            Container(
              width: size.width * 0.5,
              margin: EdgeInsets.all(size.height * 0.01),
              child: ElevatedButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const LogScreen(1),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  shape: const StadiumBorder(),
                  elevation: 0,
                  padding: EdgeInsets.all(size.width * 0.04),
                  backgroundColor: const Color(0xFFb3f53b), // #b3f53b
                ),
                child: const Text(
                  "Register",
                  style: TextStyle(color: Colors.black),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
