import 'package:flutter/material.dart';

class NotificationsPage extends StatefulWidget {
  const NotificationsPage({super.key, required this.initialGeneralOn});
  final bool initialGeneralOn;

  @override
  State<NotificationsPage> createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  late bool generalOn = widget.initialGeneralOn;
  bool soundOn = false;
  bool vibrateOn = true;

  bool appUpdates = false;
  bool billReminder = true;
  bool promotion = true;
  bool discountAvailable = false;
  bool paymentRequest = false;

  bool newService = false;
  bool newTips = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF141414),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: const Color(0xFF141414),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
          onPressed: () => Navigator.pop(context, generalOn),
        ),
        title: const Text('Notifications',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700)),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
        children: [
          _SectionHeader('Common'),
          _SwitchTile('General Notification', generalOn, (v) => setState(() => generalOn = v)),
          _DividerLine(),
          _SwitchTile('Sound', soundOn, (v) => setState(() => soundOn = v)),
          _DividerLine(),
          _SwitchTile('Vibrate', vibrateOn, (v) => setState(() => vibrateOn = v)),

          const SizedBox(height: 18),
          _SectionHeader('System & services update'),
          _SwitchTile('App updates', appUpdates, (v) => setState(() => appUpdates = v)),
          _DividerLine(),
          _SwitchTile('Bill Reminder', billReminder, (v) => setState(() => billReminder = v)),
          _DividerLine(),
          _SwitchTile('Promotion', promotion, (v) => setState(() => promotion = v)),
          _DividerLine(),
          _SwitchTile('Discount Available', discountAvailable, (v) => setState(() => discountAvailable = v)),
          _DividerLine(),
          _SwitchTile('Payment Request', paymentRequest, (v) => setState(() => paymentRequest = v)),

          const SizedBox(height: 18),
          _SectionHeader('Others'),
          _SwitchTile('New Service Available', newService, (v) => setState(() => newService = v)),
          _DividerLine(),
          _SwitchTile('New Tips Available', newTips, (v) => setState(() => newTips = v)),
        ],
      ),
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