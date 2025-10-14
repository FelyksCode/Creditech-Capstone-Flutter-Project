import 'dart:math';
import 'package:flutter/material.dart';
import 'package:creditech_capstone_project/ui/widgets/dust_background.dart';
import 'package:creditech_capstone_project/ui/pages/auth/login_page_new.dart';
import 'package:creditech_capstone_project/ui/pages/auth/register_page.dart';

class LoginLandingPage extends StatelessWidget {
  const LoginLandingPage({super.key});

  @override
  Widget build(BuildContext context) {
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
            child: Padding(
              padding: const EdgeInsets.fromLTRB(24, 12, 24, 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 8),
                  const Text(
                    'Creditech',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 26,
                      fontWeight: FontWeight.w600,
                    ),
                  ),

                  const SizedBox(height: 20),
                  Align(
                    alignment: Alignment.topRight,
                    child: Transform.rotate(
                      angle: -10 * pi / 180,
                      child: Image.asset(
                        'assets/images/img_2.png',
                        width: MediaQuery.of(context).size.width * 0.82,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),

                  const Spacer(),

                  const Text(
                    'Smart\nFinance\nStarts Here',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 48,
                      height: 1.05,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 18),

                  const Text(
                    'No jargon. No guesswork. Just easy,\n'
                    'reliable tools to grow your money -\n'
                    'one step at a time.',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 14,
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 28),

                  Row(
                    children: [
                      Expanded(
                        child: _Button.dark(
                          label: 'Login',
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const LoginPageNew(),
                              ),
                            );
                          },
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: _Button.light(
                          label: 'Create Account',
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const RegisterPage(),
                              ),
                            );
                          },
                        ),
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
  }
}

class _Button extends StatelessWidget {
  const _Button._({
    required this.label,
    required this.background,
    required this.foreground,
    this.onPressed,
  });

  factory _Button.dark({required String label, VoidCallback? onPressed}) =>
      _Button._(
        label: label,
        onPressed: onPressed,
        background: const Color(0xFF1E1E1A),
        foreground: Colors.white,
      );

  factory _Button.light({required String label, VoidCallback? onPressed}) =>
      _Button._(
        label: label,
        onPressed: onPressed,
        background: const Color(0xFFF1E8DE),
        foreground: const Color(0xFF1B1B1B),
      );

  final String label;
  final Color background;
  final Color foreground;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 56,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: background,
          foregroundColor: foreground,
          elevation: 0,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(22),
          ),
          textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          alignment: Alignment.center,
        ),
        onPressed: onPressed,
        child: Center(
          child: Text(
            label,
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
