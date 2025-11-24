import 'package:supabase_ai_app/pages/UI/message_widget.dart';
import 'package:supabase_ai_app/pages/UI/messages.dart';
import 'package:supabase_ai_app/pages/authentication/auth_handler.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class NewChatPage extends StatefulWidget {
  const NewChatPage({super.key});

  @override
  State<NewChatPage> createState() => _NewChatPageState();
}

class _NewChatPageState extends State<NewChatPage> {
  int id = -1;
  bool showIcon = false;

  @override
  Widget build(BuildContext context) {
    final chatController = TextEditingController();

    if (context.watch<AuthHandler>().currentChat == -1) {
      return PopScope(
        canPop: false,
        onPopInvokedWithResult: (didPop, result) {
          print(didPop);
          context.read<AuthHandler>().reset();
          context.push("/home");
        },
        child: Scaffold(
          backgroundColor: Colors.black,
          appBar: AppBar(
            centerTitle: true,
            leading: IconButton(
              onPressed: () {
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
          body: SafeArea(
            child: Column(
              children: [
                //Message Area
                Expanded(child: const MessageWidget()),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 3, vertical: 10),
                  //Chat Input Field
                  child: StatefulBuilder(
                    builder: (context, function) {
                      return Row(
                        children: [
                          Expanded(
                            child: TextField(
                              onChanged: (value) {
                                function(() {
                                  value.isEmpty
                                      ? showIcon = false
                                      : showIcon = true;
                                });
                              },
                              controller: chatController,
                              cursorColor: Colors.white,
                              minLines: 1,
                              maxLines: 3,
                              style: GoogleFonts.beVietnamPro(
                                color: Colors.white,
                              ),
                              decoration: InputDecoration(
                                //Input Field Hint
                                hintText: "Ask Assistant...",
                                hintStyle: GoogleFonts.beVietnamPro(
                                  color: Colors.grey,
                                ),
                                //Input Field style
                                filled: true,
                                fillColor: const Color.fromARGB(
                                  255,
                                  32,
                                  32,
                                  32,
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(50),
                                  borderSide: BorderSide.none,
                                ),
                              ),
                            ),
                          ),
                          showIcon
                              ? Padding(
                                padding: EdgeInsets.only(left: 5),
                                child: IconButton.filled(
                                  style: FilledButton.styleFrom(
                                    backgroundColor: const Color.fromARGB(
                                      255,
                                      30,
                                      42,
                                      149,
                                    ),
                                  ),
                                  color: Colors.grey,
                                  onPressed: () async {
                                    try {
                                      if (chatController.text.isNotEmpty ||
                                          chatController.text != "") {
                                        await context
                                            .read<AuthHandler>()
                                            .createMessage(chatController.text);
                                        chatController.clear();
                                        function(() {
                                          chatController.text.isEmpty
                                              ? showIcon = false
                                              : showIcon = true;
                                        });
                                        print("Done");
                                      }
                                    } catch (e) {
                                      print(e);
                                    }
                                  },
                                  icon: Padding(
                                    padding: EdgeInsets.all(4),
                                    child: Icon(
                                      Icons.send,
                                      color: const Color.fromARGB(
                                        255,
                                        255,
                                        255,
                                        217,
                                      ),
                                    ),
                                  ),
                                ),
                              )
                              : Padding(
                                padding: const EdgeInsets.only(left: 5),
                                child: IconButton.filled(
                                  style: FilledButton.styleFrom(
                                    backgroundColor: const Color.fromARGB(
                                      255,
                                      15,
                                      22,
                                      74,
                                    ),
                                  ),
                                  onPressed: () {},
                                  icon: Padding(
                                    padding: EdgeInsets.all(4),
                                    child: Icon(
                                      Icons.send,
                                      color: const Color.fromARGB(
                                        255,
                                        71,
                                        71,
                                        71,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                        ],
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    } else {
      return PopScope(
        canPop: false,
        onPopInvokedWithResult: (didPop, result) {
          print(didPop);
          context.read<AuthHandler>().reset();
          context.push("/home");
        },
        child: Scaffold(
          backgroundColor: Colors.black,
          appBar: AppBar(
            centerTitle: true,
            leading: IconButton(
              onPressed: () {
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
          body: SafeArea(
            child: Messages(
              id: context.watch<AuthHandler>().currentChat,
              chatController: chatController,
            ),
          ),
        ),
      );
    }
  }
}
