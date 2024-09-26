import 'package:flutter/material.dart';
import 'package:homeassist/base/constants.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  String? userEmail;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadUserEmail();
  }
  
  Future<void> _signOut() async {
    try {
      await Supabase.instance.client.auth.signOut();
      if (mounted) {
        Navigator.of(context).pushReplacementNamed('/login');
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
              backgroundColor: Colors.red),
        );
      }
    }
  }

  Future<void> _loadUserEmail() async {
    try {
      final user = Supabase.instance.client.auth.currentUser;
      if (user != null) {
        final response = await Supabase.instance.client
            .from('profiles')
            .select('email')
            .eq('id', user.id)
            .single();
        setState(() {
          userEmail = response['email'];
          isLoading = false;
        });
      }
    } catch (e) {
      print('Error loading user email: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> _deleteAccount() async {
    try {
      final user = Supabase.instance.client.auth.currentUser;
      if (user != null) {
        await Supabase.instance.client
            .from('profiles')
            .delete()
            .match({'id': user.id});
       _signOut();

      }
    } catch (e) {
      print('Error deleting account: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to delete account. Please try again.')),
      );
    }
  }

  void _showDeleteConfirmation() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Account'),
        content: const Text('Are you sure you want to delete your account permanently?'),
        actions: [
          TextButton(
            style: TextButton.styleFrom(
              foregroundColor: Colors.black,
              textStyle: const TextStyle(
              fontSize: 18, 
              ),
              ),
            child: const Text('Discard'),
            onPressed: () => Navigator.pop(context),
          ),
          TextButton(
            style: TextButton.styleFrom(
              foregroundColor: Colors.red,
              textStyle: const TextStyle(
              fontSize: 18, 
              ),
              ),
            child: const Text('Delete'),
            onPressed: () {
              Navigator.pop(context);
              _deleteAccount();
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings', style: TextStyle(fontSize: 24),),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Container(
            margin: const EdgeInsets.symmetric(
                                horizontal: ValueConstants.containerMargin),
            child: Padding(
                padding: const EdgeInsets.only(top: 18),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Padding(
                      padding:  EdgeInsets.only(left: 5),
                      child: Text(
                        'Account settings',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(12),  // Padding inside the box
                      decoration: BoxDecoration(
                        border: Border.all(color: ColorConstants.navLabelHighlight),  // Border color
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(8),
                          topRight: Radius.circular(8),
                        ),  // Rounded corners
                      ),
                      child: Text('Email: ${userEmail ?? 'Not available'}',
                       style: const TextStyle(fontSize: 18),)),
                    // const SizedBox(height: 10),
                    GestureDetector(
                      onTap: _showDeleteConfirmation,
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(12),  // Padding inside the box
                        decoration: BoxDecoration(
                          color: Colors.transparent,
                          border: Border.all(color: ColorConstants.navLabelHighlight),  // Border color
                          borderRadius: const BorderRadius.only(
                            bottomLeft: Radius.circular(8),
                            bottomRight: Radius.circular(8),
                          ),  // Rounded corners
                        ),
                        child: const Text(
                          'Delete account',
                          style: TextStyle(
                            color: Colors.red,  // Set text color to red
                            fontSize: 16,       // Font size
                            fontWeight: FontWeight.w600,  // Font weight
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
          ),
    );
  }
}