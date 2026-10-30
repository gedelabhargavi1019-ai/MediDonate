class DeliveryModel {
  final int? id;
  final int requestId;
  final int donationId;
  final String recipientName;
  final String recipientPhone;
  final String deliveryAddress;
  final String deliveryDate;
  final String trackingNumber;
  final String status; // 'Pending', 'In Transit', 'Delivered'
  final String createdAt;
  final String? deliveredAt;

  DeliveryModel({
    this.id,
    required this.requestId,
    required this.donationId,
    required this.recipientName,
    required this.recipientPhone,
    required this.deliveryAddress,
    required this.deliveryDate,
    required this.trackingNumber,
    this.status = 'Pending',
    String? createdAt,
    this.deliveredAt,
  }) : createdAt = createdAt ?? DateTime.now().toIso8601String();

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'requestId': requestId,
      'donationId': donationId,
      'recipientName': recipientName,
      'recipientPhone': recipientPhone,
      'deliveryAddress': deliveryAddress,
      'deliveryDate': deliveryDate,
      'trackingNumber': trackingNumber,
      'status': status,
      'createdAt': createdAt,
      'deliveredAt': deliveredAt,
    };
  }

  factory DeliveryModel.fromMap(Map<String, dynamic> map) {
    return DeliveryModel(
      id: map['id'] as int?,
      requestId: map['requestId'] as int,
      donationId: map['donationId'] as int,
      recipientName: map['recipientName'] as String,
      recipientPhone: map['recipientPhone'] as String,
      deliveryAddress: map['deliveryAddress'] as String,
      deliveryDate: map['deliveryDate'] as String,
      trackingNumber: map['trackingNumber'] as String,
      status: map['status'] as String,
      createdAt: map['createdAt'] as String,
      deliveredAt: map['deliveredAt'] as String?,
    );
  }

  DeliveryModel copyWith({
    int? id,
    int? requestId,
    int? donationId,
    String? recipientName,
    String? recipientPhone,
    String? deliveryAddress,
    String? deliveryDate,
    String? trackingNumber,
    String? status,
    String? createdAt,
    String? deliveredAt,
  }) {
    return DeliveryModel(
      id: id ?? this.id,
      requestId: requestId ?? this.requestId,
      donationId: donationId ?? this.donationId,
      recipientName: recipientName ?? this.recipientName,
      recipientPhone: recipientPhone ?? this.recipientPhone,
      deliveryAddress: deliveryAddress ?? this.deliveryAddress,
      deliveryDate: deliveryDate ?? this.deliveryDate,
      trackingNumber: trackingNumber ?? this.trackingNumber,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      deliveredAt: deliveredAt ?? this.deliveredAt,
    );
  }
}
