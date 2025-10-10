import 'package:flutter/material.dart';


class TransactionData {
  final String title;
  final String subtitle;
  final String amountText;
  final bool isIncome;
  final Color badgeColor;
  final IconData icon;

  const TransactionData({
    required this.title,
    required this.subtitle,
    required this.amountText,
    required this.isIncome,
    required this.badgeColor,
    required this.icon,
  });
}


class TransactionItem extends StatelessWidget {
  const TransactionItem({super.key, required this.data});

  final TransactionData data;

  @override
  Widget build(BuildContext context) {
    final amountColor = Colors.white;
    final titleStyle = const TextStyle(
      color: Colors.white,
      fontSize: 16,
      fontWeight: FontWeight.w700,
    );
    final subtitleStyle = TextStyle(
      color: Colors.white.withOpacity(0.55),
      fontSize: 13,
    );

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: data.badgeColor,
            shape: BoxShape.circle,
          ),
          child: Icon(
            data.icon,
            color: const Color(0xFF212121),
            size: 22,
          ),
        ),
        const SizedBox(width: 14),

        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(data.title, style: titleStyle),
              const SizedBox(height: 4),
              Text(data.subtitle, style: subtitleStyle),
            ],
          ),
        ),

        Text(
          data.amountText,
          style: TextStyle(
            color: amountColor,
            fontSize: 16,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }
}