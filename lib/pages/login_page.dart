import 'package:flutter/material.dart';
import 'package:realtime_chat_flutter/models/profile.dart';
import 'package:realtime_chat_flutter/pages/rooms_page.dart';
import 'package:realtime_chat_flutter/utils/constants.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  static Route<void> route() {
    return MaterialPageRoute(builder: (context) => const LoginPage());
  }

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool _isLoading = false;
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  Future<void> _signIn() async {
    setState(() {
      _isLoading = true;
    });
    try {
      final AuthResponse res =
          await supabase.auth.signInWithPassword(
        email: _emailController.text,
        password: _passwordController.text,
      );
      final String userId = res.user!.id;
      final profile = await getProfile(userId);
      if (mounted) {
        Navigator.of(context).pushAndRemoveUntil(
            RoomsPage.route(username: profile), (route) => false);
      }
    } on AuthException catch (error) {
      context.showErrorSnackBar(message: error.message);
    } catch (_) {
      context.showErrorSnackBar(message: unexpectedErrorMessage);
    }
    if (mounted) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<Profile?> getProfile(String userId) async {
    final res = await Supabase.instance.client
        .from('profiles')
        .select()
        .eq('id', userId)
        .single();
    return Profile.fromJson(res);
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Sign In')),
      body: ListView(
        padding: formPadding,
        children: [
          TextFormField(
            controller: _emailController,
            decoration: const InputDecoration(labelText: 'Email'),
            keyboardType: TextInputType.emailAddress,
          ),
          spacer,
          TextFormField(
            controller: _passwordController,
            decoration: const InputDecoration(labelText: 'Password'),
            obscureText: true,
          ),
          spacer,
          ElevatedButton(
            onPressed: _isLoading ? null : _signIn,
            child: const Text('Login'),
          ),
        ],
      ),
    );
  }
}
