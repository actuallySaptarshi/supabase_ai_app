import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:google_fonts/google_fonts.dart';

class MessageBubbleMarkdown extends StatelessWidget {
  final Color? color;
  final String text;
  final BorderRadius radius;

  const MessageBubbleMarkdown({
    super.key,
    required this.text,
    this.color,
    required this.radius,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(
        maxWidth: MediaQuery.sizeOf(context).width * 0.85,
      ),
      margin: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
      padding: EdgeInsets.symmetric(vertical: 12, horizontal: 17),
      decoration: BoxDecoration(color: color, borderRadius: radius),
      child: MarkdownBody(
        data: text,
        styleSheet: MarkdownStyleSheet(
          h1: GoogleFonts.beVietnamPro(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
          h2: GoogleFonts.beVietnamPro(
            color: Colors.white,
            fontWeight: FontWeight.w500,
          ),
          h3: GoogleFonts.beVietnamPro(
            color: Colors.white,
            fontWeight: FontWeight.w500,
          ),
          h4: GoogleFonts.beVietnamPro(
            color: Colors.white,
            fontWeight: FontWeight.w500,
          ),
          h5: GoogleFonts.beVietnamPro(
            color: Colors.white,
            fontWeight: FontWeight.w500,
          ),
          h6: GoogleFonts.beVietnamPro(
            color: Colors.white,
            fontWeight: FontWeight.w500,
          ),
          p: GoogleFonts.beVietnamPro(
            fontSize: 18,
            fontWeight: FontWeight.w400,
            color: Colors.white,
          ),
          a: GoogleFonts.beVietnamPro(color: Colors.white),
          code: GoogleFonts.beVietnamPro(
            color: Colors.white,
            backgroundColor: Colors.black,
          ),
          listBullet: GoogleFonts.beVietnamPro(color: Colors.white),
          strong: GoogleFonts.beVietnamPro(
            color: Colors.white,
            fontWeight: FontWeight.w900,
          ),
        ),
      ),
    );
  }
}
