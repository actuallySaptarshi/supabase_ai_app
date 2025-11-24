import 'package:supabase_ai_app/pages/UI/chat_cards2.dart';
import 'package:supabase_ai_app/pages/authentication/auth_handler.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:text_divider/text_divider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    print("Init state called");
    super.initState();
  }

  final supabase = AuthHandler();
  final bodyTextStyle = GoogleFonts.beVietnamPro(color: Colors.white);

  DateTime time = DateTime.now();
  bool canPop = false;

  //New Message Widget
  final newMessage = Card.filled(
    margin: EdgeInsets.symmetric(horizontal: 12),
    color: const Color.fromARGB(255, 19, 19, 19),
    child: SizedBox(
      height: 100,
      child: Align(
        alignment: Alignment.centerLeft,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            children: [
              Text(
                "New Chat",
                style: GoogleFonts.beVietnamPro(
                  fontSize: 30,
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Expanded(
                child: Align(
                  alignment: Alignment.centerRight,
                  child: Icon(Icons.add_circle, color: Colors.grey, size: 50),
                ),
              ),
            ],
          ),
        ),
      ),
    ),
  );

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: canPop,
      onPopInvokedWithResult: (didPop, result) async {
        final difference = DateTime.now().difference(time);
        if (difference >= Duration(seconds: 2) && !didPop) {
          print(result);
          setState(() {
            Fluttertoast.showToast(
              msg: "Press Back again to exit",
              gravity: ToastGravity.NONE,
            );
            canPop = true;
          });
        } else {
          setState(() {
            Fluttertoast.cancel();
            canPop = false;
          });
        }
      },
      child: Scaffold(
        //Drawer
        drawer: Drawer(
          backgroundColor: const Color.fromARGB(255, 23, 23, 23),
          child: SafeArea(
            child: ListView(
              padding: EdgeInsets.only(left: 10),
              children: [
                SizedBox(height: 20),
                ListTile(
                  //Account Tile
                  leading: Icon(Icons.account_circle, color: Colors.grey),
                  title: Text(
                    "Account",
                    style: GoogleFonts.beVietnamPro(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                ),
                //Logout Tile
                ListTile(
                  leading: Icon(Icons.logout_outlined, color: Colors.grey),
                  onTap: () async {
                    await supabase.logout();
                    if (mounted) context.go("/");
                  },
                  title: Text(
                    "Logout",
                    style: GoogleFonts.beVietnamPro(color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        ),
        //App Background Colour
        backgroundColor: Colors.black,
        //Appbar
        appBar: AppBar(
          centerTitle: true,
          //App Bar Icon
          leading: Builder(
            builder: (BuildContext context) {
              return IconButton(
                icon: const Icon(Icons.menu, color: Colors.white, size: 30),
                onPressed: () {
                  Scaffold.of(context).openDrawer();
                },
                tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
              );
            },
          ),
          backgroundColor: Colors.black,
          title: Text(
            "Supabase Chat",
            style: GoogleFonts.beVietnamPro(
              color: Colors.white,
              fontSize: 35,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        //TODO: Make a floating action button to make scrollable new message
        /*  floatingActionButton: FloatingActionButton.extended(
        backgroundColor: const Color.fromARGB(255, 69, 69, 69),
        onPressed: () {},
        label: Text(
          "New Message",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
        ),
        icon: Icon(Icons.message, color: Colors.white),
      ), // */
        //Main body
        body: ListView(
          // Use a single ListView for the entire body
          children: [
            SizedBox(height: 40),
            GestureDetector(
              onTap: () async {
                await context.read<AuthHandler>().reset();
                if (mounted) {
                  context.go("/chat");
                }
              },
              child: newMessage,
            ),
            SizedBox(height: 30),

            TextDivider(
              thickness: 1,
              color: const Color.fromARGB(255, 78, 78, 78),
              text: Text(
                "Chat History",
                style: GoogleFonts.beVietnamPro(color: Colors.white),
              ),
            ),

            //SizedBox(height: 5),

            // Remove the Expanded here, ListView does not need Expanded children
            // Column is also not needed as ListView can directly contain the StreamBuilder logic
            StreamBuilder(
              stream: context.watch<AuthHandler>().streamFunction(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Center(
                    child: SizedBox(
                      height: 50,
                      width: 50,
                      child: CircularProgressIndicator(color: Colors.grey),
                    ),
                  );
                } else if (snapshot.data!.isEmpty) {
                  return Align(
                    alignment: Alignment.topCenter,
                    child: Text(
                      "Create a new message to see chat history",
                      style: GoogleFonts.beVietnamPro(color: Colors.grey),
                    ),
                  );
                }
                if (snapshot.hasError) {
                  return Align(
                    alignment: Alignment.topCenter,
                    child: Text(
                      "An error occured, please try again later",
                      style: GoogleFonts.beVietnamPro(color: Colors.grey),
                    ),
                  );
                } else {
                  // Use ListView.builder with shrinkWrap: true inside the main ListView
                  return ListView.builder(
                    shrinkWrap: true,
                    physics:
                        NeverScrollableScrollPhysics(), // Disable inner scrolling
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      return ChatCards2(
                        state: () {
                          setState(() {
                            canPop = false;
                          });
                        },
                        text: snapshot.data![index]["name"],
                        route: snapshot.data![index]["id"],
                      );
                    },
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}

/* Center(
              child: ElevatedButton(
                onPressed: () {
                  try {
                    authHandler.fetchData();
                  } catch (e) {
                    print(e);
                  }
                },
                child: Text("Return List"),
              ),
            ),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  try {
                    authHandler.createMessage();
                  } catch (e) {
                    print(e);
                  }
                },
                child: Text("Create Message"),
              ),
            ), */
