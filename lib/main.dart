import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:realtime_chat_flutter/splashscreen.dart';
import 'package:realtime_chat_flutter/utils/constants.dart';
import 'package:supabase_flutter/supabase_flutter.dart';


import 'cubits/profiles/profiles_cubit.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: 'https://xnknmrymfwrpjzuakpsd.supabase.co',
    anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Inhua25tcnltZndycGp6dWFrcHNkIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTUxNDk4MDUsImV4cCI6MjA3MDcyNTgwNX0.cvnnOGR9k_sCaLsXHlYFuRaNY8CiW0sDpSlYbKOo7pQ',
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ProfilesCubit>(
      create: (context) => ProfilesCubit(),
      child: MaterialApp(
        title: 'SupaChat',
        debugShowCheckedModeBanner: false,
        theme: appTheme,
        home: const SplashPage(),
      ),
    );
  }
}

