import 'package:flutter/material.dart';
import '../database/database_helper.dart';
import '../models/donation_model.dart';
import 'medicine_request.dart';

class MedicineResult extends StatefulWidget {
  final String? searchQuery;
  const MedicineResult({super.key, this.searchQuery});

  @override
  State<MedicineResult> createState() => _MedicineResultState();
}

class _MedicineResultState extends State<MedicineResult> {
  List<DonationModel> _donations = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadDonations();
  }

  Future<void> _loadDonations() async {
    try {
      final donations = await DatabaseHelper.instance.getAllDonations();
      
      if (mounted) {
        setState(() {
          if (widget.searchQuery != null && widget.searchQuery!.isNotEmpty) {
            _donations = donations
                .where((d) => d.medicineName.toLowerCase().contains(widget.searchQuery!.toLowerCase()))
                .toList();
          } else {
            _donations = donations;
          }
          _isLoading = false;
        });
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
            Color(0xFFE3F2FD),
            Color(0xFFFFF3E0),
          ],
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          title: const Text('Medicine Results'),
          backgroundColor: const Color(0xFF4A90E2),
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
                          Icons.search_off,
                          size: 64,
                          color: Colors.grey[400],
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'No medicines found',
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.grey[600],
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          widget.searchQuery != null
                              ? 'Try a different search term'
                              : 'No donations available yet',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[500],
                          ),
                        ),
                      ],
                    ),
                  )
                : ListView(
                    padding: const EdgeInsets.all(20),
                    children: [
                      const SizedBox(height: 10),
                      Card(
                        elevation: 6,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                        child: Padding(
                          padding: const EdgeInsets.all(20),
                          child: Column(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: const Color(0xFF4CAF50).withValues(alpha: 0.1),
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.check_circle,
                                  size: 48,
                                  color: Color(0xFF4CAF50),
                                ),
                              ),
                              const SizedBox(height: 15),
                              const Text(
                                'Available Medicines',
                                style: TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF4A90E2),
                                ),
                              ),
                              const SizedBox(height: 5),
                              Text(
                                '${_donations.length} matches found',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey[600],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      ..._donations.map((donation) {
                        final availabilityColor = donation.status == 'Pending'
                            ? const Color(0xFF4CAF50)
                            : const Color(0xFFFFD93D);
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 15),
                          child: _buildMedicineCard(
                            donation.medicineName,
                            donation.category,
                            donation.quantity.toString(),
                            donation.expiryDate,
                            donation.donorName,
                            availabilityColor,
                            donation.id,
                          ),
                        );
                      }),
                    ],
                  ),
      ),
    );
  }

  Widget _buildMedicineCard(
    String medicineName,
    String category,
    String quantity,
    String expiryDate,
    String donor,
    Color availabilityColor,
    int? donationId,
  ) {
    return Card(
      elevation: 6,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: const LinearGradient(
            colors: [
              Colors.white,
              Color(0xFFE3F2FD),
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
                    color: const Color(0xFF4A90E2).withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.medication,
                    color: Color(0xFF4A90E2),
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
                          color: Color(0xFF4A90E2),
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
                    color: availabilityColor.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    availabilityColor == const Color(0xFF4CAF50) ? 'Available' : 'Reserved',
                    style: TextStyle(
                      color: availabilityColor,
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
            const SizedBox(height: 15),
            Row(
              children: [
                const Icon(Icons.person, color: Color(0xFFFF6B35), size: 20),
                const SizedBox(width: 10),
                Text(
                  'Donor: $donor',
                  style: const TextStyle(
                    fontSize: 14,
                    color: Color(0xFFFF6B35),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 15),
            SizedBox(
              width: double.infinity,
              height: 45,
              child: ElevatedButton(
                onPressed: availabilityColor == const Color(0xFF4CAF50)
                    ? () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => MedicineRequest(
                              preSelectedDonationId: donationId,
                              preSelectedMedicine: medicineName,
                            ),
                          ),
                        );
                      }
                    : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF4A90E2),
                  disabledBackgroundColor: Colors.grey,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Request This Medicine',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
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
