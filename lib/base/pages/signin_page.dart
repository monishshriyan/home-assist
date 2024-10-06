import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:form_validator/form_validator.dart';
import 'package:homeassist/base/bottom_nav_bar.dart';
import 'package:homeassist/base/constants.dart';
import 'package:homeassist/base/pages/new_user_signup.dart';
import 'package:homeassist/main.dart';
import 'package:supabase_auth_ui/supabase_auth_ui.dart';

class SigninPage extends StatefulWidget {
  const SigninPage({super.key});

  @override
  State<SigninPage> createState() => _SigninPageState();
}

class _SigninPageState extends State<SigninPage> {
  bool _isLoading = false;
  bool _redirecting = false;
  late final TextEditingController _emailController = TextEditingController();
  late final StreamSubscription<AuthState> _authStateSubscription;

  //Sign In Function
// Sign In Function
  Future<void> _signIn() async {
    try {
      setState(() {
        _isLoading = true;
      });

      // Check if the user exists
      final userExists = await checkUserExists(_emailController.text.trim());
      if (!userExists) {
        // If the user doesn't exist, show an error message
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                  'No account found with this email. Please sign up first.'),
              backgroundColor: Colors.red,
            ),
          );
        }
        setState(() {
          _isLoading = false;
        });
        return;
      }

      // Proceed with sending the magic link if the user exists
      await supabase.auth.signInWithOtp(
        email: _emailController.text.trim(),
        emailRedirectTo:
            kIsWeb ? null : 'io.supabase.flutterquickstart://login-callback/',
      );
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Check your email for a login link!')),
        );

        _emailController.clear();
      }
    } on AuthException catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(error.message), backgroundColor: Colors.red),
        );
      }
    } catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Unexpected error occurred'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  //check if user exists
  Future<bool> checkUserExists(String email) async {
    final response = await supabase
        .from('profiles')
        .select()
        .eq('email', email)
        .maybeSingle();

    if (response == null) {
      // If no data is returned, the user does not exist
      return false;
    }

    return true; // User exists if a response is received
  }

  @override
  void initState() {
    _authStateSubscription = supabase.auth.onAuthStateChange.listen(
      (data) {
        if (_redirecting) return;
        final session = data.session;
        if (session != null) {
          _redirecting = true;
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) =>  MaterialNav()),
          );
        }
      },
      onError: (error) {
        if (error is AuthException) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(error.message), backgroundColor: Colors.red),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
                content: Text('Unexpected error occurred'),
                backgroundColor: Colors.red),
          );
        }
      },
    );
    super.initState();
  }

  //

//dispose function
  @override
  void dispose() {
    _emailController.dispose();
    _authStateSubscription.cancel();
    super.dispose();
  }

  //navigate to signup page
  void _navigateToSignUp() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const NewUserSignup()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text('Sign In'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: ListView(
            shrinkWrap: true,
            padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 12),
            children: [
              const Text(
                'Sign in to your account',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold ,color: Color.fromARGB(255, 5, 21, 2)),
              ),
              const SizedBox(height: 12),
              TextFormField(
                validator: ValidationBuilder().email().maxLength(50).build(),
                controller: _emailController,
                cursorColor: ColorConstants.navBackground,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  hintText: 'Enter your email',
                  labelStyle: TextStyle(color: Color.fromARGB(255, 5, 21, 2)),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Color.fromARGB(255, 5, 21, 2))),
                ),
              ),
              const SizedBox(height: 12),
              ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: ColorConstants.darkSlateGrey),
                onPressed: _isLoading ? null : _signIn,
                child: Text(_isLoading ? 'Sending...' : 'Send Login Link',style: const TextStyle(color: Colors.white,),),
              ),
              const SizedBox(height: 12),
              TextButton(
                style: TextButton.styleFrom(
                  foregroundColor: ColorConstants.deepGreenAccent,
                ),
                onPressed: _navigateToSignUp,
                child: const Text('Don\'t have an account? Sign up'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
