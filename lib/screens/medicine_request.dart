import 'package:flutter/material.dart';
import '../database/database_helper.dart';
import '../models/request_model.dart';
import '../models/donation_model.dart';
import 'delivery_details_form.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MedicineRequest extends StatefulWidget {
  final int? preSelectedDonationId;
  final String? preSelectedMedicine;
  const MedicineRequest({super.key, this.preSelectedDonationId, this.preSelectedMedicine});

  @override
  State<MedicineRequest> createState() => _MedicineRequestState();
}

class _MedicineRequestState extends State<MedicineRequest> {
  final _formKey = GlobalKey<FormState>();
  final _medicineNameController = TextEditingController();
  final _quantityController = TextEditingController();
  final _urgencyController = TextEditingController();
  String _selectedPriority = 'Normal';
  final List<String> _priorities = ['Normal', 'Urgent', 'Critical'];

  @override
  void initState() {
    super.initState();
    if (widget.preSelectedMedicine != null) {
      _medicineNameController.text = widget.preSelectedMedicine!;
    }
  }

  @override
  void dispose() {
    _medicineNameController.dispose();
    _quantityController.dispose();
    _urgencyController.dispose();
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
          title: const Text('Request Medicine'),
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
                            Icons.search,
                            size: 48,
                            color: Color(0xFFFF6B35),
                          ),
                        ),
                        const SizedBox(height: 20),
                        const Text(
                          'Request the medicine you need',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFFFF6B35),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                _buildTextField(
                  _medicineNameController,
                  'Medicine Name',
                  Icons.medication,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter medicine name';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 15),
                _buildTextField(
                  _quantityController,
                  'Quantity Needed',
                  Icons.format_list_numbered,
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter quantity';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 15),
                _buildDropdown(),
                const SizedBox(height: 15),
                _buildTextField(
                  _urgencyController,
                  'Additional Details (Optional)',
                  Icons.description,
                  maxLines: 3,
                ),
                const SizedBox(height: 30),
                SizedBox(
                  width: double.infinity,
                  height: 55,
                  child: ElevatedButton(
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        await _showSuccessDialog();
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFFF6B35),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      'Submit Request',
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

  Widget _buildDropdown() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFFF6B35)),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: DropdownButtonHideUnderline(
        child: DropdownButtonFormField<String>(
          initialValue: _selectedPriority,
          decoration: const InputDecoration(
            labelText: 'Priority Level',
            prefixIcon: Icon(Icons.priority_high, color: Color(0xFFFF6B35)),
            border: InputBorder.none,
          ),
          items: _priorities.map((String priority) {
            return DropdownMenuItem<String>(
              value: priority,
              child: Text(priority),
            );
          }).toList(),
          onChanged: (String? newValue) {
            setState(() {
              _selectedPriority = newValue!;
            });
          },
        ),
      ),
    );
  }

  Future<void> _showSuccessDialog() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final receiverName = prefs.getString('receiverName') ?? 'Anonymous';
      final receiverPhone = prefs.getString('receiverPhone') ?? '0000000000';
      final receiverAddress = prefs.getString('receiverAddress') ?? 'Unknown';
      final receiverEmail = prefs.getString('userEmail') ?? 'anonymous@email.com';
      final medicalCondition = prefs.getString('medicalCondition') ?? 'Not specified';

      final request = RequestModel(
        medicineName: _medicineNameController.text,
        quantity: int.parse(_quantityController.text),
        priority: _selectedPriority,
        additionalDetails: _urgencyController.text,
        receiverName: receiverName,
        receiverEmail: receiverEmail,
        receiverPhone: receiverPhone,
        receiverAddress: receiverAddress,
        medicalCondition: medicalCondition,
      );

      final requestId = await DatabaseHelper.instance.createRequest(request);

      DonationModel? matchingDonation;
      
      // If a donation was pre-selected, use it directly
      if (widget.preSelectedDonationId != null) {
        matchingDonation = await DatabaseHelper.instance.getDonation(widget.preSelectedDonationId!);
      } else {
        // Find a matching donation
        final donations = await DatabaseHelper.instance.getAllDonations();
        for (var donation in donations) {
          if (donation.medicineName.toLowerCase().contains(_medicineNameController.text.toLowerCase()) &&
              donation.status == 'Pending' &&
              donation.quantity >= int.parse(_quantityController.text)) {
            matchingDonation = donation;
            break;
          }
        }
      }

      if (mounted) {
        if (matchingDonation != null) {
          final donationId = matchingDonation.id;
          if (donationId != null) {
            // Navigate to delivery details form
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => DeliveryDetailsForm(
                  request: request.copyWith(id: requestId),
                  donationId: donationId,
                ),
              ),
            );
          } else {
            // Show success dialog without matching donation
            showDialog(
              context: context,
              builder: (context) => AlertDialog(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                title: const Row(
                  children: [
                    Icon(Icons.check_circle, color: Color(0xFF4CAF50), size: 32),
                    SizedBox(width: 10),
                    Text('Request Submitted'),
                  ],
                ),
                content: const Text('Your medicine request has been submitted successfully! We will notify you when a matching donation is available.'),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                      Navigator.pop(context);
                    },
                    child: const Text('OK', style: TextStyle(color: Color(0xFFFF6B35))),
                  ),
                ],
              ),
            );
          }
        } else {
          // Show success dialog without matching donation
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              title: const Row(
                children: [
                  Icon(Icons.check_circle, color: Color(0xFF4CAF50), size: 32),
                  SizedBox(width: 10),
                  Text('Request Submitted'),
                ],
              ),
              content: const Text('Your medicine request has been submitted successfully! We will notify you when a matching donation is available.'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                    Navigator.pop(context);
                  },
                  child: const Text('OK', style: TextStyle(color: Color(0xFFFF6B35))),
                ),
              ],
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        _showErrorDialog(e.toString());
      }
    }
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
        content: Text('Failed to submit request: $error'),
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
