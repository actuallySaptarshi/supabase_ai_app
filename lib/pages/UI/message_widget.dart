import 'package:flutter/material.dart';

class MessageWidget extends StatelessWidget {
  const MessageWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Wrap(
        alignment: WrapAlignment.center,
        children: [
          LandingText(text: "How"),
          LandingText(text: " can"),
          LandingText(text: " I"),
          LandingText(text: " help"),
          LandingText(text: " you"),
          LandingText(text: " today?"),
        ],
      ),
    );
  }
}

class LandingText extends StatelessWidget {
  final String text;

  const LandingText({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        color: Colors.grey,
        fontSize: 50,
        fontWeight: FontWeight.w600,
      ),
    );
  }
}
