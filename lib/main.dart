import 'package:firebase_core/firebase_core.dart';
import 'package:firetasks/firebase_options.dart';
import 'package:flutter/material.dart';
import 'package:firetasks/screens/homepage.dart';
import 'package:google_fonts/google_fonts.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
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