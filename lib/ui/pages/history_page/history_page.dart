import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:creditech_capstone_project/ui/widgets/dust_background.dart';
import 'package:creditech_capstone_project/controller/history_provider.dart';
import '../../../models/prediction_models.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> with AutomaticKeepAliveClientMixin {
  late HistoryProvider _historyProvider;

  @override
  bool get wantKeepAlive => true; // Keep the state alive

  @override
  void initState() {
    super.initState();
    _historyProvider = Provider.of<HistoryProvider>(context, listen: false);
    // Schedule the loading after the initial build is complete
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadPredictions();
    });
  }

  @override
  void didUpdateWidget(HistoryPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Refresh data when the widget updates (e.g., when navigating back to this page)
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _historyProvider.refreshAfterNewPredictions();
      }
    });
  }

  Future<void> _loadPredictions() async {
    try {
      await _historyProvider.loadPredictions();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to load predictions. Please try again.'),
            backgroundColor: Colors.red.withOpacity(0.8),
            action: SnackBarAction(
              label: 'Retry',
              textColor: Colors.white,
              onPressed: _loadPredictions,
            ),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context); // Required for AutomaticKeepAliveClientMixin
    
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
              child: RefreshIndicator(
                onRefresh: _loadPredictions,
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
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
                      Container(
                        padding: const EdgeInsets.all(18),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(26),
                          gradient: const LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [Color(0xFF242732), Color(0xFF2B2E3B)],
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.35),
                              blurRadius: 24,
                              offset: const Offset(0, 14),
                            ),
                          ],
                        ),
                        child: Consumer<HistoryProvider>(
                          builder: (context, historyProvider, _) {
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    const Expanded(
                                      child: Text(
                                        'Past Predictions',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 22,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                    ),
                                    if (historyProvider.isLoading)
                                      const SizedBox(
                                        width: 20,
                                        height: 20,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                          valueColor:
                                              AlwaysStoppedAnimation<Color>(
                                            Colors.white70,
                                          ),
                                        ),
                                      )
                                    else if (historyProvider.predictions != null)
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 14,
                                          vertical: 8,
                                        ),
                                        decoration: BoxDecoration(
                                          color: Colors.black.withOpacity(0.25),
                                          borderRadius:
                                              BorderRadius.circular(18),
                                        ),
                                        child: Text(
                                          '${historyProvider.predictions!.length} Results',
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 13,
                                          ),
                                        ),
                                      ),
                                  ],
                                ),
                                const SizedBox(height: 18),
                                if (historyProvider.isLoading)
                                  const Center(
                                    child: Text(
                                      'Loading predictions...',
                                      style: TextStyle(color: Colors.white70),
                                    ),
                                  )
                                else if (historyProvider.error != null)
                                  Center(
                                    child: Column(
                                      children: [
                                        const Icon(
                                          Icons.error_outline,
                                          color: Colors.red,
                                          size: 48,
                                        ),
                                        const SizedBox(height: 12),
                                        const Text(
                                          'Failed to load predictions',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        const SizedBox(height: 8),
                                        Text(
                                          'Please check your connection and try again',
                                          style: TextStyle(
                                            color: Colors.white.withOpacity(0.7),
                                            fontSize: 14,
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                        const SizedBox(height: 16),
                                        ElevatedButton(
                                          onPressed: () {
                                            historyProvider.clearError();
                                            _loadPredictions();
                                          },
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: const Color(0xFF4169E1),
                                            foregroundColor: Colors.white,
                                          ),
                                          child: const Text('Retry'),
                                        ),
                                      ],
                                    ),
                                  )
                                else if (historyProvider.predictions == null ||
                                    historyProvider.predictions!.isEmpty)
                                  const Center(
                                    child: Column(
                                      children: [
                                        Icon(
                                          Icons.history,
                                          color: Colors.white54,
                                          size: 48,
                                        ),
                                        SizedBox(height: 12),
                                        Text(
                                          'No predictions found',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        SizedBox(height: 8),
                                        Text(
                                          'Your transaction predictions will appear here',
                                          style: TextStyle(color: Colors.white70),
                                        ),
                                      ],
                                    ),
                                  )
                                else
                                  Column(
                                    children: [
                                      ...historyProvider
                                          .getCurrentPageItems()
                                          .map((prediction) {
                                        final timestamp = (prediction.timestamp !=
                                                    null &&
                                                prediction.timestamp!.isNotEmpty)
                                            ? DateTime.parse(
                                                    prediction.timestamp!)
                                                .toLocal()
                                                .toString()
                                            : 'Unknown date';
                                        return Padding(
                                          padding: const EdgeInsets.only(
                                              bottom: 16.0),
                                          child: _buildTransactionCard(
                                              prediction, timestamp),
                                        );
                                      }),
                                      if (historyProvider.totalPages > 1)
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(top: 8.0),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              IconButton(
                                                icon: const Icon(
                                                    Icons.arrow_back_ios),
                                                onPressed:
                                                    historyProvider.canGoBack
                                                        ? historyProvider
                                                            .previousPage
                                                        : null,
                                                color:
                                                    historyProvider.canGoBack
                                                        ? Colors.white
                                                        : Colors.white
                                                            .withOpacity(0.3),
                                              ),
                                              Container(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                  horizontal: 16,
                                                  vertical: 8,
                                                ),
                                                decoration: BoxDecoration(
                                                  color: Colors.black
                                                      .withOpacity(0.25),
                                                  borderRadius:
                                                      BorderRadius.circular(12),
                                                ),
                                                child: Text(
                                                  'Page ${historyProvider.currentPage + 1} of ${historyProvider.totalPages}',
                                                  style: const TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 14,
                                                  ),
                                                ),
                                              ),
                                              IconButton(
                                                icon: const Icon(
                                                    Icons.arrow_forward_ios),
                                                onPressed: historyProvider
                                                        .canGoForward
                                                    ? historyProvider.nextPage
                                                    : null,
                                                color: historyProvider
                                                        .canGoForward
                                                    ? Colors.white
                                                    : Colors.white
                                                        .withOpacity(0.3),
                                              ),
                                            ],
                                          ),
                                        ),
                                    ],
                                  ),
                              ],
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTransactionCard(
      TransactionPrediction prediction, String timestamp) {
    final isFraud = prediction.isFraud == 1;
    final deviceType =
        prediction.deviceTypeMobile == 1 ? 'Mobile' : 'Desktop';
    final fraudProbability =
        (prediction.probability * 100).toStringAsFixed(0);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.25),
        borderRadius: BorderRadius.circular(16),
        border: isFraud
            ? Border.all(
                color: const Color(0xFFFF6B6B).withOpacity(0.3),
              )
            : null,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Flexible(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: isFraud
                        ? const Color(0xFFFF6B6B).withOpacity(0.15)
                        : const Color(0xFF2ECC71).withOpacity(0.15),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        isFraud
                            ? Icons.warning_amber_rounded
                            : Icons.check_circle_outline,
                        size: 14,
                        color: isFraud
                            ? const Color(0xFFFF6B6B)
                            : const Color(0xFF2ECC71),
                      ),
                      const SizedBox(width: 4),
                      Flexible(
                        child: Text(
                          isFraud ? 'Suspicious' : 'Safe',
                          style: TextStyle(
                            color: isFraud
                                ? const Color(0xFFFF6B6B)
                                : const Color(0xFF2ECC71),
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Flexible(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        prediction.deviceTypeMobile == 1
                            ? Icons.phone_android_rounded
                            : Icons.computer_rounded,
                        size: 14,
                        color: Colors.white70,
                      ),
                      const SizedBox(width: 4),
                      Flexible(
                        child: Text(
                          deviceType,
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 11,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Risk: $fraudProbability%',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.7),
                    fontSize: 11,
                  ),
                  textAlign: TextAlign.end,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            timestamp,
            style: TextStyle(
              color: Colors.white.withOpacity(0.5),
              fontSize: 12,
            ),
          ),
          const SizedBox(height: 16),
          IntrinsicHeight(
            child: Row(
              children: [
                Expanded(
                  child: _infoBlock(
                    'Transaction Amount',
                    '\$${prediction.transactionAmount.toStringAsFixed(0)}',
                  ),
                ),
                VerticalDivider(color: Colors.white.withOpacity(0.1)),
                Expanded(
                  child: _infoBlock(
                    'Account Balance',
                    '\$${prediction.accountBalance.toStringAsFixed(0)}',
                  ),
                ),
                VerticalDivider(color: Colors.white.withOpacity(0.1)),
                Expanded(
                  child: _infoBlock(
                    'User Age',
                    '${prediction.age} years',
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _infoBlock(String label, String value) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              color: Colors.white.withOpacity(0.5),
              fontSize: 12,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      );
}
