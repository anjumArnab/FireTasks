import 'package:flutter/material.dart';
import 'package:firetasks/screens/homepage.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  runApp(const FireTasks());
}

class FireTasks extends StatelessWidget {
  const FireTasks({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FireTasks',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        textTheme: GoogleFonts.poppinsTextTheme()
      ),
      home: const HomePage(),
    );
  }
}