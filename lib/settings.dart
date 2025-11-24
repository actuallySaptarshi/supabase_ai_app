import 'package:supabase_ai_app/pages/UI/change_password_input.dart';
import 'package:supabase_ai_app/pages/authentication/auth_handler.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:provider/provider.dart';

final _formKey = GlobalKey<FormState>();

class Settings extends StatefulWidget {
  const Settings({super.key});

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  TextStyle font({required FontWeight weight, required double fontSize}) {
    return GoogleFonts.beVietnamPro(
      color: Colors.white,
      fontWeight: weight,
      fontSize: fontSize,
    );
  }

  final authHandler = AuthHandler();

  final displayNameController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  final dropDownFont = GoogleFonts.beVietnamPro(
    color: Colors.white,
    fontWeight: FontWeight.w600,
  );

  final listFontSize = 20.0;

  String userEmail = "Null";
  String displayName = "Null";

  Future<void> getDisplayName() async {
    displayName = await authHandler.getDisplayName();
    userEmail = await authHandler.getEmail();
    setState(() {});
  }

  Future<void> changeName(String name) async {
    displayName = await authHandler.updateDisplayName(name);
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    getDisplayName();
  }

  // Define a constant for the typical IconButton width for balancing
  final double iconButtonWidth = 48.0;
  // Default size for many Material IconButtons
  @override
  void dispose() {
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Future openPasswordDialog() => showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            backgroundColor: const Color.fromARGB(255, 34, 34, 34),
            content: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ChangePasswordInput(
                    labelText: "New Password",
                    controller: passwordController,
                    validator: (text) {
                      if (text!.isNotEmpty) {
                        if (text.length < 8) {
                          return "Password must be of at least 8 characters";
                        } else if (text != confirmPasswordController.text) {
                          return "Passwords do not match";
                        }
                        return null;
                      } else {
                        return "Text Field Cannot be empty";
                      }
                    },
                  ),
                  SizedBox(height: 15),
                  ChangePasswordInput(
                    labelText: "Confirm Password",
                    controller: confirmPasswordController,
                    validator: (text) {
                      if (text!.isNotEmpty) {
                        return null;
                      } else {
                        return "Text Field Cannot be empty";
                      }
                    },
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  passwordController.clear();
                  Navigator.of(context).pop();
                },
                child: Text(
                  "Cancel",
                  style: GoogleFonts.beVietnamPro(color: Colors.white),
                ),
              ),
              TextButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    context
                        .read<AuthHandler>()
                        .changePassword(passwordController.text)
                        .onError(
                          (error, stackTrace) =>
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  behavior: SnackBarBehavior.floating,
                                  content: Text(
                                    "An error occured, Please try again later",
                                  ),
                                ),
                              ),
                        );
                    passwordController.clear();
                    Navigator.of(context).pop();
                  }
                },
                child: Text(
                  "Reset",
                  style: GoogleFonts.beVietnamPro(color: Colors.white),
                ),
              ),
            ],
            title: Text(
              "Change Password",
              style: GoogleFonts.beVietnamPro(color: Colors.white),
            ),
          ),
    );

    Future openNameDialog() => showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            backgroundColor: const Color.fromARGB(255, 34, 34, 34),
            content: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    controller: displayNameController,
                    style: GoogleFonts.beVietnamPro(color: Colors.white),

                    cursorColor: Colors.white,
                    decoration: InputDecoration(
                      hintText: "Max length 20",
                      hintStyle: GoogleFonts.beVietnamPro(color: Colors.grey),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.white),
                      ),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey),
                      ),
                      border: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.white),
                      ),
                    ),
                    validator: (text) {
                      if (text!.isNotEmpty) {
                        final t = text.trim();
                        if (t.isEmpty) {
                          return "Input Field cannot be empty";
                        } else if (t.length > 20) {
                          return "Input length cannot be more than 20";
                        }
                        return null;
                      } else {
                        return "Input Field cannot be empty";
                      }
                    },
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  displayNameController.clear();
                  Navigator.of(context).pop();
                },
                child: Text(
                  "Cancel",
                  style: GoogleFonts.beVietnamPro(color: Colors.white),
                ),
              ),
              TextButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    changeName(displayNameController.text);
                    displayNameController.clear();
                    setState(() {});
                    Navigator.of(context).pop();
                  }
                },
                child: Text(
                  "Reset",
                  style: GoogleFonts.beVietnamPro(color: Colors.white),
                ),
              ),
            ],

            title: Text(
              "Display Name",
              style: GoogleFonts.beVietnamPro(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
    );

    return Padding(
      padding: EdgeInsetsGeometry.symmetric(horizontal: 15),
      child: Column(
        spacing: 20,
        children: [
          SizedBox(height: 70),
          Center(
            child: Text(
              "Welcome,",
              style: GoogleFonts.beVietnamPro(
                color: Colors.white,
                fontSize: 25,
              ),
            ),
          ),
          Row(
            mainAxisAlignment:
                MainAxisAlignment.center, // Centers the entire row
            children: [
              // Add a SizedBox on the left to balance the IconButton on the right.
              // This makes the "User" text appear visually centered.
              SizedBox(width: iconButtonWidth),
              Container(
                constraints: BoxConstraints(
                  maxWidth: MediaQuery.sizeOf(context).width * 0.75,
                ),
                height: 60,
                child: FittedBox(
                  fit: BoxFit.contain,
                  child: Text(
                    displayName,
                    style: GoogleFonts.beVietnamPro(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              IconButton(
                onPressed: () {
                  openNameDialog();
                },
                icon: Icon(Icons.edit, color: Colors.grey),
              ),
            ],
          ),
          SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: Text(
                  "Email:",
                  style: font(
                    weight: FontWeight.normal,
                    fontSize: listFontSize,
                  ),
                ),
              ),
              Text(
                userEmail,
                style: GoogleFonts.beVietnamPro(
                  color: Colors.grey,
                  fontSize: listFontSize,
                ),
              ),
            ],
          ),
          //Change Password Button
          GestureDetector(
            onTap: () => openPasswordDialog(),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    "Change Password:",
                    style: font(
                      weight: FontWeight.normal,
                      fontSize: listFontSize,
                    ),
                  ),
                ),
                Icon(Icons.chevron_right, color: Colors.white),
              ],
            ),
          ),
          /* Row(
            children: [
              Expanded(
                child: Text(
                  "Theme",
                  style: font(
                    weight: FontWeight.normal,
                    fontSize: listFontSize,
                  ),
                ),
              ),
              DropdownButtonHideUnderline(
                child: DropdownButton(
                  dropdownColor: const Color.fromARGB(255, 51, 51, 51),
                  icon: Icon(
                    Icons.keyboard_arrow_down_outlined,
                    color: Colors.white,
                  ),
                  iconSize: 30,
                  borderRadius: BorderRadius.circular(15),
                  items: [
                    DropdownMenuItem(child: Text("Dark", style: dropDownFont)),
                  ],
                  onChanged: (value) {},
                ),
              ),
            ],
          ) */
          GestureDetector(
            onTap: () async {
              await context.read<AuthHandler>().logout();
              if (mounted) {
                context.go("/");
              }
            },
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    "Logout",
                    style: font(
                      weight: FontWeight.normal,
                      fontSize: listFontSize,
                    ),
                  ),
                ),
                Icon(EvaIcons.log_out_outline, color: Colors.red),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
