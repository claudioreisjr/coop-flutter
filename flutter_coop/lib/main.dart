import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'pages/clima_page.dart';
import 'pages/eventos_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
   if (kIsWeb) {
    await Firebase.initializeApp(
      options: const FirebaseOptions(
         apiKey: "AIzaSyC7n33UQHDQCcCHOAlSGZ24gV2ehE_HeCY",
         authDomain: "coop-df2d1.firebaseapp.com",
         projectId: "coop-df2d1",
         storageBucket: "coop-df2d1.firebasestorage.app",
         messagingSenderId: "119496410804",
         appId: "1:119496410804:web:d9a51d1ca4f6aaa54ef9e1"
      ),
    );
  } else {
    // Android / iOS usam google-services.json automaticamente
    await Firebase.initializeApp();
  }  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'COOP APP',
      home: const HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("COOP"),
        backgroundColor: Colors.green,
      ),

      drawer: Drawer(
        child: ListView(
          children: [
            DrawerHeader(
              decoration: const BoxDecoration(color: Colors.green),
              child: const Text("Menu", style: TextStyle(color: Colors.white, fontSize: 20)),
            ),
            ListTile(
              title: const Text("🌤️ Clima"),
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const ClimaPage()),
              ),
            ),
            ListTile(
              title: const Text("📅 Eventos"),
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const EventosPage()),
              ),
            ),
          ],
        ),
      ),

      body: const Center(
        child: Text(
          "Bem-vindo ao COOP!",
          style: TextStyle(fontSize: 22),
        ),
      ),
    );
  }
}
