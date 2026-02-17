import 'package:flutter/material.dart';

class HomePageManager extends StatefulWidget {
  const HomePageManager({super.key});

  @override
  State<HomePageManager> createState() => _HomePageManagerState();
}

class _HomePageManagerState extends State<HomePageManager> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Center(child: Text("Manager Homepage")));
  }
}