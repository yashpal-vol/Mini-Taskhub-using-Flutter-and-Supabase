import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'auth/login_screen.dart';
import 'services/supabase_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(
    url: 'https://mpwdymjuvwaxwxuxmukc.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Im1wd2R5bWp1dndheHd4dXhtdWtjIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDUxOTI2NjksImV4cCI6MjA2MDc2ODY2OX0.M4YGGwuouii4QPJ-x8NjTZBP2rXM3172BMp4ghOFDw0',
  );
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => SupabaseService()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mini TaskHub',
      theme: ThemeData.light(),
      home: const LoginScreen(),
    );
  }
}
