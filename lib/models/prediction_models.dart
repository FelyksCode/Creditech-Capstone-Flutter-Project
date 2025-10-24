class PredictionResult {
  final String fileName;
  final int totalRows;
  final int totalFraudDetected;
  final List<TransactionPrediction> predictions;

  PredictionResult({
    required this.fileName,
    required this.totalRows,
    required this.totalFraudDetected,
    required this.predictions,
  });

  factory PredictionResult.fromJson(Map<String, dynamic> json) {
    return PredictionResult(
      fileName: json['file_name'] as String,
      totalRows: json['total_rows'] as int,
      totalFraudDetected: json['total_fraud_detected'] as int,
      predictions: (json['predictions'] as List)
          .map((e) => TransactionPrediction.fromJson(e))
          .toList(),
    );
  }
}

class TransactionPrediction {
  final int age;
  final double transactionAmount;
  final double accountBalance;
  final int deviceTypeMobile;
  final int isFraud;
  final double probability;
  final String? timestamp;

  String get formattedTimestamp {
    if (timestamp == null) return 'No date';
    try {
      final date = DateTime.parse(timestamp!);
      return '${date.day}/${date.month}/${date.year} ${date.hour}:${date.minute}';
    } catch (e) {
      return 'Invalid date';
    }
  }

  TransactionPrediction({
    required this.age,
    required this.transactionAmount,
    required this.accountBalance,
    required this.deviceTypeMobile,
    required this.isFraud,
    required this.probability,
    this.timestamp,
  });

  factory TransactionPrediction.fromJson(Map<String, dynamic> json) {
    return TransactionPrediction(
      age: json['Age'] as int,
      transactionAmount: (json['Transaction_Amount'] as num).toDouble(),
      accountBalance: (json['Account_Balance'] as num).toDouble(),
      deviceTypeMobile: json['Device_Type_Mobile'] as int,
      isFraud: json['is_fraud'] as int,
      probability: (json['probability'] as num).toDouble(),
    );
  }
}