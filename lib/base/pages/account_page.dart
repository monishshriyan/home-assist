import 'package:flutter/material.dart';
import 'package:form_validator/form_validator.dart';
import 'package:homeassist/base/components/avatar.dart';
import 'package:homeassist/base/constants.dart';
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
      _phoneNumberController.text = (data['phone_number'] ?? '') as String;
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
      'email': user.email, // Add the email to the updates map
      'updated_at': DateTime.now().toIso8601String(),
    };
    try {
      await supabase.from('profiles').upsert(updates);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Successfully updated profile!')),
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
      final userEmail = supabase.auth.currentUser!.email;
      await supabase.from('profiles').upsert({
        'id': userId,
        'avatar_url': imageUrl,
        'email': userEmail,
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Image updated!')),
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
      appBar: AppBar(
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
        title: const Text(
          'Edit Profile',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        backgroundColor: ColorConstants.darkSlateGrey,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Avatar(
              imageUrl: _avatarUrl,
              onUpload: _onUpload,
            ),
            const SizedBox(height: 32),
            _buildTextFormField(
              controller: _usernameController,
              label: 'User Name',
              validator: ValidationBuilder().minLength(4).build(),
            ),
            const SizedBox(height: 16),
            _buildTextFormField(
              controller: _fullNameController,
              label: 'Full Name',
              validator: ValidationBuilder().minLength(4).build(),
            ),
            const SizedBox(height: 16),
            _buildTextFormField(
              controller: _phoneNumberController,
              label: 'Phone Number',
              keyboardType: TextInputType.phone,
              validator: ValidationBuilder().phone().minLength(10).build(),
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: _loading ? null : _updateProfile,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                backgroundColor: ColorConstants.darkSlateGrey,
              ),
              child: Text(
                _loading ? 'Saving...' : 'Update',
                style: Theme.of(context)
                    .textTheme
                    .labelLarge
                    ?.copyWith(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextFormField({
    required TextEditingController controller,
    required String label,
    required String? Function(String?) validator,
    TextInputType? keyboardType,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      validator: validator,
      cursorColor: ColorConstants.darkSlateGrey,
      decoration: InputDecoration(
        hintStyle: TextStyle(
          color: ColorConstants.textLightGrey,
        ),
        focusColor: ColorConstants.darkSlateGrey,
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
              color: ColorConstants.darkSlateGrey,
              width: 1), // Change this to the desired focus color
        ),
        labelText: label,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }
}
