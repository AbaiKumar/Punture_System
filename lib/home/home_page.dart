// ignore_for_file: depend_on_referenced_packages, use_build_context_synchronously, must_be_immutable, use_key_in_widget_constructors
import 'package:flutter/material.dart';
import 'package:punture_system_app/home/info.dart';
import 'package:punture_system_app/home/review_show.dart';
import 'package:punture_system_app/model/data.dart';
import 'package:provider/provider.dart';
import 'problem.dart';
import '../main.dart';

class Providers extends StatelessWidget {
  late int value;
  Providers(
    this.value,
  );

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (BuildContext context) => Data(),
      child: Flow(
        value,
      ),
    );
  }
}

class Flow extends StatelessWidget {
  int value;
  Flow(
    this.value,
  );

  @override
  Widget build(BuildContext context) {
    return HomePage(value: value);
  }
}

class HomePage extends StatefulWidget {
  //Hom widget
  int value;
  HomePage({super.key, required this.value});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  void tap(int index, Data a) {
    //bottom nav bar change
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    var a = Provider.of<Data>(
      context,
      listen: false,
    );
    final List<Widget> render = [
      const Request(),
      const Accepted(),
    ];
    // 0 - Customer mode
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () {
              if (_selectedIndex == 0) {
                a.getRequest(); //request data get
              } else {
                a.getConfirm(); //customer data get
              }
            },
            icon: const Icon(
              Icons.refresh_outlined,
            ),
          ),
          const SizedBox(
            width: 5,
          ) //empty space in appbar
        ],
        title: const Text(
          //app bar title
          "Welcome",
          style: TextStyle(
            color: Colors.black,
          ),
        ),
        iconTheme: const IconThemeData(
          color: Colors.black,
        ),
        backgroundColor: const Color(
          0xFFf9fd37,
        ),
        elevation: 0,
      ),
      floatingActionButton: widget.value == 0 //floating button for customer
          ? FloatingActionButton(
              child: const Icon(
                Icons.construction_outlined,
              ),
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => UserApp(
                      a,
                    ),
                  ),
                );
              })
          : null,
      drawer: Drawer(
        //drawer widget
        child: Column(
          children: [
            Consumer<Data>(
              builder: (context, value, child) => UserAccountsDrawerHeader(
                decoration: const BoxDecoration(
                  color: Color(
                    0xFFf9fd37,
                  ),
                ),
                currentAccountPicture: const CircleAvatar(
                  backgroundColor: Colors.black,
                  foregroundColor: Colors.white,
                  child: Icon(
                    Icons.car_repair_outlined,
                    size: 40,
                  ),
                ),
                accountName: Text(
                  value.phone ?? "You",
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Colors.black,
                  ),
                ),
                accountEmail: Text(
                  value.type ?? ".",
                  style: const TextStyle(
                    color: Colors.black,
                  ),
                ),
              ),
            ),
            SizedBox(
              //logout button widget
              width: double.infinity,
              child: TextButton.icon(
                icon: const Icon(
                  Icons.logout_outlined,
                  color: Colors.red,
                ),
                style: TextButton.styleFrom(
                  padding: const EdgeInsets.all(
                    20,
                  ),
                  alignment: Alignment.topLeft,
                ),
                onPressed: () {
                  a.clear(); //clear cache
                  widget.value = 0;
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const LandingPage(),
                    ),
                    (route) => false,
                  );
                },
                label: FittedBox(
                  fit: BoxFit.fitWidth,
                  child: Container(
                    margin: const EdgeInsets.only(
                      left: 25,
                    ),
                    child: const Text(
                      "Logout",
                      style: TextStyle(
                        color: Colors.red,
                        fontSize: 16,
                        fontStyle: FontStyle.normal,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.shifting,
        selectedIconTheme: const IconThemeData(
          color: Colors.green,
        ),
        unselectedIconTheme: const IconThemeData(
          color: Colors.red,
        ),
        currentIndex: _selectedIndex,
        onTap: (index) {
          tap(index, a);
        },
        selectedItemColor: Colors.green,
        unselectedItemColor: Colors.red,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(
              Icons.pending_outlined,
            ),
            label: 'Request',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.check_outlined,
            ),
            label: 'Status',
          ),
        ],
      ),
      body: render[_selectedIndex],
    );
  }
}

