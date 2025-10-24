import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'edit_profile_page.dart';
import 'package:creditech_capstone_project/ui/widgets/dust_background.dart';
import 'package:creditech_capstone_project/ui/widgets/loading_dialog.dart';
import 'package:creditech_capstone_project/controller/auth_controller.dart';
import 'package:creditech_capstone_project/controller/profile_provider.dart';
import 'package:creditech_capstone_project/controller/notification_provider.dart';
import 'package:creditech_capstone_project/static/navigation_route.dart';
import 'package:creditech_capstone_project/services/image_picker_service.dart';
import 'package:creditech_capstone_project/services/cloudinary_service.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  void _handleLogout(BuildContext context) async {
    // Show confirmation dialog
    final shouldLogout = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1E1E1E),
        title: const Text('Logout', style: TextStyle(color: Colors.white)),
        content: const Text(
          'Are you sure you want to logout?',
          style: TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF4169E1),
            ),
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Logout'),
          ),
        ],
      ),
    );

    if (shouldLogout == true) {
      final authController = context.read<AuthController>();
      await authController.signOut();
      Navigator.pushNamedAndRemoveUntil(
        context,
        NavigationRoute.login.path,
        (route) => false,
      );
    }
  }

  void _handleUpdateProfilePhoto(BuildContext context) async {
    try {
      
      // Show image picker bottom sheet
      final imageFile = await ImagePickerService.showImageSourceBottomSheet(context);
      
      
      if (imageFile != null && context.mounted) {
        // Verify file exists before proceeding
        if (!await imageFile.exists()) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Selected file is not available. Please try again.'),
              backgroundColor: Colors.red,
            ),
          );
          return;
        }
        
        
        // Show loading dialog
        LoadingDialog.show(context, message: 'Uploading photo...');
        
        // Get current user ID
        final userId = FirebaseAuth.instance.currentUser?.uid;
        
        // Upload to Cloudinary
        final photoURL = await CloudinaryService.uploadImage(imageFile, userId: userId);
        
        
        if (context.mounted) {
          LoadingDialog.hide(context);
          
          if (photoURL != null && photoURL.isNotEmpty) {
            // Update profile provider
            final profileProvider = context.read<ProfileProvider>();
            await profileProvider.updatePhotoURL(photoURL);
            
            
            // Show success message
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Profile photo updated successfully!'),
                backgroundColor: Color(0xFF4169E1),
              ),
            );
          } else {
            // Show error message
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Failed to upload photo. Please try again.'),
                backgroundColor: Colors.red,
              ),
            );
          }
        }
      } else {
      }
    } catch (e) {
      if (context.mounted) {
        LoadingDialog.hide(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('An error occurred: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer2<ProfileProvider, NotificationProvider>(
      builder: (context, profileProvider, notificationProvider, child) {
        return Scaffold(
          backgroundColor: Colors.transparent,
          body: SizedBox.expand(
            child: Stack(
              children: [
                const Positioned.fill(
                  child: DustBackground(
                    assetPath: 'assets/images/img_1.png',
                    opacity: 0.06,
                  ),
                ),
            
                SafeArea(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                       
                        const SizedBox(height: 16),
            
                        Center(
                          child: Column(
                            children: [
                              GestureDetector(
                                onTap: () => _handleUpdateProfilePhoto(context),
                                child: Stack(
                                  clipBehavior: Clip.none,
                                  children: [
                                    Container(
                                      width: 92,
                                      height: 92,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: const Color(0xFF202020),
                                        image: profileProvider.photoURL != null
                                            ? DecorationImage(
                                                image: NetworkImage(profileProvider.photoURL!),
                                                fit: BoxFit.cover,
                                              )
                                            : const DecorationImage(
                                                image: AssetImage('assets/images/img.png'),
                                                fit: BoxFit.cover,
                                              ),
                                      ),
                                    ),
                                    Positioned(
                                      right: -2,
                                      bottom: -2,
                                      child: Container(
                                        width: 28,
                                        height: 28,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: Colors.white,
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.black.withOpacity(0.35),
                                              blurRadius: 8,
                                              offset: const Offset(0, 3),
                                            ),
                                          ],
                                        ),
                                        child: const Icon(
                                          Icons.camera_alt,
                                          size: 16,
                                          color: Colors.black87,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 14),
                              Text(
                                profileProvider.fullName,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 22,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                '${profileProvider.email} | ${profileProvider.phone}',
                                style: const TextStyle(
                                  color: Colors.white70,
                                  fontSize: 13,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 20),
            
                        _TileGroup(
                          children: [
                            _TileRow(
                              icon: Icons.edit_outlined,
                              title: 'Edit profile information',
                              trailingText: '',
                              onTap: () async {
                                final result =
                                    await Navigator.push<EditProfileResult>(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) => EditProfilePage(
                                          initialFullName:
                                              profileProvider.fullName,
                                          initialNickName:
                                              profileProvider.nickName,
                                          initialEmail: profileProvider.email,
                                          initialPhone: profileProvider.phone,
                                        ),
                                      ),
                                    );
                                if (result != null) {
                                  profileProvider.updateProfile(
                                    fullName: result.fullName,
                                    nickName: result.nickName,
                                    email: result.email,
                                    phone: result.phone,
                                  );
                                }
                              },
                            ),
                            _DividerRow(),
                            _NotificationTileRow(
                              icon: Icons.notifications_none_rounded,
                              title: 'Notifications',
                              value: notificationProvider.isNotificationEnabled,
                              onChanged: (value) {
                                notificationProvider.setNotificationEnabled(value);
                              },
                              isLoading: notificationProvider.isLoading,
                            ),
                            
                          ],
                        ),
            
                        const SizedBox(height: 14),
            
            
                        // _TileGroup(
                        //   children: [
                        //     _TileRow(icon: Icons.lock_outline, title: 'Security'),
                        //     _DividerRow(),
                        //     _TileRow(
                        //       icon: Icons.support_agent_outlined,
                        //       title: 'Help & Support',
                        //     ),
                        //     _DividerRow(),
                        //     _TileRow(
                        //       icon: Icons.mail_outline,
                        //       title: 'Contact us',
                        //     ),
                        //     _DividerRow(),
                        //     _TileRow(
                        //       icon: Icons.privacy_tip_outlined,
                        //       title: 'Privacy policy',
                        //     ),
                        //   ],
                        // ),
            
                        // const SizedBox(height: 14),
            
                        // Test Notification Section
                        // _TileGroup(
                        //   children: [
                        //     _TileRow(
                        //       icon: notificationProvider.isNotificationEnabled 
                        //           ? Icons.notifications_active 
                        //           : Icons.notifications_off,
                        //       title: 'Test Notification',
                        //       trailingText: notificationProvider.isNotificationEnabled 
                        //           ? 'TAP TO TEST' 
                        //           : 'DISABLED',
                        //       trailingTextColor: notificationProvider.isNotificationEnabled 
                        //           ? const Color(0xFF4169E1) 
                        //           : Colors.red,
                        //       onTap: notificationProvider.isNotificationEnabled 
                        //           ? () => notificationProvider.showTestNotification()
                        //           : () {
                        //               ScaffoldMessenger.of(context).showSnackBar(
                        //                 const SnackBar(
                        //                   content: Text('Please enable notifications first'),
                        //                   backgroundColor: Colors.orange,
                        //                 ),
                        //               );
                        //             },
                        //     ),
                        //   ],
                        // ),
            
                        const SizedBox(height: 14),

                        _TileGroup(
                          children: [
                            _TileRow(
                              icon: Icons.logout,
                              title: 'Logout',
                              onTap: () => _handleLogout(context),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

// ----------------- Small reusable UI bits -----------------

class _TileGroup extends StatelessWidget {
  const _TileGroup({required this.children});
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF17191F),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.24),
            blurRadius: 18,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(children: children),
    );
  }
}

class _TileRow extends StatelessWidget {
  const _TileRow({
    required this.icon,
    required this.title,
    this.trailingText,
    this.trailingTextColor,
    this.onTap,
  });

  final IconData icon;
  final String title;
  final String? trailingText;
  final Color? trailingTextColor;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        child: Row(
          children: [
            Icon(icon, color: Colors.white, size: 22),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            if (trailingText != null)
              Text(
                trailingText!,
                style: TextStyle(
                  color: trailingTextColor ?? Colors.white70,
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
            const SizedBox(width: 6),
            const Icon(Icons.chevron_right, color: Colors.white54, size: 20),
          ],
        ),
      ),
    );
  }
}

class _NotificationTileRow extends StatelessWidget {
  const _NotificationTileRow({
    required this.icon,
    required this.title,
    required this.value,
    required this.onChanged,
    this.isLoading = false,
  });

  final IconData icon;
  final String title;
  final bool value;
  final ValueChanged<bool> onChanged;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      child: Row(
        children: [
          Icon(icon, color: Colors.white, size: 22),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 15,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          isLoading
              ? Transform.scale(
                  scale: 0.6,
                  child: const CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF4169E1)),
                  ),
                )
              : Transform.scale(
                  scale: 0.8,
                  child: Switch(
                    value: value,
                    onChanged: onChanged,
                    activeColor: Colors.white,
                    activeTrackColor: const Color(0xFF4169E1),
                    inactiveThumbColor: const Color(0xFF9E9E9E),
                    inactiveTrackColor: const Color(0xFF2A2A2A),
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                ),
        ],
      ),
    );
  }
}

class _DividerRow extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Divider(
      height: 1,
      thickness: 1,
      color: Colors.white.withOpacity(0.08),
      indent: 14,
      endIndent: 14,
    );
  }
}
