import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:vendors/homepage/VENDOR/profile.dart';

class HomePageAdmin extends StatefulWidget {
  const HomePageAdmin({super.key});

  @override
  State<HomePageAdmin> createState() => _HomePageAdminState();
}

class _HomePageAdminState extends State<HomePageAdmin> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        child: Column(
          children: [
            UserAccountsDrawerHeader(
              decoration: BoxDecoration(color: Colors.transparent),
              currentAccountPicture: Icon(Icons.person_2_outlined),
              accountName: Text(
                "Admin Name",
                style: TextStyle(color: Colors.black),
              ),
              accountEmail: Text(
                "Admin Email",
                style: TextStyle(color: Colors.black),
              ),
            ),
            ListTile(
              title: Text("Home"),
              leading: Icon(Icons.home),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => HomePageAdmin()),
                );
              },
            ),
          ],
        ),
      ),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 204, 229, 250),
        title: Text("Admin Homepage"),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {},
            icon: Icon(Icons.notifications_outlined),
          ),
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ProfilePage()),
              );
            },
            icon: Icon(Icons.person_outline),
          ),
        ],
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(60),
          child: Container(
            margin: const EdgeInsets.all(8),
            padding: EdgeInsets.symmetric(horizontal: 16),
            height: MediaQuery.of(context).size.height * 0.06,
            child: TextField(
              decoration: InputDecoration(
                filled: true,
                fillColor: const Color.fromARGB(183, 255, 255, 255),
                hintText: "Search",
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(color: Colors.grey, width: 1.0),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(color: Colors.grey, width: 1.0),
                ),
              ),
            ),
          ),
        ),
      ),
      floatingActionButton: SpeedDial(
        children: [
          SpeedDialChild(
            child: Icon(Icons.person),
            label: "Vendor",
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ProfilePage()),
              );
            },
          ),

          SpeedDialChild(
            child: Icon(Icons.qr_code_scanner_outlined),
            label: "Scanner",
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ProfilePage()),
              );
            },
          ),

          SpeedDialChild(
            child: Icon(Icons.settings_outlined),
            label: "Settings",
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ProfilePage()),
              );
            },
          ),
        ],
        child: Icon(Icons.move_up_rounded),
      ),
      body: Wrap(
        children: [
          WrapButton(context, Icons.shopping_cart, "Purchase", () async {
            Fluttertoast.showToast(msg: "you clicked on Purchase");
          }),
          WrapButton(context, Icons.sell, "Sales", () {
            Fluttertoast.showToast(msg: "you clicked on Saleas");
          }),
          WrapButton(context, Icons.inventory, "Stock", () {
            Fluttertoast.showToast(msg: "you clicked on Stcok");
          }),
        ],
      ),
    );
  }

  GestureDetector WrapButton(
    BuildContext context,
    IconData icon,
    String title,
    ontap,
  ) {
    return GestureDetector(
      onTap: ontap,
      child: Container(
        decoration: BoxDecoration(
          color: const Color.fromARGB(255, 236, 236, 236),
          borderRadius: BorderRadius.circular(10),
        ),
        padding: const EdgeInsets.all(10),
        margin: const EdgeInsets.all(5),
        width: MediaQuery.of(context).size.width * 0.472,
        child: Column(
          children: [
            Icon(icon, color: Colors.black),
            Text(title, style: TextStyle()),
          ],
        ),
      ),
    );
  }
}