class Request extends StatelessWidget {
  const Request({super.key});

  Widget requestUser(size, Data a, BuildContext context) {
    //Customer Request Widget
    return a.godown.isEmpty
        ? const Center(
            child: FittedBox(
              fit: BoxFit.fitWidth,
              child: Text(
                "Data not Found",
              ),
            ),
          )
        : ListView.builder(
            itemCount: a.godown.length,
            itemBuilder: (context, index) {
              return Theme(
                data: ThemeData(
                  textTheme: const TextTheme(
                    bodyText1: TextStyle(
                      fontFamily: "OpenSans",
                      overflow: TextOverflow.ellipsis,
                      fontSize: 16,
                    ),
                  ),
                ),
                child: Container(
                  margin: EdgeInsets.all(
                    size.width * 0.03,
                  ),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.grey,
                    ),
                    borderRadius: BorderRadius.all(
                      Radius.circular(
                        size.width * 0.05,
                      ),
                    ),
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SizedBox(
                            //image widget
                            width: size.width * 0.38,
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
                            width: size.width * 0.5,
                            margin: EdgeInsets.all(size.width * 0.02),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                FittedBox(
                                  fit: BoxFit.fitWidth,
                                  child: Text(
                                    //data print
                                    "Model : ${a.godown[index][0].data['model'] as String}\nNumber : ${a.godown[index][0].data['veh_num']}\nCall : ${a.godown[index][0].data['phone']}",
                                    overflow: TextOverflow.fade,
                                  ),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                      //{phone: 1111111111, lon: 77.0109248, type: Mechanic, lat: 11.0187579}
                      if (a.godown[index].length > 1) ...[
                        //request showing widget
                        for (int i = 1; i < a.godown[index].length; i++)
                          GestureDetector(
                            onTap: (() {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => Review(
                                    a.godown[index][i].data['phone'],
                                  ),
                                ),
                              );
                            }),
                            child: Container(
                              margin: const EdgeInsets.all(10),
                              child: FittedBox(
                                fit: BoxFit.fitWidth,
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Container(
                                      margin: const EdgeInsets.all(5),
                                      child: Text(
                                        "Phone.no : ${a.godown[index][i].data['phone']}",
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.red),
                                      onPressed: () {
                                        a.fullConfirm(
                                          a.godown[index][0].data["path"],
                                          a.godown[index][i].data["phone"],
                                        );
                                      },
                                      child: const Text("Accept"),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                      ] else ...[
                        //no request found
                        FittedBox(
                          fit: BoxFit.fitWidth,
                          child: Container(
                            margin: const EdgeInsets.all(10),
                            child: const Center(
                              child: Text("Request not Found"),
                            ),
                          ),
                        )
                      ]
                    ],
                  ),
                ),
              );
            },
          );
  }

  Widget requestMech(size, Data a, BuildContext context) {
    //Mechanic request widget
    return (a.request.isEmpty)
        ? const Center(
            child: FittedBox(
              fit: BoxFit.fitWidth,
              child: Text("Data not Found"),
            ),
          )
        : ListView.builder(
            itemCount: a.request.length,
            itemBuilder: (context, index) {
              return Theme(
                data: ThemeData(
                  textTheme: const TextTheme(
                    bodyText1: TextStyle(
                      fontFamily: "OpenSans",
                      overflow: TextOverflow.ellipsis,
                      fontSize: 16,
                    ),
                  ),
                ),
                child: Container(
                  margin: EdgeInsets.all(size.width * 0.03),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius:
                        BorderRadius.all(Radius.circular(size.width * 0.05)),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                        width: size.width * 0.38,
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
                        width: size.width * 0.5,
                        margin: EdgeInsets.all(size.width * 0.02),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            FittedBox(
                              fit: BoxFit.fitWidth,
                              child: Text(
                                (a.type == "Mechanic")
                                    ? "Model : ${a.request[index].data['model']}\nNumber : ${a.request[index].data['veh_num']}\nPhone.no : ${a.request[index].data['phone']}\nDistance near : ${a.request[index].distance.toStringAsFixed(2)}Km"
                                    : "Model : ${a.request[index].data['model']}\nNumber : ${a.request[index].data['veh_num']}\nPhone.no : ${a.request[index].data['phone']}",
                                style: Theme.of(context).textTheme.bodyText1,
                              ),
                            ),
                            if (a.type == "Mechanic") ...[
                              FittedBox(
                                fit: BoxFit.fitWidth,
                                child: ElevatedButton.icon(
                                  style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.red),
                                  onPressed: () {
                                    a.setConfirm(a.request[index]);
                                  },
                                  icon: const Icon(Icons.check_circle_outline),
                                  label: const Text(
                                    "Accept Request",
                                  ),
                                ),
                              )
                            ]
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              );
            },
          );
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    var a = Provider.of<Data>(context);
    return RefreshIndicator(
      color: Colors.red,
      onRefresh: () => a.getRequest(),
      child: (a.type == "Customer")
          ? requestUser(size, a, context) //Customer request widget
          : requestMech(size, a, context), //Mechanic request widget
    );
  }
}

class Accepted extends StatelessWidget {
  //Status Page widget
  const Accepted({super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    debugPrint("Accept Page");
    var a = Provider.of<Data>(context);
    return Theme(
      //Apply theme
      data: ThemeData(
        textTheme: const TextTheme(
          bodyText1: TextStyle(
            fontFamily: "OpenSans",
            overflow: TextOverflow.ellipsis,
            fontSize: 16,
          ),
        ),
      ),
      child: RefreshIndicator(
        color: Colors.red,
        onRefresh: () => a.getConfirm(),
        child: a.confirm.isNotEmpty
            ? ListView.builder(
                itemCount: a.confirm.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      (a.confirm[index].distance == 0 &&
                              !a.confirm[index].data['done'])
                          ? Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: ((context) => InfoWidget(
                                      index,
                                      a,
                                    )),
                              ),
                            )
                          : null;
                    },
                    child: Container(
                      margin: EdgeInsets.all(size.width * 0.03),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.all(
                          Radius.circular(size.width * 0.05),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SizedBox(
                            width: size.width * 0.38,
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
                            width: size.width * 0.5,
                            margin: EdgeInsets.all(size.width * 0.02),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                FittedBox(
                                  fit: BoxFit.fitWidth,
                                  child: Text(
                                    "Model : ${a.confirm[index].data['model']}\nNumber : ${a.confirm[index].data['veh_num']}\nCall : ${a.confirm[index].data['phone']}",
                                    style:
                                        Theme.of(context).textTheme.bodyText1,
                                  ),
                                ),
                                Container(
                                  margin: EdgeInsets.all(size.width * 0.02),
                                  decoration: BoxDecoration(
                                    color: (a.confirm[index].distance == 0)
                                        ? Colors.green
                                        : Colors.red,
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(size.width * 0.2),
                                    ),
                                  ),
                                  padding: const EdgeInsets.all(10.0),
                                  alignment: Alignment.center,
                                  child: Text(
                                    (a.confirm[index].distance == 0)
                                        ? "Confirmed"
                                        : "Requested",
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                )
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  );
                })
            : const Center(
                child: FittedBox(
                  fit: BoxFit.fitWidth,
                  child: Text("Data not Found"),
                ),
              ),
      ),
    );
  }
}
