import 'dart:async';

import 'package:flutter/material.dart';
import 'package:form_validator/form_validator.dart';
import 'package:homeassist/base/bottom_nav_bar.dart';
import 'package:homeassist/base/components/avatar.dart';
import 'package:homeassist/main.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  bool _isLoading = false;
  late final TextEditingController _usernameController =
      TextEditingController();
  late final TextEditingController _fullNameController =
      TextEditingController();
  late final TextEditingController _addressController = TextEditingController();
  late final TextEditingController _phoneNumberController =
      TextEditingController();

  String? _avatarUrl;
  var _loading = true;

  // Update Profile Function
  Future<void> _updateProfile() async {
    try {
      setState(() {
        _isLoading = true;
      });

      final username = _usernameController.text.trim();
      final fullName = _fullNameController.text.trim();
      final address = _addressController.text.trim();
      final phoneNumber = _phoneNumberController.text.trim();

      if (username.isEmpty ||
          fullName.isEmpty ||
          address.isEmpty ||
          phoneNumber.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Please fill in all fields'),
            backgroundColor: Colors.red,
          ),
        );
        setState(() {
          _isLoading = false;
        });
        return;
      }

      final user = supabase.auth.currentUser;
      if (user != null) {
        final email = user.email; // Fetch the current user's email

        final updates = {
          'id': user.id,
          'username': username,
          'full_name': fullName,
          'email': email, // Include the email in the updates
          'address': address,
          'phone_number': phoneNumber,
          'updated_at': DateTime.now().toIso8601String(),
        };

        await supabase.from('profiles').upsert(updates);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Successfully updated profile!')),
          );
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
                builder: (context) =>
                     MaterialNav()), // Navigate to HomePage
          );
        }
      }
    } on PostgrestException catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(error.message), backgroundColor: Colors.red),
        );
      }
    } catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
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

  /// Called when image has been uploaded to Supabase storage from within Avatar widget
  Future<void> _onUpload(String imageUrl) async {
    try {
      final userId = supabase.auth.currentUser!.id;
      final userEmail = supabase.auth.currentUser!.email;
      await supabase.from('profiles').upsert({
        'id': userId,
        'avatar_url': imageUrl,
        'email': userEmail,
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Updated your profile image and email!')),
        );
      }
    } on PostgrestException catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(error.message), backgroundColor: Colors.red),
        );
      }
    } catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text('Unexpected error occurred'),
              backgroundColor: Colors.red),
        );
      }
    }
    if (!mounted) {
      return;
    }

    setState(() {
      _avatarUrl = imageUrl;
    });
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _fullNameController.dispose();
    _addressController.dispose();
    _phoneNumberController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sign Up'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: ListView(
            shrinkWrap: true,
            padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 12),
            children: [
              const Text(
                'Create a new account',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              Avatar(
                imageUrl: _avatarUrl,
                onUpload: _onUpload,
              ),
              const SizedBox(height: 12),
              TextFormField(
                validator: ValidationBuilder().minLength(4).build(),
                controller: _usernameController,
                decoration: const InputDecoration(
                  labelText: 'Username',
                  hintText: 'Enter your username',
                ),
              ),
              const SizedBox(height: 12),
              TextFormField(
                validator: ValidationBuilder().minLength(4).build(),
                controller: _fullNameController,
                decoration: const InputDecoration(
                  labelText: 'Full Name',
                  hintText: 'Enter your full name',
                ),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _addressController,
                decoration: const InputDecoration(
                  labelText: 'Address',
                  hintText: 'Enter your address',
                ),
              ),
              const SizedBox(height: 12),
              TextFormField(
                validator: ValidationBuilder()
                    .phone()
                    .minLength(10)
                    .maxLength(10)
                    .build(),
                controller: _phoneNumberController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Phone Number',
                  hintText: 'Enter your phone number',
                ),
              ),
              const SizedBox(height: 12),
              ElevatedButton(
                onPressed: _isLoading ? null : _updateProfile,
                child: Text(_isLoading ? 'Updating...' : 'Update Profile'),
              ),
              const SizedBox(height: 12),
            ],
          ),
        ),
      ),
    );
  }
}
