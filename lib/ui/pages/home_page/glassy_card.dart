import 'package:flutter/material.dart';

class GlassyCard extends StatelessWidget {
  const GlassyCard({
    super.key,
    this.brandText = 'Glassy.',
    this.maskedNumber = '7812 2139 0823 XXXX',
    this.validThru = '05/24',
    this.cvv = '09X',
  });

  final String brandText;
  final String maskedNumber;
  final String validThru;
  final String cvv;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        gradient: LinearGradient(
          colors: [Colors.white.withOpacity(0.14), Colors.white.withOpacity(0.05)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        border: Border.all(color: Colors.white.withOpacity(0.22), width: 1.2),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.45),
            blurRadius: 18,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                brandText,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                  color: Colors.white,
                  fontStyle: FontStyle.italic,
                ),
              ),
              const Spacer(),
              Icon(Icons.contactless_rounded, color: Colors.white.withOpacity(0.85), size: 30),
            ],
          ),
          const SizedBox(height: 28),
          Text(
            maskedNumber,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20,
              letterSpacing: 2,
              fontFeatures: [FontFeature.tabularFigures()],
            ),
          ),
          const SizedBox(height: 18),
          Row(
            children: [
              _kv('VALID THRU', validThru),
              const SizedBox(width: 36),
              _kv('CVV', cvv),
            ],
          ),
        ],
      ),
    );
  }

  Widget _kv(String k, String v) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(k, style: const TextStyle(color: Colors.white70, fontSize: 10, letterSpacing: 0.6)),
        const SizedBox(height: 2),
        Text(v, style: const TextStyle(color: Colors.white, fontSize: 15, fontFeatures: [FontFeature.tabularFigures()])),
      ],
    );
  }
}