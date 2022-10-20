import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'screnns/home_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
      options: const FirebaseOptions(
          apiKey: "AIzaSyCFseP9lCfqZYz52r4rbrqoBCO4uzO7SXw",
          appId: "1:86878683993:web:e569f92097fd67a0614248",
          messagingSenderId: "86878683993",
          projectId: "pdw-cupom-aba6f"));
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Gerador de cupom',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.purple,
        elevatedButtonTheme: ElevatedButtonThemeData(
            style: ButtonStyle(
                backgroundColor:
                    MaterialStateProperty.all(Colors.deepPurpleAccent))),
      ),
      home: const HomePage(),
    );
  }
}
