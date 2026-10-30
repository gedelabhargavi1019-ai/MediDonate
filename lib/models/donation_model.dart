class DonationModel {
  final int? id;
  final String medicineName;
  final String category;
  final int quantity;
  final String expiryDate;
  final String description;
  final String donorName;
  final String donorEmail;
  final String donorPhone;
  final String status; // 'Pending', 'Approved', 'Delivered'
  final String createdAt;

  DonationModel({
    this.id,
    required this.medicineName,
    required this.category,
    required this.quantity,
    required this.expiryDate,
    required this.description,
    required this.donorName,
    required this.donorEmail,
    required this.donorPhone,
    this.status = 'Pending',
    String? createdAt,
  }) : createdAt = createdAt ?? DateTime.now().toIso8601String();

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'medicineName': medicineName,
      'category': category,
      'quantity': quantity,
      'expiryDate': expiryDate,
      'description': description,
      'donorName': donorName,
      'donorEmail': donorEmail,
      'donorPhone': donorPhone,
      'status': status,
      'createdAt': createdAt,
    };
  }

  factory DonationModel.fromMap(Map<String, dynamic> map) {
    return DonationModel(
      id: map['id'] as int?,
      medicineName: map['medicineName'] as String,
      category: map['category'] as String,
      quantity: map['quantity'] as int,
      expiryDate: map['expiryDate'] as String,
      description: map['description'] as String,
      donorName: map['donorName'] as String,
      donorEmail: map['donorEmail'] as String,
      donorPhone: map['donorPhone'] as String,
      status: map['status'] as String,
      createdAt: map['createdAt'] as String,
    );
  }

  DonationModel copyWith({
    int? id,
    String? medicineName,
    String? category,
    int? quantity,
    String? expiryDate,
    String? description,
    String? donorName,
    String? donorEmail,
    String? donorPhone,
    String? status,
    String? createdAt,
  }) {
    return DonationModel(
      id: id ?? this.id,
      medicineName: medicineName ?? this.medicineName,
      category: category ?? this.category,
      quantity: quantity ?? this.quantity,
      expiryDate: expiryDate ?? this.expiryDate,
      description: description ?? this.description,
      donorName: donorName ?? this.donorName,
      donorEmail: donorEmail ?? this.donorEmail,
      donorPhone: donorPhone ?? this.donorPhone,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
