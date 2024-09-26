import 'package:flutter/material.dart';
import 'package:form_validator/form_validator.dart';
import 'package:homeassist/base/components/avatar.dart';
import 'package:homeassist/base/constants.dart';
import 'package:homeassist/base/pages/login_page.dart';
import 'package:homeassist/main.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AccountPage extends StatefulWidget {
  const AccountPage({super.key});

  @override
  State<AccountPage> createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  final _usernameController = TextEditingController();
  final _fullNameController = TextEditingController();
  final _phoneNumberController = TextEditingController();

  String? _avatarUrl;
  var _loading = true;

  /// Called once a user id is received within `onAuthenticated()`
  Future<void> _getProfile() async {
    setState(() {
      _loading = true;
    });

    try {
      final userId = supabase.auth.currentSession!.user.id;
      final data =
          await supabase.from('profiles').select().eq('id', userId).single();
      _usernameController.text = (data['username'] ?? '') as String;
      _fullNameController.text = (data['full_name'] ?? '') as String;
      _phoneNumberController.text = (data['phone_number']?? '') as String;
      _avatarUrl = (data['avatar_url'] ?? '') as String;
    } on PostgrestException catch (error) {
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
              backgroundColor: Colors.red),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _loading = false;
        });
      }
    }
  }

  /// Called when user taps `Update` button
  Future<void> _updateProfile() async {
    setState(() {
      _loading = true;
    });
    final userName = _usernameController.text.trim();
    final fullName = _fullNameController.text.trim();
    final phoneNumber = _phoneNumberController.text.trim();
    final user = supabase.auth.currentUser;
    final updates = {
      'id': user!.id,
      'username': userName,
      'full_name': fullName,
      'phone_number': phoneNumber,
      'updated_at': DateTime.now().toIso8601String(),
    };
    try {
      await supabase.from('profiles').upsert(updates);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Successfully updated profile!')),
        );
        // Navigator.of(context).pushReplacementNamed(
        //     '/home'); // Navigate to home after profile update
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
          const SnackBar(
              content: Text('Unexpected error occurred'),
              backgroundColor: Colors.red),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _loading = false;
        });
      }
    }
  }


  /// Called when image has been uploaded to Supabase storage from within Avatar widget
  Future<void> _onUpload(String imageUrl) async {
    try {
      final userId = supabase.auth.currentUser!.id;
      await supabase.from('profiles').upsert({
        'id': userId,
        'avatar_url': imageUrl,
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Updated your profile image!')),
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
          const SnackBar(
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
  void initState() {
    super.initState();
    _getProfile();
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _fullNameController.dispose();
    _phoneNumberController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      body: ListView(
        padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 12),
        children: [
          Avatar(
            imageUrl: _avatarUrl,
            onUpload: _onUpload,
          ),
          const SizedBox(height: 18),
          TextFormField(
            validator: ValidationBuilder().minLength(4).build(),
            controller: _usernameController,
            decoration: const InputDecoration(labelText: 'User Name',
            labelStyle: TextStyle(color: Color.fromARGB(255, 5, 21, 2)),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Color.fromARGB(255, 5, 21, 2)))
            ),
          ),
          const SizedBox(height: 18),
          TextFormField(
            validator: ValidationBuilder().minLength(4).build(),
            controller: _fullNameController,
            decoration: const InputDecoration(labelText: 'Full Name',
            labelStyle: TextStyle(color: Color.fromARGB(255, 5, 21, 2)),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Color.fromARGB(255, 5, 21, 2)))
            ),
          ),
          const SizedBox(height: 18),
          TextFormField(
            validator: ValidationBuilder()
                    .phone()
                    .minLength(10)
                    .maxLength(10)
                    .build(),
            controller: _phoneNumberController,
            decoration: const InputDecoration(labelText: 'Phone Number',
                  labelStyle: TextStyle(color: Color.fromARGB(255, 5, 21, 2)),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Color.fromARGB(255, 5, 21, 2)))),
          ),
          const SizedBox(height: 30),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: ColorConstants.darkSlateGrey),
            onPressed: _loading ? null : _updateProfile,
            child: Text(_loading ? 'Saving...' : 'Update',style: const TextStyle(color: Colors.white,fontSize: 18)),
          ),
          const SizedBox(height: 18),
        ],
      ),
    );
  }
}
