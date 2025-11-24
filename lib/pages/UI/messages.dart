import 'package:supabase_ai_app/pages/UI/message_bubble_markdown.dart';
import 'package:supabase_ai_app/pages/authentication/auth_handler.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:provider/provider.dart';

class Messages extends StatefulWidget {
  final int id;
  final TextEditingController chatController;
  const Messages({super.key, required this.id, required this.chatController});

  @override
  State<Messages> createState() => _MessagesState();
}

class _MessagesState extends State<Messages> {
  // A ScrollController to manage the ListView's position.
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    // In initState, we only want to trigger the initial data fetch.
    // We use context.read to call the method without listening for changes here.
    // The StreamBuilder will handle UI updates when new data arrives.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        context.read<AuthHandler>().setChat(id: widget.id);
      }
    });
  }

  @override
  void dispose() {
    // It's crucial to dispose of the controller
    // when the widget is removed from the widget tree to prevent memory leaks.
    _scrollController.dispose();
    super.dispose();
  }

  // A helper function to scroll to the bottom of the message list.
  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      // Add a small delay to ensure the ListView has built before scrolling.
      Future.delayed(const Duration(milliseconds: 100), () {
        if (_scrollController.hasClients) {
          _scrollController.animateTo(
            _scrollController.position.maxScrollExtent,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOut,
          );
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // We use context.read here for event handlers like onPressed
    // because we are dispatching an event, not listening for changes.
    final authHandler = context.read<AuthHandler>();

    return Column(
      children: [
        Expanded(
          // StreamBuilder is the right tool for reacting to a stream of data.
          // It will automatically rebuild its children whenever the stream emits a new value.
          child: StreamBuilder(
            stream: authHandler.streamMessages(id: widget.id),
            builder: (context, snapshot) {
              print("reloaded");
              // When the stream is waiting for data, show a loading indicator.
              if (snapshot.connectionState == ConnectionState.waiting &&
                  !snapshot.hasData) {
                return const Center(
                  child: CircularProgressIndicator(color: Colors.grey),
                );
              }

              // Handle cases where the stream has an error.
              if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              }

              // Handle case where stream is active but has no data (e.g., empty chat).
              if (!snapshot.hasData ||
                  snapshot.data == null ||
                  snapshot.data!.isEmpty) {
                return const Center(
                  child: Text("No messages yet. Start the conversation!"),
                );
              }

              // If we have data, we can extract the messages and loading state.
              final messages = snapshot.data![0]["messages"] as List;
              final isLoading = snapshot.data![0]["loading"] as bool;

              // We need to update the provider with the latest messages
              // without causing a rebuild loop. A post-frame callback is safe.
              WidgetsBinding.instance.addPostFrameCallback((_) {
                if (mounted) {
                  authHandler.messages = List<Map<String, dynamic>>.from(
                    messages,
                  );
                  // Scroll to bottom after the list view builds.
                  _scrollToBottom();
                }
              });

              return Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                      controller: _scrollController,
                      itemCount: messages.length,
                      itemBuilder: (context, index) {
                        final message = messages[index];
                        return Align(
                          alignment:
                              message["role"] == "assistant"
                                  ? Alignment.centerLeft
                                  : Alignment.centerRight,
                          child: MessageBubbleMarkdown(
                            radius:
                                message["role"] == "assistant"
                                    ? const BorderRadius.only(
                                      topLeft: Radius.circular(15),
                                      topRight: Radius.circular(15),
                                      bottomRight: Radius.circular(15),
                                      bottomLeft: Radius.circular(1),
                                    )
                                    : const BorderRadius.only(
                                      topLeft: Radius.circular(15),
                                      topRight: Radius.circular(15),
                                      bottomLeft: Radius.circular(15),
                                      bottomRight: Radius.circular(1),
                                    ),
                            color:
                                (message["role"] == "assistant"
                                    ? const Color.fromARGB(255, 40, 40, 40)
                                    : const Color.fromARGB(255, 30, 42, 149)),
                            text: message["content"] ?? '...',
                          ),
                        );
                      },
                    ),
                  ),
                  // Show a "Thinking..." indicator at the bottom while loading a response.
                  if (isLoading)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const SizedBox(width: 8),
                          Text(
                            "AI Is thinking    ",
                            style: GoogleFonts.beVietnamPro(
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(
                            width: 15,
                            height: 15,
                            child: LoadingIndicator(
                              indicatorType: Indicator.ballPulseSync,
                              strokeWidth: 5,
                              colors: [Colors.grey],
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              );
            },
          ),
        ),
        // This is the chat input area.
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 3, vertical: 2.5),
          // Use StatefulBuilder to manage the state of the send button locally,
          // preventing the entire widget from rebuilding on text changes.
          child: StatefulBuilder(
            builder: (context, setBuilderState) {
              final isSendButtonEnabled = widget.chatController.text.isNotEmpty;

              return Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: widget.chatController,
                      // The onChanged callback triggers a rebuild of just this StatefulBuilder.
                      onChanged: (text) {
                        setBuilderState(() {});
                      },
                      cursorColor: Colors.white,
                      minLines: 1,
                      maxLines: 3,
                      style: GoogleFonts.beVietnamPro(color: Colors.white),
                      decoration: InputDecoration(
                        hintText: "Ask Assistant...",
                        hintStyle: GoogleFonts.beVietnamPro(color: Colors.grey),
                        filled: true,
                        fillColor: const Color.fromARGB(255, 32, 32, 32),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(50),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                  ),
                  // The button's appearance is now declaratively built based on the local state.
                  Padding(
                    padding: const EdgeInsets.only(left: 5),
                    child: IconButton.filled(
                      // Style changes based on whether the button is enabled.
                      style: FilledButton.styleFrom(
                        backgroundColor:
                            isSendButtonEnabled
                                ? const Color.fromARGB(255, 18, 35, 184)
                                : const Color.fromARGB(255, 0, 18, 152),
                      ),
                      // The onPressed callback is null when disabled.
                      onPressed:
                          isSendButtonEnabled
                              ? () async {
                                final text = widget.chatController.text;
                                // Clear the controller and update the UI immediately.
                                widget.chatController.clear();
                                setBuilderState(() {});

                                try {
                                  await authHandler.createMessage(text);
                                  _scrollToBottom();
                                } catch (e) {
                                  if (mounted) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(content: Text('Error: $e')),
                                    );
                                  }
                                  print(e);
                                }
                              }
                              : null,
                      icon: Padding(
                        padding: const EdgeInsets.all(4),
                        child: Icon(
                          Icons.send,
                          color:
                              isSendButtonEnabled
                                  ? const Color.fromARGB(255, 255, 255, 217)
                                  : const Color.fromARGB(255, 71, 71, 71),
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
    );
  }
}
