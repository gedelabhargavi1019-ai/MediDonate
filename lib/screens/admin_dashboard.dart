import 'package:flutter/material.dart';
import 'login_screen.dart';
import '../database/database_helper.dart';
import '../models/donation_model.dart';
import '../models/request_model.dart';
import 'delivery_details_form.dart';

class AdminDashboard extends StatefulWidget {
  const AdminDashboard({super.key});

  @override
  State<AdminDashboard> createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  List<DonationModel> _donations = [];
  List<RequestModel> _requests = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    try {
      final donations = await DatabaseHelper.instance.getAllDonations();
      final requests = await DatabaseHelper.instance.getAllRequests();
      
      if (mounted) {
        setState(() {
          _donations = donations;
          _requests = requests;
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
            Color(0xFFFFF9E6),
            Color(0xFFFFE4B5),
            Color(0xFFFFD93D),
          ],
        ),
      ),
      child: SafeArea(
        child: Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            title: const Text('Admin Dashboard'),
            backgroundColor: const Color(0xFFFFD93D),
            actions: [
              IconButton(
                icon: const Icon(Icons.refresh),
                onPressed: _loadData,
              ),
              IconButton(
                icon: const Icon(Icons.logout),
                onPressed: () {
                  _showLogoutDialog();
                },
              ),
            ],
          ),
          body: _isLoading
              ? const Center(child: CircularProgressIndicator())
              : SingleChildScrollView(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: const Color(0xFFFFD93D),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Icon(
                              Icons.admin_panel_settings,
                              color: Colors.white,
                              size: 28,
                            ),
                          ),
                          const SizedBox(width: 15),
                          const Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Admin Panel',
                                  style: TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFFFF6B35),
                                  ),
                                ),
                                Text(
                                  'Manage donations and requests',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Color(0xFF4A90E2),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 30),
                      Row(
                        children: [
                          Expanded(
                            child: _buildStatCard(
                              'Total Donations',
                              _donations.length.toString(),
                              Icons.medication,
                              const Color(0xFFFF6B35),
                            ),
                          ),
                          const SizedBox(width: 15),
                          Expanded(
                            child: _buildStatCard(
                              'Total Requests',
                              _requests.length.toString(),
                              Icons.request_page,
                              const Color(0xFF4A90E2),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 15),
                      Row(
                        children: [
                          Expanded(
                            child: _buildStatCard(
                              'Pending',
                              _requests.where((r) => r.status == 'Pending').length.toString(),
                              Icons.pending,
                              const Color(0xFFFFD93D),
                            ),
                          ),
                          const SizedBox(width: 15),
                          Expanded(
                            child: _buildStatCard(
                              'Approved',
                              _requests.where((r) => r.status == 'Approved').length.toString(),
                              Icons.check_circle,
                              const Color(0xFF4CAF50),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 30),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Recent Donations',
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFFFF6B35),
                            ),
                          ),
                          TextButton(
                            onPressed: () {},
                            child: const Text('View All'),
                          ),
                        ],
                      ),
                      const SizedBox(height: 15),
                      ..._donations.take(3).map((donation) {
                        final statusColor = _getStatusColor(donation.status);
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: _buildDonationCard(
                            donation.medicineName,
                            donation.donorName,
                            donation.status,
                            statusColor,
                            donation.id,
                          ),
                        );
                      }),
                      const SizedBox(height: 30),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Recent Requests',
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF4A90E2),
                            ),
                          ),
                          TextButton(
                            onPressed: () {},
                            child: const Text('View All'),
                          ),
                        ],
                      ),
                      const SizedBox(height: 15),
                      ..._requests.take(3).map((request) {
                        final priorityColor = _getPriorityColor(request.priority);
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: _buildRequestCard(
                            request.medicineName,
                            request.receiverName,
                            request.priority,
                            priorityColor,
                            request,
                          ),
                        );
                      }),
                    ],
                  ),
                ),
        ),
      ),
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon, Color color) {
    return Card(
      elevation: 6,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: LinearGradient(
            colors: [color.withValues(alpha: 0.1), color.withValues(alpha: 0.05)],
          ),
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 32),
            const SizedBox(height: 10),
            Text(
              value,
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            const SizedBox(height: 5),
            Text(
              title,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[700],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDonationCard(String medicine, String donor, String status, Color statusColor, int? donationId) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: const Color(0xFFFF6B35).withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(Icons.medication, color: Color(0xFFFF6B35)),
            ),
            const SizedBox(width: 15),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    medicine,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    'Donor: $donor',
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
      ),
    );
  }

  Widget _buildRequestCard(String medicine, String receiver, String priority, Color priorityColor, RequestModel request) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: const Color(0xFF4A90E2).withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(Icons.request_page, color: Color(0xFF4A90E2)),
            ),
            const SizedBox(width: 15),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    medicine,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    'Receiver: $receiver',
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
                color: priorityColor.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                priority,
                style: TextStyle(
                  color: priorityColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
            ),
            const SizedBox(width: 10),
            if (request.status == 'Pending')
              IconButton(
                icon: const Icon(Icons.check_circle, color: Color(0xFF4CAF50)),
                onPressed: () => _showApprovalDialog(request),
                tooltip: 'Approve Request',
              ),
          ],
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

  Color _getPriorityColor(String priority) {
    switch (priority) {
      case 'Urgent':
        return const Color(0xFFFF6B35);
      case 'High':
        return const Color(0xFFFFD93D);
      case 'Normal':
        return const Color(0xFF4A90E2);
      default:
        return Colors.grey;
    }
  }

  void _showApprovalDialog(RequestModel request) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Approve Request'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Medicine: ${request.medicineName}'),
            Text('Receiver: ${request.receiverName}'),
            Text('Quantity: ${request.quantity}'),
            const SizedBox(height: 10),
            const Text('Select a donation to fulfill this request:'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel', style: TextStyle(color: Color(0xFF4A90E2))),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _showDonationSelection(request);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFFF6B35),
            ),
            child: const Text('Select Donation'),
          ),
        ],
      ),
    );
  }

  void _showDonationSelection(RequestModel request) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Select Donation'),
        content: SizedBox(
          width: double.maxFinite,
          height: 300,
          child: _donations.isEmpty
              ? const Center(child: Text('No donations available'))
              : ListView.builder(
                  itemCount: _donations.length,
                  itemBuilder: (context, index) {
                    final donation = _donations[index];
                    return ListTile(
                      title: Text(donation.medicineName),
                      subtitle: Text('Qty: ${donation.quantity} | Donor: ${donation.donorName}'),
                      trailing: donation.status == 'Pending'
                          ? const Icon(Icons.check_circle, color: Color(0xFF4CAF50))
                          : const Icon(Icons.block, color: Colors.grey),
                      enabled: donation.status == 'Pending',
                      onTap: () {
                        Navigator.pop(context);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => DeliveryDetailsForm(
                              request: request,
                              donationId: donation.id!,
                            ),
                          ),
                        ).then((_) => _loadData());
                      },
                    );
                  },
                ),
        ),
      ),
    );
  }

  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Logout'),
        content: const Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel', style: TextStyle(color: Color(0xFF4A90E2))),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => const LoginScreen()),
              );
            },
            child: const Text('Logout', style: TextStyle(color: Color(0xFFFF6B35))),
          ),
        ],
      ),
    );
  }
}
