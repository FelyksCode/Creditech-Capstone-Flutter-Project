import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:creditech_capstone_project/ui/widgets/dust_background.dart';
import 'package:creditech_capstone_project/controller/profile_provider.dart';
import 'package:creditech_capstone_project/ui/widgets/notification_helper.dart';

class EditProfileResult {
  final String fullName;
  final String nickName;
  final String email;
  final String phone;
  const EditProfileResult({
    required this.fullName,
    required this.nickName,
    required this.email,
    required this.phone,
  });
}

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({
    super.key,
    required this.initialFullName,
    required this.initialNickName,
    required this.initialEmail,
    required this.initialPhone,
  });

  final String initialFullName;
  final String initialNickName;
  final String initialEmail;
  final String initialPhone;

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _name =
      TextEditingController(text: widget.initialFullName);
  late final TextEditingController _nick =
      TextEditingController(text: widget.initialNickName);
  late final TextEditingController _email =
      TextEditingController(text: widget.initialEmail);
  late final TextEditingController _phone =
      TextEditingController(text: widget.initialPhone);

  @override
  void dispose() {
    _name.dispose();
    _nick.dispose();
    _email.dispose();
    _phone.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: const Color(0xFF141414),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Edit profile',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700)),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          const Positioned.fill(
            child: DustBackground(
              assetPath: 'assets/images/img_1.png',
              opacity: 0.06,
            ),
          ),

          SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(24, 12, 24, 24),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  _Input(
                    label: 'Full name', 
                    controller: _name,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Full name is required';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 12),
                  _Input(label: 'Nick name', controller: _nick),
                  const SizedBox(height: 12),
                  _Input(
                    label: 'Email',
                    controller: _email,
                    keyboard: TextInputType.emailAddress,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Email is required';
                      }
                      if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
                        return 'Please enter a valid email format';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 12),
                  _PhoneInput(label: 'Phone number', controller: _phone),
                const SizedBox(height: 12),

                const _Dropdownish(label: 'Country', valueText: 'Indonesia'),
                const SizedBox(height: 12),
                const _Input(label: 'Address', hint: '45 New Avenue, New York'),

                  const SizedBox(height: 28),
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF7FA9FF),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                      ),
                      onPressed: () {
                        // Validate form
                        if (_formKey.currentState!.validate()) {
                          // Update profile using Provider
                          final profileProvider = context.read<ProfileProvider>();
                          profileProvider.updateProfile(
                            fullName: _name.text.trim(),
                            nickName: _nick.text.trim(),
                            email: _email.text.trim(),
                            phone: _phone.text.trim(),
                          );

                          // Show success notification
                          NotificationHelper.showSuccessNotification(
                            context,
                            'Profile updated successfully!',
                          );

                          // Return the result for backward compatibility
                          Navigator.pop(
                            context,
                            EditProfileResult(
                              fullName: _name.text.trim(),
                              nickName: _nick.text.trim(),
                              email: _email.text.trim(),
                              phone: _phone.text.trim(),
                            ),
                          );
                        } else {
                          // Show validation error
                          NotificationHelper.showErrorNotification(
                            context,
                            'Please fix the errors in the form',
                          );
                        }
                      },
                      child: const Text('SUBMIT',
                          style: TextStyle(fontWeight: FontWeight.w700)),
                    ),
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


class _Input extends StatelessWidget {
  const _Input({
    required this.label,
    this.hint,
    this.controller,
    this.keyboard,
    this.validator,
  });

  final String label;
  final String? hint;
  final TextEditingController? controller;
  final TextInputType? keyboard;
  final String? Function(String?)? validator;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _Label(label),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          keyboardType: keyboard,
          style: const TextStyle(color: Colors.white),
          decoration: _inputDecoration(hint: hint ?? ''),
          validator: validator,
        ),
      ],
    );
  }
}

class _PhoneInput extends StatelessWidget {
  const _PhoneInput({required this.label, required this.controller});
  final String label;
  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _Label(label),
        const SizedBox(height: 8),
        Row(
          children: [
            Container(
              height: 48,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              alignment: Alignment.center,
              decoration: _filledBoxDecoration,
              child: const Text('🇮🇩', style: TextStyle(fontSize: 20)),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: TextField(
                controller: controller,
                style: const TextStyle(color: Colors.white),
                keyboardType: TextInputType.phone,
                decoration: _inputDecoration(),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _Dropdownish extends StatelessWidget {
  const _Dropdownish({required this.label, required this.valueText});
  final String label;
  final String valueText;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _Label(label),
        const SizedBox(height: 8),
        Container(
          height: 48,
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: _filledBoxDecoration,
          alignment: Alignment.centerLeft,
          child: Row(
            children: [
              Text(valueText, style: const TextStyle(color: Colors.white)),
              const Spacer(),
              const Icon(Icons.keyboard_arrow_down_rounded, color: Colors.white70),
            ],
          ),
        ),
      ],
    );
  }
}

class _Label extends StatelessWidget {
  const _Label(this.text);
  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(text,
        style: const TextStyle(
            color: Colors.white70, fontSize: 13, fontWeight: FontWeight.w600));
  }
}

final _filledBoxDecoration = BoxDecoration(
  color: const Color(0xFF1C2230),
  borderRadius: BorderRadius.circular(10),
  border: Border.all(color: const Color(0xFF2D3550)),
);

InputDecoration _inputDecoration({String hint = ''}) {
  return InputDecoration(
    hintText: hint,
    hintStyle: const TextStyle(color: Colors.white54),
    filled: true,
    fillColor: const Color(0xFF1C2230),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: const BorderSide(color: Color(0xFF2D3550)),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: const BorderSide(color: Color(0xFF4960A8)),
    ),
    contentPadding:
    const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
  );
}