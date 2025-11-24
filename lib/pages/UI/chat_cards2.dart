import 'package:supabase_ai_app/pages/authentication/auth_handler.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:provider/provider.dart';

class ChatCards2 extends StatelessWidget {
  final int route;
  final String text;
  final Function()? state;
  const ChatCards2({super.key, required this.text, required this.route, this.state});

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
        decoration: BoxDecoration(),
        margin: EdgeInsets.symmetric(horizontal: 5),
        child: SizedBox(
          height: 70,
          child: Padding(
            padding: EdgeInsets.only(left: 10, right: 5),
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
                SizedBox(
                  height: 40,
                  width: 40,
                  child: IconButton(
                    onPressed: () async {
                      context.read<AuthHandler>().deleteChat(id: route);
                    },

                    icon: Icon(
                      MingCute.delete_2_fill,
                      color: const Color.fromARGB(255, 139, 38, 30),
                      size: 20,
                    ),
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
