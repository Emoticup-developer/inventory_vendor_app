import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vendors/auth/login.dart';
import 'package:vendors/bloc/my_bloc.dart';
import 'package:vendors/homepage/homepage.dart';

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
            if (!state.is_login) {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => LoginPage()),
                (route) => false,
              );
            } else if (state.is_login) {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => Homepage()),
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
