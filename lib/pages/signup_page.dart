import 'package:supabase_ai_app/pages/UI/password_text_input.dart';
import 'package:supabase_ai_app/pages/authentication/auth_handler.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';

final _formKey = GlobalKey<FormState>();

//Google Icon SVG
const String googleIcon = 'lib/pages/Icons/google_icon.svg';
final Widget svg = SvgPicture.asset(googleIcon, semanticsLabel: 'Google Icon');

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final authHandler = AuthHandler();

  //Text Input Controllers
  final _emailController = TextEditingController();

  final _passwordController = TextEditingController();

  InputDecoration inputFieldDecoration(String hint) {
    return InputDecoration(
      labelText: hint,
      labelStyle: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(
          color: const Color.fromARGB(255, 161, 161, 161),
          width: 2,
        ),
        borderRadius: BorderRadius.circular(10),
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(color: const Color.fromARGB(255, 61, 61, 61)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: ListView(
          children: [
            Center(
              child: Column(
                children: [
                  Padding(padding: EdgeInsets.only(top: 100)),
                  //Logo
                  Text(
                    "Supabase AI Chat",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 50,
                      fontWeight: FontWeight.w700,
                    ),
                  ),

                  SizedBox(height: 50),

                  //Sign Up Screen Text
                  Text(
                    "Sign up",
                    style: TextStyle(fontSize: 25, color: Colors.white),
                  ),

                  SizedBox(height: 20),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 40),

                    //Form Control
                    child: Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          //Email Input
                          TextFormField(
                            cursorColor: Colors.grey,
                            controller: _emailController,
                            style: TextStyle(color: Colors.white),
                            decoration: inputFieldDecoration("Email"),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "Input field cannot be empty";
                              }
                              return null;
                            },
                          ),
                          SizedBox(height: 10),

                          //Password Input
                          PasswordTextInput(
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "Input field cannot be empty";
                              } else if (value.length < 8) {
                                return "Password length cannot be less than 8";
                              }
                              return null;
                            },
                            labelText: "Password",
                            controller: _passwordController,
                          ),
                          SizedBox(height: 10),
                          //Confirm Password
                          PasswordTextInput(
                            labelText: "Confirm Password",
                            controller: null,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "Input field cannot be empty";
                              } else if (value.length < 8) {
                                return "Password length cannot be less than 8";
                              } else if (value != _passwordController.text) {
                                return "Password and confirm password do not match";
                              }
                              return null;
                            },
                          ),

                          //Login To an Existing User Button
                          Align(
                            alignment: Alignment.topLeft,
                            child: TextButton(
                              onPressed: () {
                                context.go("/login");
                              },
                              child: Text(
                                "Login to an existing User",
                                style: TextStyle(
                                  color: const Color.fromARGB(
                                    255,
                                    113,
                                    113,
                                    113,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 10),
                          //Submit Button
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            //On Pressed Function
                            onPressed: () async {
                              if (_formKey.currentState!.validate() &&
                                  mounted) {
                                try {
                                  await authHandler.createAccount(
                                    _emailController.text,
                                    _passwordController.text,
                                  );
                                  if (mounted) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(
                                          "Account Created Successfully, please login to continue",
                                        ),
                                      ),
                                    );
                                    context.go("/login");
                                  }
                                } catch (e) {
                                  print(e);
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text(e.toString())),
                                  );
                                }
                              }
                            },
                            child: SizedBox(
                              width: 200,
                              child: Center(
                                child: Text(
                                  "Create Account",
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 20),
                          //Sign In With Google Button
                          /*
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color.fromARGB(
                                255,
                                26,
                                26,
                                26,
                              ),
                              maximumSize: Size(290, 500),
                            ),
                            onPressed: () {},
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8),
                                  child: svg,
                                ),
                                SizedBox(width: 7),
                                Text(
                                  "Sign in with Google",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20,
                                  ),
                                ),
                              ],
                            ),
                          ), */
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
