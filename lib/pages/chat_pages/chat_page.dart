import 'package:supabase_ai_app/pages/UI/messages.dart';
import 'package:supabase_ai_app/pages/authentication/auth_handler.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class ChatPage extends StatefulWidget {
  final String id;

  const ChatPage({super.key, required this.id});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final supabase = AuthHandler();
  bool showIcon = false;

  final _chatController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    if (widget.id == "") {
      return PopScope(
        canPop: false,
        //Back gesture
        onPopInvokedWithResult: (didPop, result) {
          print(didPop);
          context.read<AuthHandler>().reset();
          context.push("/home");
        },
        child: Scaffold(
          backgroundColor: Colors.black,
          appBar: AppBar(
            centerTitle: true,
            //Back Button
            leading: IconButton(
              onPressed: () async {
                context.read<AuthHandler>().reset();
                context.push("/home");
              },
              icon: Icon(Icons.arrow_back_ios_new, color: Colors.white),
              iconSize: 25,
            ),
            backgroundColor: Colors.black,
            title: Text(
              "Supabase AI Chat",
              style: GoogleFonts.beVietnamPro(
                color: Colors.white,
                fontSize: 35,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          body: Center(child: Text("404 Page does not exist")),
        ),
      );
    } else {
      return PopScope(
        canPop: false,
        //Back button using back function
        onPopInvokedWithResult: (didPop, result) async {
          print(didPop);
          context.read<AuthHandler>().reset();
          context.push("/home");
        },
        child: Scaffold(
          backgroundColor: Colors.black,
          appBar: AppBar(
            centerTitle: true,
            //Back Icon
            leading: IconButton(
              onPressed: () async {
                context.read<AuthHandler>().reset();
                //super.deactivate();
                context.push("/home");
              },
              icon: Icon(Icons.arrow_back_ios_new, color: Colors.white),
              iconSize: 25,
            ),
            backgroundColor: Colors.black,
            title: Text(
              "Supabase AI Chat",
              style: GoogleFonts.beVietnamPro(
                color: Colors.white,
                fontSize: 35,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          body: SafeArea(
            child: Messages(
              id: int.parse(widget.id),
              chatController: _chatController,
            ),
          ),
        ),
      );
    }
  }
}

/*IconButton(
                        onPressed: () async {
                          try {
                            if (_chatController.text.isNotEmpty ||
                                _chatController.text != "") {
                              await context.read<AuthHandler>().createMessage(
                                _chatController.text,
                              );
                              _chatController.clear();
                              print("Done");
                              /*Future.delayed(Duration(milliseconds: 500), () {
                              _scrollController.animateTo(
                                _scrollController.position.maxScrollExtent,
                                duration: Duration(milliseconds: 500),
                                curve: Curves.easeOut,
                              );
                            });*/
                            }
                          } catch (e) {
                            print(e);
                          }
                        },
                        icon: Icon(
                          Icons.send,
                          color: const Color.fromARGB(255, 255, 255, 217),
                        ),
                      ),*/
