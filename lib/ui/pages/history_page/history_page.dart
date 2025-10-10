import 'package:flutter/material.dart';
import 'package:creditech_capstone_project/ui/pages/home_page/glassy_card.dart';
import 'transaction_item.dart';
import 'package:creditech_capstone_project/ui/widgets/dust_background.dart';

class HistoryPage extends StatelessWidget {
  const HistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    final today = <TransactionData>[
      TransactionData(
        title: 'Transfer',
        subtitle: 'Incoming transfer',
        amountText: '+ \$3,110',
        isIncome: true,
        badgeColor: const Color(0xFFF2F59C),
        icon: Icons.south_rounded,
      ),
      TransactionData(
        title: 'Health',
        subtitle: 'Pharmacy',
        amountText: '- \$312,9',
        isIncome: false,
        badgeColor: const Color(0xFF9BB7C6),
        icon: Icons.north_rounded,
      ),
    ];

    final june13 = <TransactionData>[
      TransactionData(
        title: 'Transfer',
        subtitle: 'Incoming transfer',
        amountText: '+ \$3,110',
        isIncome: true,
        badgeColor: const Color(0xFFF2F59C),
        icon: Icons.south_rounded,
      ),
      TransactionData(
        title: 'Health',
        subtitle: 'Pharmacy',
        amountText: '- \$312,9',
        isIncome: false,
        badgeColor: const Color(0xFF9BB7C6),
        icon: Icons.north_rounded,
      ),
    ];

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
                    'History',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 36,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 18),

                  const GlassyCard(),
                  const SizedBox(height: 26),

                  Container(
                    padding: const EdgeInsets.fromLTRB(18, 18, 18, 18),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(26),
                      gradient: const LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          Color(0xFF242732),
                          Color(0xFF2B2E3B),
                        ],
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.35),
                          blurRadius: 24,
                          offset: const Offset(0, 14),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Expanded(
                              child: Text(
                                'Transactions',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 22,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                              decoration: BoxDecoration(
                                color: Colors.black.withOpacity(0.25),
                                borderRadius: BorderRadius.circular(18),
                              ),
                              child: const Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text('Filter',
                                      style: TextStyle(color: Colors.white, fontSize: 13)),
                                  SizedBox(width: 6),
                                  Icon(Icons.keyboard_arrow_down_rounded,
                                      size: 18, color: Colors.white),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 18),

                        const Text('Today',
                            style: TextStyle(color: Colors.white70, fontSize: 13)),
                        const SizedBox(height: 10),
                        ...today.map(
                              (t) => Padding(
                            padding: const EdgeInsets.only(bottom: 16),
                            child: TransactionItem(data: t),
                          ),
                        ),

                        const SizedBox(height: 8),
                        const Text('June 13th',
                            style: TextStyle(color: Colors.white70, fontSize: 13)),
                        const SizedBox(height: 10),
                        ...june13.map(
                              (t) => Padding(
                            padding: const EdgeInsets.only(bottom: 16),
                            child: TransactionItem(data: t),
                          ),
                        ),
                      ],
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