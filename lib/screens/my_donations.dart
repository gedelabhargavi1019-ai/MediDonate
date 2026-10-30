import 'package:flutter/material.dart';
import 'delivery_details.dart';
import '../database/database_helper.dart';
import '../models/donation_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyDonations extends StatefulWidget {
  const MyDonations({super.key});

  @override
  State<MyDonations> createState() => _MyDonationsState();
}

class _MyDonationsState extends State<MyDonations> {
  List<DonationModel> _donations = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadDonations();
  }

  Future<void> _loadDonations() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final userEmail = prefs.getString('userEmail');
      
      if (userEmail != null) {
        final donations = await DatabaseHelper.instance.getDonationsByDonor(userEmail);
        if (mounted) {
          setState(() {
            _donations = donations;
            _isLoading = false;
          });
        }
      } else {
        final allDonations = await DatabaseHelper.instance.getAllDonations();
        if (mounted) {
          setState(() {
            _donations = allDonations;
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
          title: const Text('My Donations'),
          backgroundColor: const Color(0xFFFF6B35),
          actions: [
            IconButton(
              icon: const Icon(Icons.refresh),
              onPressed: _loadDonations,
            ),
          ],
        ),
        body: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : _donations.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.inbox,
                          size: 64,
                          color: Colors.grey[400],
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'No donations yet',
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.grey[600],
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Start donating medicines to help others',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[500],
                          ),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(20),
                    itemCount: _donations.length,
                    itemBuilder: (context, index) {
                      final donation = _donations[index];
                      final statusColor = _getStatusColor(donation.status);
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 15),
                        child: _buildDonationCard(
                          context,
                          donation.medicineName,
                          donation.category,
                          donation.quantity.toString(),
                          donation.expiryDate,
                          donation.status,
                          statusColor,
                          donation.id,
                        ),
                      );
                    },
                  ),
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'Approved':
        return const Color(0xFF4CAF50);
      case 'Delivered':
        return const Color(0xFF4A90E2);
      case 'Pending':
        return const Color(0xFFFFD93D);
      default:
        return Colors.grey;
    }
  }

  Widget _buildDonationCard(
    BuildContext context,
    String medicineName,
    String category,
    String quantity,
    String expiryDate,
    String status,
    Color statusColor,
    int? donationId,
  ) {
    return Card(
      elevation: 6,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => DeliveryDetails(donationId: donationId)),
          );
        },
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            gradient: const LinearGradient(
              colors: [
                Colors.white,
                Color(0xFFFFF3E0),
              ],
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFF6B35).withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.medication,
                      color: Color(0xFFFF6B35),
                      size: 28,
                    ),
                  ),
                  const SizedBox(width: 15),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          medicineName,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFFFF6B35),
                          ),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          category,
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: statusColor.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      status,
                      style: TextStyle(
                        color: statusColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 15),
              const Divider(),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildInfoItem('Quantity', quantity, Icons.format_list_numbered),
                  _buildInfoItem('Expiry', expiryDate, Icons.calendar_today),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoItem(String label, String value, IconData icon) {
    return Column(
      children: [
        Icon(icon, color: const Color(0xFF4A90E2), size: 20),
        const SizedBox(height: 5),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[600],
          ),
        ),
        const SizedBox(height: 3),
        Text(
          value,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: Color(0xFF4A90E2),
          ),
        ),
      ],
    );
  }
}
