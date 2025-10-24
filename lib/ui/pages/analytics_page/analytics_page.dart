import 'package:flutter/material.dart';
import 'package:creditech_capstone_project/ui/widgets/dust_background.dart';
import 'package:creditech_capstone_project/ui/widgets/dashed_drop_zone.dart';
import 'package:provider/provider.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:io';
import '../../../models/upload_models.dart';
import '../../../models/prediction_models.dart';
import '../../../controller/upload_provider.dart';
import '../../../controller/chart_provider.dart';
import '../../../controller/history_provider.dart';
import 'upload_file_item.dart';

class AnalyticsPage extends StatelessWidget {
  const AnalyticsPage({super.key});

  Widget _buildSummaryCard({
    required String title,
    required String subtitle,
    required String value,
    required IconData icon,
    required Color iconColor,
    bool isWarning = false,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.25),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: iconColor.withOpacity(0.15),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              icon,
              color: iconColor,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.5),
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          Text(
            value,
            style: TextStyle(
              color: isWarning ? const Color(0xFFFF6B6B) : Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTransactionCard(TransactionPrediction prediction) {
    final isFraud = prediction.isFraud == 1;
    final deviceType = prediction.deviceTypeMobile == 1 ? 'Mobile' : 'Desktop';
    final fraudProbability = (prediction.probability * 100).toStringAsFixed(0);
    
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.25),
        borderRadius: BorderRadius.circular(16),
        border: isFraud 
          ? Border.all(color: const Color(0xFFFF6B6B).withOpacity(0.3))
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
                        isFraud ? Icons.warning_amber_rounded : Icons.check_circle_outline,
                        size: 14,
                        color: isFraud ? const Color(0xFFFF6B6B) : const Color(0xFF2ECC71),
                      ),
                      const SizedBox(width: 4),
                      Flexible(
                        child: Text(
                          isFraud ? 'Suspicious' : 'Safe',
                          style: TextStyle(
                            color: isFraud ? const Color(0xFFFF6B6B) : const Color(0xFF2ECC71),
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
          const SizedBox(height: 16),
          IntrinsicHeight(
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Transaction Amount',
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.5),
                          fontSize: 12,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '\$${prediction.transactionAmount.toStringAsFixed(0)}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
                VerticalDivider(color: Colors.white.withOpacity(0.1)),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Account Balance',
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.5),
                          fontSize: 12,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '\$${prediction.accountBalance.toStringAsFixed(0)}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
                VerticalDivider(color: Colors.white.withOpacity(0.1)),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'User Age',
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.5),
                          fontSize: 12,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${prediction.age} years',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _pickAndUploadFile(BuildContext context) async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['csv'],
      );

      if (result != null) {
        final file = File(result.files.first.path!);
        final provider = Provider.of<UploadProvider>(context, listen: false);
        
        // Show a loading snackbar
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Analyzing file...'),
              duration: Duration(seconds: 2),
            ),
          );
        }

        await provider.uploadFile(file);
        
        if (provider.predictionResult != null) {
          provider.setMinimized(false); // Show results when new file uploaded
          if (!context.mounted) return;
          
          // Refresh chart data and history data
          Provider.of<ChartProvider>(context, listen: false).refreshData();
          
          // Refresh history provider to show new predictions
          await Provider.of<HistoryProvider>(context, listen: false).refreshAfterNewPredictions();
          
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Analysis complete! New predictions added to history.'),
              backgroundColor: Colors.green,
            ),
          );
        } else if (provider.error != null && context.mounted) {
          // Show error message
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(provider.error!),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error picking file: $e')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<UploadProvider>(
      builder: (context, uploadProvider, _) {
        final items = uploadProvider.uploadedFiles
            .map(
              (status) => UploadItemData(
                fileName: status.fileName,
                sizeText: '${status.file.lengthSync()} bytes',
                status: status.status,
                progress: status.progress,
              ),
            )
            .toList();

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

                // LAYER: konten utama
                SafeArea(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 4),
                        const Text(
                          'Analytics',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 36,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 18),

                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.fromLTRB(16, 16, 16, 18),
                          decoration: BoxDecoration(
                            color: const Color(0xFF3A3E53),
                            borderRadius: BorderRadius.circular(22),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.35),
                                blurRadius: 24,
                                offset: const Offset(0, 14),
                              ),
                            ],
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              // Header
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    width: 38,
                                    height: 38,
                                    decoration: BoxDecoration(
                                      color: Colors.white.withOpacity(0.12),
                                      shape: BoxShape.circle,
                                    ),
                                    child: const Icon(
                                      Icons.cloud_upload_outlined,
                                      color: Colors.white70,
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  const Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Upload files',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 18,
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                        SizedBox(height: 2),
                                        Text(
                                          'Select and upload the files oof your choice',
                                          style: TextStyle(
                                            color: Colors.white70,
                                            fontSize: 12,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () => uploadProvider.setMinimized(!uploadProvider.isMinimized),
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                        top: 4.0,
                                        left: 8,
                                      ),
                                      child: Icon(
                                        uploadProvider.isMinimized 
                                          ? Icons.expand_more_rounded
                                          : Icons.minimize_rounded,
                                        color: Colors.white70,
                                        size: 20,
                                      ),
                                    ),
                                  ),
                                ],
                              ),

                              const SizedBox(height: 12),
                              Container(
                                height: 1,
                                color: Colors.white.withOpacity(0.15),
                              ),
                              if (!uploadProvider.isMinimized) ...[
                                const SizedBox(height: 14),
                                if (items.isEmpty) DashedDropZone(
                                  child: InkWell(
                                    onTap: () => _pickAndUploadFile(context),
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          const Icon(
                                            Icons.cloud_upload_outlined,
                                            size: 20,
                                            color: Colors.white70,
                                          ),
                                          const SizedBox(height: 6),
                                          const Text(
                                            'Choose CSV file or drag & drop',
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 12,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                          const SizedBox(height: 3),
                                          const Text(
                                            'CSV files only, up to 50MB',
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              color: Colors.white70,
                                              fontSize: 10,
                                            ),
                                          ),
                                          const SizedBox(height: 8),
                                          OutlinedButton(
                                            style: OutlinedButton.styleFrom(
                                              foregroundColor: Colors.white,
                                              side: BorderSide(
                                                color: Colors.white.withOpacity(0.8),
                                              ),
                                              padding: const EdgeInsets.symmetric(
                                                horizontal: 12,
                                                vertical: 6,
                                              ),
                                              shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(6),
                                              ),
                                              minimumSize: const Size(0, 0),
                                              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                            ),
                                            onPressed: () => _pickAndUploadFile(context),
                                            child: const Text(
                                              'Browse File',
                                              style: TextStyle(fontSize: 11),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),

                                const SizedBox(height: 14),

                                ...items.asMap().entries.map(
                                (entry) => Padding(
                                  padding: const EdgeInsets.only(bottom: 12),
                                  child: UploadFileItem(
                                    data: entry.value,
                                    onClose: () => uploadProvider
                                        .removeUploadedFile(entry.key),
                                  ),
                                ),
                              ),
                              ],
                            ],
                          ),
                        ),

                        const SizedBox(height: 28),

                        if (uploadProvider.predictionResult != null) Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: const Color(0xFF3A3E53),
                            borderRadius: BorderRadius.circular(22),
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
                              const Text(
                                'Prediction Results',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 16),
                              // Summary Cards
                              Column(
                                children: [
                                  _buildSummaryCard(
                                    title: 'Total Records',
                                    subtitle: 'Analyzed transactions',
                                    value: uploadProvider.predictionResult!.totalRows.toString(),
                                    icon: Icons.insert_chart_outlined,
                                    iconColor: const Color(0xFF9BB7C6),
                                  ),
                                  const SizedBox(height: 16),
                                  _buildSummaryCard(
                                    title: 'Fraud Detected',
                                    subtitle: 'Suspicious transactions',
                                    value: uploadProvider.predictionResult!.totalFraudDetected.toString(),
                                    icon: Icons.warning_amber_rounded,
                                    iconColor: const Color(0xFFFF6B6B),
                                    isWarning: true,
                                  ),
                                ],
                              ),
                              
                              const SizedBox(height: 24),
                              // Transactions List
                              const Text(
                                'Transaction Details',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(height: 16),
                              ...uploadProvider.predictionResult!.predictions.map((prediction) => 
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 12),
                                  child: _buildTransactionCard(prediction),
                                ),
                              ).toList(),
                            ],
                          ),
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
