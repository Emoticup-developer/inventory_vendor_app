import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'package:image_picker/image_picker.dart';
import 'package:vendors/auth/login.dart';
import 'package:vendors/auth/password.dart';
import 'package:vendors/bloc/my_bloc.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final AppBloc myBloc = AppBloc(
    "${baseUrl}/vendor/vendor_account/",
    "${baseUrl}/vendor/vendor_account/",
    "${baseUrl}/vendor/vendor_account/",
    "${baseUrl}/vendor/vendor_account/",
  );

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => myBloc..add(FetchRequested()),
      child: Scaffold(
        appBar: AppBar(centerTitle: true),
        body: BlocBuilder<AppBloc, AppState>(
          builder: (context, state) {
            if (state is AppLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state is AppError) {
              return Center(child: Text(state.message));
            }

            if (state is AppLoaded) {
              final user = state.data[0];

              return SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 20,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    /// Profile Avatar
                    GestureDetector(
                      onTap: () async {
                        final picker = ImagePicker();
                        final image = await picker.pickImage(
                          source: ImageSource.gallery,
                        );
                        final form = FormData.fromMap({
                          "user_photo": await MultipartFile.fromFile(
                            image!.path,
                          ),
                        });
                        myBloc.add(
                          UpdateRequested(form, user["id"].toString()),
                        );
                      },
                      child: CircleAvatar(
                        backgroundImage: user["user_photo"] != null
                            ? NetworkImage("${baseUrl}${user["user_photo"]}")
                            : null,
                        radius: 60,
                        child: user["user_photo"] == null
                            ? Icon(Icons.person_outline, size: 60)
                            : Text(""),
                      ),
                    ),

                    const SizedBox(height: 20),

                    /// Full Name
                    Text(
                      "${user["first_name"] ?? ""} ${user["last_name"] ?? ""}",
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                      ),
                      textAlign: TextAlign.center,
                    ),

                    const SizedBox(height: 4),

                    /// Username
                    Text(
                      "@${user["username"] ?? ""}",
                      style: const TextStyle(fontSize: 14),
                    ),

                    const SizedBox(height: 30),

                    const Divider(),

                    const SizedBox(height: 16),

                    /// User Information
                    _profileInfoTile(
                      Icons.email_outlined,
                      "Email",
                      user["email"],
                    ),
                    _profileInfoTile(
                      Icons.phone_outlined,
                      "Phone",
                      user["phone_number"],
                    ),

                    const SizedBox(height: 30),

                    const Divider(),

                    const SizedBox(height: 10),

                    /// Change Password
                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: const Icon(Icons.lock_outline),
                      title: const Text("Change Password"),
                      subtitle: const Text("Update your account password"),
                      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                      onTap: () async {
                        await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>  PasswordReset(user_id: user["id"].toString(),),
                          ),
                        );
                      },
                    ),

                    const SizedBox(height: 8),

                    /// Logout
                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: const Icon(Icons.logout_outlined),
                      title: const Text("Logout"),
                      subtitle: const Text("Sign out from your account"),
                      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                      onTap: () => _showLogoutDialog(context),
                    ),
                  ],
                ),
              );
            }

            return const SizedBox();
          },
        ),
      ),
    );
  }

  /// Clean Info Row Widget
  Widget _profileInfoTile(IconData icon, String title, String? value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 2),
                Text(value ?? "", style: const TextStyle(fontSize: 14)),
              ],
            ),
          ),
          GestureDetector(
            onTap: () async {
              await Clipboard.setData(ClipboardData(text: value ?? ""));
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Copied to clipboard")),
              );
            },
            child: Icon(Icons.copy_outlined),
          ),
        ],
      ),
    );
  }

  /// Logout Confirmation Dialog
  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          title: const Text("Confirm Logout"),
          content: const Text("Are you sure you want to logout?"),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () async {
                await Hive.box("auth").clear();
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (_) => const LoginPage()),
                  (route) => false,
                );
              },
              child: const Text("Logout"),
            ),
          ],
        );
      },
    );
  }
}
