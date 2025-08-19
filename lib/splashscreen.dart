import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:realtime_chat_flutter/models/profile.dart';
import 'package:realtime_chat_flutter/pages/register_page.dart';
import 'package:realtime_chat_flutter/pages/rooms_page.dart';
import 'package:realtime_chat_flutter/utils/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// Page to redirect users to the appropriate page depending on the initial auth state
class SplashPage extends StatefulWidget {
  const SplashPage({Key? key}) : super(key: key);

  @override
  SplashPageState createState() => SplashPageState();
}

class SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    getInitialSession();
    super.initState();
  }

  Future<void> getInitialSession() async {
    // quick and dirty way to wait for the widget to mount
    await Future.delayed(Duration.zero);

    try {
      final session = Supabase.instance.client.auth.currentSession;
      if (session == null) {
        Navigator.of(context).pushAndRemoveUntil(
            RegisterPage.route(), (_) => false);
      } else {
        final prefs = await SharedPreferences.getInstance();
        final profileString = prefs.getString('profile');
        if (profileString != null) {
          final profile = Profile.fromJson(jsonDecode(profileString));
          Navigator.of(context).pushAndRemoveUntil(
              RoomsPage.route(), (_) => false);
        } else {
          final userId = Supabase.instance.client.auth.currentUser!.id;
          final profile = await getProfile(userId);
          Navigator.of(context).pushAndRemoveUntil(
              RoomsPage.route(), (_) => false);
        }
      }
    } catch (_) {
      context.showErrorSnackBar(
        message: 'Error occurred during session refresh',
      );
      Navigator.of(context).pushAndRemoveUntil(
          RegisterPage.route(), (_) => false);
    }
  }

  Future<Profile?> getProfile(String userId) async {
    try {
      final res = await Supabase.instance.client
          .from('profiles')
          .select()
          .eq('id', userId)
          .single();
      return Profile.fromJson(res);
    } catch (e) {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: CircularProgressIndicator()),
    );
  }
}
