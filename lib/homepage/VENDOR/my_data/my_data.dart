import 'package:flutter/material.dart';
import 'package:vendors/homepage/VENDOR/my_data/core_data.dart';
import 'package:vendors/homepage/VENDOR/my_data/declaration.dart';
import 'package:vendors/homepage/VENDOR/my_data/kyc.dart';

class MyDataVendor extends StatefulWidget {
  const MyDataVendor({super.key});

  @override
  State<MyDataVendor> createState() => _MyDataVendorState();
}

class _MyDataVendorState extends State<MyDataVendor> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("My Data"), centerTitle: true),
      body: Center(
        child: Column(
          children: [
            ListTile(
              title: Text("Core Data"),
              leading: Icon(Icons.person),
              trailing: Icon(Icons.arrow_forward_ios),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => CoreDataVendor()),
                );
              },
            ),
            ListTile(
              title: Text("KYC Data"),
              leading: Icon(Icons.person),
              trailing: Icon(Icons.arrow_forward_ios),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => VendorKYCPage()),
                );
              },
            ),
            ListTile(
              title: Text("Acknowledgement Data"),
              leading: Icon(Icons.person),
              trailing: Icon(Icons.arrow_forward_ios),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => VendorDeclaration()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
