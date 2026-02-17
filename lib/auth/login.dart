import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'package:vendors/bloc/my_bloc.dart';
import 'package:vendors/homepage/ADMIN/homepage.dart';
import 'package:vendors/homepage/MANAGER/homepage.dart';
import 'package:vendors/setup/splash.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController username = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController server = TextEditingController();

  AppBloc my_bloc = AppBloc(
    "${baseUrl}/access/login/",
    "${baseUrl}/access/login/",
    "${baseUrl}/access/login/",
    "${baseUrl}/access/login/",
  );
  bool is_obscure = true;
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) {
        return my_bloc;
      },
      child: Scaffold(
        body: BlocListener<AppBloc, AppState>(
          listener: (BuildContext context, AppState state) async {
            if (state is AppSuccess) {
              var user_type = await Hive.box(
                'auth',
              ).get("type", defaultValue: "VENDOR");
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text("Login Success")));
              if (user_type == "VENDOR") {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SplashScreen()),
                );
              } else if (user_type == "ADMIN") {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const HomePageAdmin(),
                  ),
                );
              } else if (user_type == "MANAGER") {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const HomePageManager(),
                  ),
                );
              }
            } else if (state is AppError) {
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text(state.message)));
            } else {}
          },

          child: Center(
            child: Container(
              padding: const EdgeInsets.all(15),
              margin: const EdgeInsets.all(2),
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                color: const Color.fromARGB(183, 222, 241, 255),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text("AERP", style: TextStyle(fontSize: 30)),
                  Container(
                    padding: const EdgeInsets.all(5),
                    child: TextField(
                      controller: username,
                      decoration: InputDecoration(
                        labelText: "Username",
                        hintText: "Enter Username",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(
                            color: Colors.grey,
                            width: 1.0,
                          ),
                        ),

                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(
                            color: Colors.grey,
                            width: 1.0,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(5),
                    child: TextField(
                      controller: password,
                      keyboardType: TextInputType.visiblePassword,
                      obscureText: is_obscure,

                      decoration: InputDecoration(
                        suffixIcon: IconButton(
                          icon: Icon(
                            is_obscure
                                ? Icons.visibility
                                : Icons.visibility_off,
                          ),
                          onPressed: () {
                            setState(() {
                              is_obscure = !is_obscure;
                            });
                          },
                        ),
                        labelText: "Password",
                        hintText: "Enter Password",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(
                            color: Colors.grey,
                            width: 1.0,
                          ),
                        ),

                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(
                            color: Colors.grey,
                            width: 1.0,
                          ),
                        ),
                      ),
                    ),
                  ),

                  SizedBox(height: 20),
                  CupertinoButton(
                    child: BlocBuilder<AppBloc, AppState>(
                      builder: (BuildContext context, AppState state) {
                        if (state is AppLoading) {
                          return CircularProgressIndicator();
                        } else {
                          return Text("Login");
                        }
                      },
                    ),
                    onPressed: () {
                      my_bloc.add(
                        LoginRequested(
                          username.text.toString().trim(),
                          password.text.toString().trim(),
                          "LIVE",
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
