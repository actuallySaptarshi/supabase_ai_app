import 'package:supabase_ai_app/pages/authentication/auth_handler.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MessageTextField extends StatefulWidget {
  final TextEditingController chatController;
  final bool loading;
  const MessageTextField({
    super.key,
    required this.chatController,
    required this.loading,
  });

  @override
  State<MessageTextField> createState() => _MessageTextFieldState();
}

class _MessageTextFieldState extends State<MessageTextField> {
  @override
  Widget build(BuildContext context) {
    bool showIcon = false;

    return StatefulBuilder(
      builder: (context, function) {
        return Row(
          children: [
            Expanded(
              child: TextField(
                onChanged: (value) {
                  function(() {
                    value.isEmpty ? showIcon = false : showIcon = true;
                  });
                },
                controller: widget.chatController,
                cursorColor: Colors.white,
                minLines: 1,
                maxLines: 3,
                style: TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  //Input Field Hint
                  hintText: "Ask Assistant...",
                  hintStyle: TextStyle(color: Colors.grey),
                  //Input Field style
                  filled: true,
                  fillColor: const Color.fromARGB(255, 32, 32, 32),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(50),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),
            widget.loading && mounted
                ? Padding(
                  padding: const EdgeInsets.only(left: 5),
                  child: IconButton.filled(
                    style: FilledButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 0, 18, 152),
                    ),
                    onPressed: () {},
                    icon: Padding(
                      padding: EdgeInsets.all(4),
                      child: CircularProgressIndicator(color: Colors.white),
                    ),
                  ),
                )
                : (showIcon
                    ? Padding(
                      padding: EdgeInsets.only(left: 5),
                      child: IconButton.filled(
                        style: FilledButton.styleFrom(
                          backgroundColor: const Color.fromARGB(
                            255,
                            18,
                            35,
                            184,
                          ),
                        ),
                        color: Colors.grey,
                        onPressed: () async {
                          try {
                            if (widget.chatController.text.isNotEmpty ||
                                widget.chatController.text != "") {
                              await context.read<AuthHandler>().createMessage(
                                widget.chatController.text,
                              );
                              widget.chatController.clear();
                              function(() {
                                widget.chatController.text.isEmpty
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
                            color: const Color.fromARGB(255, 255, 255, 217),
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
                            0,
                            18,
                            152,
                          ),
                        ),
                        onPressed: () {},
                        icon: Padding(
                          padding: EdgeInsets.all(4),
                          child: Icon(
                            Icons.send,
                            color: const Color.fromARGB(255, 71, 71, 71),
                          ),
                        ),
                      ),
                    )),
          ],
        );
      },
    );
  }
}
