import 'package:supabase_ai_app/pages/authentication/auth_handler.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class ChatCards extends StatelessWidget {
  final int route;
  final String text;
  final Function()? state;
  const ChatCards({super.key, required this.text, required this.route, this.state});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      /*decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(color: Colors.grey, offset: Offset.fromDirection(40)),
        ],
      ), */
      onTap: () {
        state!();
        context.read<AuthHandler>().setChat(id: route);
        context.go("/chat/$route");
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: const Color.fromARGB(255, 17, 17, 17),
          border: Border.all(
            color: const Color.fromARGB(70, 77, 77, 77),
            width: 1,
            style: BorderStyle.solid,
          ),
        ),
        margin: EdgeInsets.symmetric(horizontal: 12),
        child: SizedBox(
          height: 80,
          child: Padding(
            padding: EdgeInsets.only(left: 20, right: 5),
            child: Row(
              children: [
                Expanded(
                  child: FittedBox(
                    alignment: Alignment.centerLeft,
                    fit: BoxFit.scaleDown,
                    child: Text(
                      text.length >= 25 ? "${text.substring(0, 25)}..." : text,
                      style: GoogleFonts.beVietnamPro(
                        color: Colors.white,
                        fontSize: 20,
                      ),
                      //TextStyle(fontSize: 20, color: Colors.white),
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () async {
                    context.read<AuthHandler>().deleteChat(id: route);
                  },
                  icon: Icon(
                    Icons.delete_outline,
                    color: const Color.fromARGB(255, 82, 34, 31),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}


/*
Text(
                  text.length >= 25 ? "${text.substring(0, 25)}..." : text,
                  style: TextStyle(
                    fontSize: 25,
                    color: Colors.white,
                    fontWeight: FontWeight.w400,
                  ),
                ),
*/

/*
IconButton(
                      onPressed: () async {
                        context.read<AuthHandler>().deleteChat(id: route);
                      },
                      icon: Icon(Icons.delete, color: Colors.grey),
                    ),
*/