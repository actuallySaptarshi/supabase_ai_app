import 'package:supabase_ai_app/pages/UI/password_text_input.dart';
import 'package:supabase_ai_app/pages/authentication/auth_handler.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

final _formKey = GlobalKey<FormState>();

//Google Icon SVG
const String googleIcon = 'lib/Icons/google_icon.svg';
final Widget svg = SvgPicture.asset(googleIcon, semanticsLabel: 'Google Icon');

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final authHandler = AuthHandler();

  final _emailController = TextEditingController();

  final _passwordController = TextEditingController();

  //Input Decoration of Input Fields
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

                  //Login Screen Text
                  Text(
                    "Login",
                    style: TextStyle(fontSize: 25, color: Colors.white),
                  ),

                  SizedBox(height: 20),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 40),

                    //Form Control
                    child: Form(
                      key: _formKey,
                      child: Column(
                        //Email Input
                        children: [
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
                          //Register User Button
                          Align(
                            alignment: Alignment.topLeft,
                            child: TextButton(
                              onPressed: () {
                                context.go('/signup');
                              },
                              child: Text(
                                "Register a new User",
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
                            //Submit Button On Pressed Function
                            onPressed: () async {
                              if (_formKey.currentState!.validate() &&
                                  mounted) {
                                try {
                                  await context.read<AuthHandler>().login(
                                    _emailController.text,
                                    _passwordController.text,
                                  );
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text("Success")),
                                  );
                                  context.go("/");
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
                                  "Login",
                                  //Elevated Button Text Style
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          //Logout Button (For Testing Purposes only)
                          /*
                          TextButton(
                            onPressed: () async {
                              authHandler.logout();
                            },
                            child: Text("Logout"),
                          ),
                          SizedBox(height: 130),
                          */
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
                            onPressed: () async {
                              try {
                                await authHandler.signInWithGoogle();
                                if (mounted) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text("Logged in Successfully!"),
                                    ),
                                  );
                                  context.go("/");
                                }
                              } catch (e) {
                                if (mounted) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text(e.toString())),
                                  );
                                }
                              }
                            },
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
                          ), // */
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
