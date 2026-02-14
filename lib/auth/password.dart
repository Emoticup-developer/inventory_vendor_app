import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vendors/bloc/my_bloc.dart';

class PasswordReset extends StatefulWidget {
  const PasswordReset({super.key, required this.user_id});

  final String user_id;

  @override
  State<PasswordReset> createState() => _PasswordResetState();
}

class _PasswordResetState extends State<PasswordReset> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _oldPasswordController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final AppBloc myBloc = AppBloc(
    "${baseUrl}/vendor/vendor_account/",
    "${baseUrl}/vendor/vendor_account/",
    "${baseUrl}/vendor/vendor_account/",
    "${baseUrl}/vendor/vendor_account/",
  );
  bool _obscureOld = true;
  bool _obscureNew = true;
  bool _obscureConfirm = true;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) {
        return myBloc;
      },
      child: BlocListener<AppBloc, AppState>(
        listener: (BuildContext context, AppState state) {
          if (state is AppError) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.message)));
          } else if (state is AppSuccess) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.message)));
            Navigator.pop(context);
          } else if (state is AppLoaded) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.data.toString())));
            Navigator.pop(context);
          } else {
            print(state.toString());
          }
        },
        child: Scaffold(
          appBar: AppBar(
            title: const Text("Reset Password"),
            centerTitle: true,
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 30),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 20),

                  /// Old Password
                  _passwordField(
                    controller: _oldPasswordController,
                    label: "Old Password",
                    obscure: _obscureOld,
                    toggle: () {
                      setState(() {
                        _obscureOld = !_obscureOld;
                      });
                    },
                  ),

                  const SizedBox(height: 20),

                  /// New Password
                  _passwordField(
                    controller: _newPasswordController,
                    label: "New Password",
                    obscure: _obscureNew,
                    toggle: () {
                      setState(() {
                        _obscureNew = !_obscureNew;
                      });
                    },
                  ),

                  const SizedBox(height: 20),

                  /// Confirm Password
                  _passwordField(
                    controller: _confirmPasswordController,
                    label: "Confirm Password",
                    obscure: _obscureConfirm,
                    toggle: () {
                      setState(() {
                        _obscureConfirm = !_obscureConfirm;
                      });
                    },
                  ),

                  const SizedBox(height: 30),

                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: () async {
                        if (!_formKey.currentState!.validate()) {
                          return;
                        }

                        if (_newPasswordController.text !=
                            _confirmPasswordController.text) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                "New password and confirm password do not match",
                              ),
                            ),
                          );
                          return;
                        } else {
                          final data = FormData.fromMap({
                            "old_password": _oldPasswordController.text,
                            "new_password": _newPasswordController.text,
                          });
                          myBloc.add(UpdateRequested(data, widget.user_id));
                        }
                      },
                      child: const Text("Update Password"),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// Password Field Widget
  Widget _passwordField({
    required TextEditingController controller,
    required String label,
    required bool obscure,
    required VoidCallback toggle,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: obscure,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return "$label is required";
        }
        if (value.length < 6) {
          return "Password must be at least 6 characters";
        }
        return null;
      },
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
        suffixIcon: IconButton(
          icon: Icon(obscure ? Icons.visibility : Icons.visibility_off),
          onPressed: toggle,
        ),
      ),
    );
  }

  /// Submit Logic

  @override
  void dispose() {
    _oldPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }
}
