class RequestModel {
  final int? id;
  final String medicineName;
  final int quantity;
  final String priority; // 'Normal', 'Urgent', 'Critical'
  final String additionalDetails;
  final String receiverName;
  final String receiverEmail;
  final String receiverPhone;
  final String receiverAddress;
  final String medicalCondition;
  final String status; // 'Pending', 'Approved', 'Fulfilled'
  final String createdAt;

  RequestModel({
    this.id,
    required this.medicineName,
    required this.quantity,
    required this.priority,
    required this.additionalDetails,
    required this.receiverName,
    required this.receiverEmail,
    required this.receiverPhone,
    required this.receiverAddress,
    required this.medicalCondition,
    this.status = 'Pending',
    String? createdAt,
  }) : createdAt = createdAt ?? DateTime.now().toIso8601String();

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'medicineName': medicineName,
      'quantity': quantity,
      'priority': priority,
      'additionalDetails': additionalDetails,
      'receiverName': receiverName,
      'receiverEmail': receiverEmail,
      'receiverPhone': receiverPhone,
      'receiverAddress': receiverAddress,
      'medicalCondition': medicalCondition,
      'status': status,
      'createdAt': createdAt,
    };
  }

  factory RequestModel.fromMap(Map<String, dynamic> map) {
    return RequestModel(
      id: map['id'] as int?,
      medicineName: map['medicineName'] as String,
      quantity: map['quantity'] as int,
      priority: map['priority'] as String,
      additionalDetails: map['additionalDetails'] as String,
      receiverName: map['receiverName'] as String,
      receiverEmail: map['receiverEmail'] as String,
      receiverPhone: map['receiverPhone'] as String,
      receiverAddress: map['receiverAddress'] as String,
      medicalCondition: map['medicalCondition'] as String,
      status: map['status'] as String,
      createdAt: map['createdAt'] as String,
    );
  }

  RequestModel copyWith({
    int? id,
    String? medicineName,
    int? quantity,
    String? priority,
    String? additionalDetails,
    String? receiverName,
    String? receiverEmail,
    String? receiverPhone,
    String? receiverAddress,
    String? medicalCondition,
    String? status,
    String? createdAt,
  }) {
    return RequestModel(
      id: id ?? this.id,
      medicineName: medicineName ?? this.medicineName,
      quantity: quantity ?? this.quantity,
      priority: priority ?? this.priority,
      additionalDetails: additionalDetails ?? this.additionalDetails,
      receiverName: receiverName ?? this.receiverName,
      receiverEmail: receiverEmail ?? this.receiverEmail,
      receiverPhone: receiverPhone ?? this.receiverPhone,
      receiverAddress: receiverAddress ?? this.receiverAddress,
      medicalCondition: medicalCondition ?? this.medicalCondition,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
