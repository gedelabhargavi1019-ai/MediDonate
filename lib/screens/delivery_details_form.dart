import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../database/database_helper.dart';
import '../models/delivery_model.dart';
import '../models/request_model.dart';

class DeliveryDetailsForm extends StatefulWidget {
  final RequestModel request;
  final int donationId;

  const DeliveryDetailsForm({
    super.key,
    required this.request,
    required this.donationId,
  });

  @override
  State<DeliveryDetailsForm> createState() => _DeliveryDetailsFormState();
}

class _DeliveryDetailsFormState extends State<DeliveryDetailsForm> {
  final _formKey = GlobalKey<FormState>();
  final _recipientNameController = TextEditingController();
  final _recipientPhoneController = TextEditingController();
  final _deliveryAddressController = TextEditingController();
  final _deliveryDateController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _recipientNameController.text = widget.request.receiverName;
    _recipientPhoneController.text = widget.request.receiverPhone;
    _deliveryAddressController.text = widget.request.receiverAddress;
    _deliveryDateController.text = DateFormat('dd/MM/yyyy').format(
      DateTime.now().add(const Duration(days: 2)),
    );
  }

  @override
  void dispose() {
    _recipientNameController.dispose();
    _recipientPhoneController.dispose();
    _deliveryAddressController.dispose();
    _deliveryDateController.dispose();
    super.dispose();
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
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
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
                            color: const Color(0xFFFF6B35).withValues(alpha: 0.1),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.local_shipping,
                            size: 48,
                            color: Color(0xFFFF6B35),
                          ),
                        ),
                        const SizedBox(height: 20),
                        const Text(
                          'Provide Delivery Information',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFFFF6B35),
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          'Medicine: ${widget.request.medicineName}',
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
                _buildTextField(
                  _recipientNameController,
                  'Recipient Name',
                  Icons.person,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter recipient name';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 15),
                _buildTextField(
                  _recipientPhoneController,
                  'Recipient Phone',
                  Icons.phone,
                  keyboardType: TextInputType.phone,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter phone number';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 15),
                _buildTextField(
                  _deliveryAddressController,
                  'Delivery Address',
                  Icons.location_on,
                  maxLines: 3,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter delivery address';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 15),
                _buildTextField(
                  _deliveryDateController,
                  'Preferred Delivery Date (DD/MM/YYYY)',
                  Icons.calendar_today,
                  keyboardType: TextInputType.datetime,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter delivery date';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 30),
                SizedBox(
                  width: double.infinity,
                  height: 55,
                  child: ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        _submitDeliveryDetails();
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFFF6B35),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      'Submit Delivery Details',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(
    TextEditingController controller,
    String label,
    IconData icon, {
    TextInputType? keyboardType,
    int maxLines = 1,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      maxLines: maxLines,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: const Color(0xFFFF6B35)),
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFFFF6B35)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFFFF6B35)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFF4A90E2), width: 2),
        ),
      ),
      validator: validator,
    );
  }

  Future<void> _submitDeliveryDetails() async {
    try {
      final delivery = DeliveryModel(
        requestId: widget.request.id!,
        donationId: widget.donationId,
        recipientName: _recipientNameController.text,
        recipientPhone: _recipientPhoneController.text,
        deliveryAddress: _deliveryAddressController.text,
        deliveryDate: _deliveryDateController.text,
        trackingNumber: 'MD${DateTime.now().millisecondsSinceEpoch}',
      );

      await DatabaseHelper.instance.createDelivery(delivery);

      // Update request status to Approved
      final updatedRequest = widget.request.copyWith(status: 'Approved');
      await DatabaseHelper.instance.updateRequest(updatedRequest);

      // Update donation status to Approved
      final donation = await DatabaseHelper.instance.getDonation(widget.donationId);
      if (donation != null) {
        final updatedDonation = donation.copyWith(status: 'Approved');
        await DatabaseHelper.instance.updateDonation(updatedDonation);
      }

      if (mounted) {
        _showSuccessDialog();
      }
    } catch (e) {
      if (mounted) {
        _showErrorDialog(e.toString());
      }
    }
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Row(
          children: [
            Icon(Icons.check_circle, color: Color(0xFF4CAF50), size: 32),
            SizedBox(width: 10),
            Text('Success'),
          ],
        ),
        content: const Text('Delivery details submitted successfully! Your request has been approved.'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
              Navigator.pop(context);
            },
            child: const Text('OK', style: TextStyle(color: Color(0xFFFF6B35))),
          ),
        ],
      ),
    );
  }

  void _showErrorDialog(String error) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Row(
          children: [
            Icon(Icons.error, color: Color(0xFFFF6B35), size: 32),
            SizedBox(width: 10),
            Text('Error'),
          ],
        ),
        content: Text('Failed to submit delivery details: $error'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK', style: TextStyle(color: Color(0xFFFF6B35))),
          ),
        ],
      ),
    );
  }
}
