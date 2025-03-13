import 'package:firebase_core/firebase_core.dart';
import 'package:firetasks/firebase_options.dart';
import 'package:firetasks/providers/auth_provider.dart';
import 'package:firetasks/providers/task_provider.dart';
import 'package:firetasks/providers/user_provider.dart';
import 'package:firetasks/screens/homepage.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

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
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => UserProvider()),
        ChangeNotifierProvider(create: (_) => TaskProvider()),
      ],
      child: MaterialApp(
        title: 'FireTasks',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          textTheme: GoogleFonts.poppinsTextTheme()
        ),
        home: const HomePage(),
      ),
    );
  }
}