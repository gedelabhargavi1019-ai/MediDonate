import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../database/database_helper.dart';
import '../models/donation_model.dart';
import '../models/delivery_model.dart';

class DeliveryDetails extends StatefulWidget {
  final int? donationId;
  const DeliveryDetails({super.key, this.donationId});

  @override
  State<DeliveryDetails> createState() => _DeliveryDetailsState();
}

class _DeliveryDetailsState extends State<DeliveryDetails> {
  DonationModel? _donation;
  DeliveryModel? _delivery;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    try {
      if (widget.donationId != null) {
        final donation = await DatabaseHelper.instance.getDonation(widget.donationId!);
        final deliveries = await DatabaseHelper.instance.getDeliveriesByDonation(widget.donationId!);
        
        if (mounted) {
          setState(() {
            _donation = donation;
            _delivery = deliveries.isNotEmpty ? deliveries.first : null;
            _isLoading = false;
          });
        }
      } else {
        if (mounted) {
          setState(() {
            _isLoading = false;
          });
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(0xFFFFF3E0),
            Color(0xFFFFE4B5),
          ],
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          title: const Text('Delivery Details'),
          backgroundColor: const Color(0xFFFF6B35),
        ),
        body: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : _donation == null
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.error_outline,
                          size: 64,
                          color: Colors.grey[400],
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'No delivery information found',
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  )
                : SingleChildScrollView(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildMedicineCard(),
                        const SizedBox(height: 30),
                        _buildTrackingSection(),
                        const SizedBox(height: 30),
                        _buildDeliveryAddress(),
                        const SizedBox(height: 30),
                        _buildContactInfo(),
                      ],
                    ),
                  ),
      ),
    );
  }

  Widget _buildMedicineCard() {
    return Card(
      elevation: 6,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: const LinearGradient(
            colors: [Color(0xFFFF6B35), Color(0xFFFFD93D)],
          ),
        ),
        child: Column(
          children: [
            const Icon(Icons.local_shipping, color: Colors.white, size: 48),
            const SizedBox(height: 15),
            Text(
              _donation?.medicineName ?? 'Unknown Medicine',
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 5),
            Text(
              _delivery?.status ?? 'Pending',
              style: const TextStyle(
                fontSize: 16,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTrackingSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Tracking Information',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Color(0xFFFF6B35),
          ),
        ),
        const SizedBox(height: 20),
        _buildTrackingStep(
          'Order Placed',
          _formatDate(_donation?.createdAt),
          Icons.check_circle,
          const Color(0xFF4CAF50),
          true,
        ),
        _buildTrackingLine(),
        _buildTrackingStep(
          'Donation Approved',
          _donation?.status == 'Approved' ? _formatDate(_donation?.createdAt) : 'Pending',
          Icons.check_circle,
          _donation?.status == 'Approved' ? const Color(0xFF4CAF50) : Colors.grey,
          _donation?.status == 'Approved',
        ),
        _buildTrackingLine(),
        _buildTrackingStep(
          'Delivery Scheduled',
          _delivery != null ? _formatDate(_delivery?.createdAt) : 'Not Scheduled',
          Icons.calendar_today,
          _delivery != null ? const Color(0xFF4CAF50) : Colors.grey,
          _delivery != null,
        ),
        _buildTrackingLine(),
        _buildTrackingStep(
          'In Transit',
          _delivery?.status == 'In Transit' ? 'In Progress' : 'Pending',
          Icons.local_shipping,
          _delivery?.status == 'In Transit' ? const Color(0xFFFF6B35) : Colors.grey,
          _delivery?.status == 'In Transit',
        ),
        _buildTrackingLine(),
        _buildTrackingStep(
          'Delivered',
          _delivery?.deliveredAt != null ? _formatDate(_delivery?.deliveredAt) : 'Estimated: TBD',
          Icons.pending,
          _delivery?.status == 'Delivered' ? const Color(0xFF4CAF50) : Colors.grey,
          _delivery?.status == 'Delivered',
        ),
      ],
    );
  }

  Widget _buildDeliveryAddress() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Delivery Address',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Color(0xFFFF6B35),
          ),
        ),
        const SizedBox(height: 15),
        Card(
          elevation: 4,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                const Icon(Icons.location_on, color: Color(0xFF4A90E2), size: 28),
                const SizedBox(width: 15),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _delivery?.recipientName ?? 'No Recipient',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        _delivery?.deliveryAddress ?? 'No Address Provided',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[600],
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
    );
  }

  Widget _buildContactInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Contact Information',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Color(0xFFFF6B35),
          ),
        ),
        const SizedBox(height: 15),
        Card(
          elevation: 4,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                _buildContactRow(Icons.phone, _delivery?.recipientPhone ?? 'No Phone'),
                const Divider(),
                _buildContactRow(Icons.email, _donation?.donorEmail ?? 'No Email'),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTrackingStep(String title, String subtitle, IconData icon, Color color, bool completed) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.2),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: color, size: 24),
        ),
        const SizedBox(width: 15),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: completed ? const Color(0xFFFF6B35) : Colors.grey,
                ),
              ),
              const SizedBox(height: 3),
              Text(
                subtitle,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTrackingLine() {
    return Container(
      margin: const EdgeInsets.only(left: 11),
      height: 30,
      width: 2,
      color: const Color(0xFFFFD93D),
    );
  }

  Widget _buildContactRow(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, color: const Color(0xFF4A90E2), size: 20),
        const SizedBox(width: 15),
        Text(
          text,
          style: const TextStyle(fontSize: 14),
        ),
      ],
    );
  }

  String _formatDate(String? dateString) {
    if (dateString == null) return 'N/A';
    try {
      final date = DateTime.parse(dateString);
      return DateFormat('MMM dd, yyyy - HH:mm').format(date);
    } catch (e) {
      return dateString;
    }
  }
}
