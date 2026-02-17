import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:vendors/auth/login.dart';
import 'package:vendors/bloc/my_bloc.dart';
import 'package:vendors/homepage/ADMIN/homepage.dart';
import 'package:vendors/homepage/MANAGER/homepage.dart';
import 'package:vendors/homepage/VENDOR/homepage.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  AppBloc my_bloc = AppBloc("", "", "", "");
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) {
        return my_bloc..add(SplashEvent());
      },
      child: BlocListener<AppBloc, AppState>(
        listener: (BuildContext context, AppState state) {
          if (state is SplashState) {
            var user_type = Hive.box('auth').get("type", defaultValue: "VENDOR");
            if (!state.is_login) {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => LoginPage()),
                (route) => false,
              );
            } else if (state.is_login && user_type == "VENDOR") {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => Homepage()),
                (route) => false,
              );
            } else if (state.is_login && user_type == "MANAGER") {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => HomePageManager()),
                (route) => false,
              );
            } else if (state.is_login && user_type == "ADMIN") {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => HomePageAdmin()),
                (route) => false,
              );
            }
          }
        },
        child: Scaffold(body: Center(child: Text("Splash Screen"))),
      ),
    );
  }
}
