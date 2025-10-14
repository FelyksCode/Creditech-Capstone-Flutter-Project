import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:creditech_capstone_project/controller/profile_provider.dart';

class NotificationsPage extends StatelessWidget {
  const NotificationsPage({super.key, required this.initialGeneralOn});
  final bool initialGeneralOn;

  @override
  Widget build(BuildContext context) {
    return Consumer<ProfileProvider>(
      builder: (context, profileProvider, child) {
        return Scaffold(
          backgroundColor: const Color(0xFF141414),
          appBar: AppBar(
            elevation: 0,
            backgroundColor: const Color(0xFF141414),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
              onPressed: () => Navigator.pop(context, profileProvider.generalNotificationOn),
            ),
            title: const Text('Notifications',
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700)),
            centerTitle: true,
          ),
          body: ListView(
            padding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
            children: [
              _SectionHeader('Common'),
              _SwitchTile('General Notification', profileProvider.generalNotificationOn, 
                  (v) => profileProvider.updateGeneralNotification(v)),
              _DividerLine(),
              _SwitchTile('Sound', profileProvider.soundOn, 
                  (v) => profileProvider.updateSoundNotification(v)),
              _DividerLine(),
              _SwitchTile('Vibrate', profileProvider.vibrateOn, 
                  (v) => profileProvider.updateVibrateNotification(v)),

              const SizedBox(height: 18),
              _SectionHeader('System & services update'),
              _SwitchTile('App updates', profileProvider.appUpdates, 
                  (v) => profileProvider.updateAppUpdates(v)),
              _DividerLine(),
              _SwitchTile('Bill Reminder', profileProvider.billReminder, 
                  (v) => profileProvider.updateBillReminder(v)),
              _DividerLine(),
              _SwitchTile('Promotion', profileProvider.promotion, 
                  (v) => profileProvider.updatePromotion(v)),
              _DividerLine(),
              _SwitchTile('Discount Available', profileProvider.discountAvailable, 
                  (v) => profileProvider.updateDiscountAvailable(v)),
              _DividerLine(),
              _SwitchTile('Payment Request', profileProvider.paymentRequest, 
                  (v) => profileProvider.updatePaymentRequest(v)),

              const SizedBox(height: 18),
              _SectionHeader('Others'),
              _SwitchTile('New Service Available', profileProvider.newService, 
                  (v) => profileProvider.updateNewService(v)),
              _DividerLine(),
              _SwitchTile('New Tips Available', profileProvider.newTips, 
                  (v) => profileProvider.updateNewTips(v)),
            ],
          ),
        );
      },
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader(this.text);
  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10, top: 8),
      child: Text(
        text,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 14,
          fontWeight: FontWeight.w800,
        ),
      ),
    );
  }
}

class _SwitchTile extends StatelessWidget {
  const _SwitchTile(this.title, this.value, this.onChanged);
  final String title;
  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 48,
      child: Row(
        children: [
          Expanded(
            child: Text(title,
                style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w600)),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeColor: Colors.white,
            activeTrackColor: const Color(0xFF5B83FF),
            inactiveThumbColor: const Color(0xFF9E9E9E),
            inactiveTrackColor: const Color(0xFF2A2A2A),
          ),
        ],
      ),
    );
  }
}

class _DividerLine extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Divider(
      height: 1,
      thickness: 1,
      color: Colors.white.withOpacity(0.08),
    );
  }
}