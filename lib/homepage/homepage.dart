import 'package:flutter/material.dart';
import 'package:vendors/homepage/profile.dart';
import 'package:vendors/homepage/quotation/quotation.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(),
      appBar: AppBar(
        title: Text("S-play-Chain"),
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
      ),
      body: Center(
        child: Column(
          children: [
            ListTile(
              onTap: () async {},
              title: Text("Purchase Order"),
              subtitle: Text("Manage the Purchase Order"),
              leading: Icon(Icons.mobile_friendly_outlined),
              trailing: Icon(Icons.arrow_forward_ios),
            ),
            ListTile(
              onTap: () {},
              title: Text("Transactions"),
              subtitle: Text("Manage the Transactions"),
              leading: Icon(Icons.receipt_long_outlined),
              trailing: Icon(Icons.arrow_forward_ios),
            ),
            ListTile(
              onTap: () {},
              title: Text("My-Data"),
              subtitle: Text("Your Data is here"),
              leading: Icon(Icons.storage_outlined),
              trailing: Icon(Icons.arrow_forward_ios),
            ),

            ListTile(
              onTap: () {},

              title: Text("Acknowledgement"),
              subtitle: Text("Acknowledgement & Declaration "),
              leading: Icon(Icons.verified_outlined),
              trailing: Icon(Icons.arrow_forward_ios),
            ),

            ListTile(
              onTap: () {},

              title: Text("Material"),
              subtitle: Text("Manage the Material"),
              leading: Icon(Icons.inventory_2_outlined),
              trailing: Icon(Icons.arrow_forward_ios),
            ),

            ListTile(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => QuotationPage()),
                );
              },

              title: Text("Quotation"),
              subtitle: Text("Manage the Quotation"),
              leading: Icon(Icons.request_quote_outlined),
              trailing: Icon(Icons.arrow_forward_ios),
            ),
          ],
        ),
      ),
    );
  }
}
