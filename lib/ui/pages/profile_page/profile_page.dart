import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'edit_profile_page.dart';
import 'notifications_page.dart';
import 'package:creditech_capstone_project/ui/widgets/dust_background.dart';
import 'package:creditech_capstone_project/controller/auth_controller.dart';
import 'package:creditech_capstone_project/controller/profile_provider.dart';
import 'package:creditech_capstone_project/static/navigation_route.dart';

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

  @override
  Widget build(BuildContext context) {
    return Consumer<ProfileProvider>(
      builder: (context, profileProvider, child) {
        return Scaffold(
          backgroundColor: Colors.transparent,
          body: Stack(
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
                      const Text(
                        'Profile',
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 16),

                      Center(
                        child: Column(
                          children: [
                            Stack(
                              clipBehavior: Clip.none,
                              children: [
                                Container(
                                  width: 92,
                                  height: 92,
                                  decoration: const BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Color(0xFF202020),
                                    image: DecorationImage(
                                      image: AssetImage(
                                        'assets/images/img.png',
                                      ),
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
                                      Icons.edit,
                                      size: 16,
                                      color: Colors.black87,
                                    ),
                                  ),
                                ),
                              ],
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
                          _TileRow(
                            icon: Icons.notifications_none_rounded,
                            title: 'Notifications',
                            trailingText: profileProvider.generalNotificationOn
                                ? 'ON'
                                : 'OFF',
                            trailingTextColor:
                                profileProvider.generalNotificationOn
                                ? const Color(0xFF7FB1FF)
                                : Colors.white54,
                            onTap: () async {
                              final result = await Navigator.push<bool>(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => NotificationsPage(
                                    initialGeneralOn:
                                        profileProvider.generalNotificationOn,
                                  ),
                                ),
                              );
                              if (result != null) {
                                profileProvider.updateGeneralNotification(
                                  result,
                                );
                              }
                            },
                          ),
                          _DividerRow(),
                          _TileRow(
                            icon: Icons.language_outlined,
                            title: 'Language',
                            trailingText: profileProvider.language,
                          ),
                        ],
                      ),

                      const SizedBox(height: 14),

                      _TileGroup(
                        children: [
                          _TileRow(icon: Icons.lock_outline, title: 'Security'),
                          _DividerRow(),
                          _TileRow(
                            icon: Icons.color_lens_outlined,
                            title: 'Theme',
                            trailingText: profileProvider.themeLabel,
                          ),
                        ],
                      ),

                      const SizedBox(height: 14),

                      _TileGroup(
                        children: [
                          _TileRow(
                            icon: Icons.support_agent_outlined,
                            title: 'Help & Support',
                          ),
                          _DividerRow(),
                          _TileRow(
                            icon: Icons.mail_outline,
                            title: 'Contact us',
                          ),
                          _DividerRow(),
                          _TileRow(
                            icon: Icons.privacy_tip_outlined,
                            title: 'Privacy policy',
                          ),
                        ],
                      ),

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
