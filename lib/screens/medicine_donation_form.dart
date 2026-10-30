import 'package:flutter/material.dart';
import '../database/database_helper.dart';
import '../models/donation_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MedicineDonationForm extends StatefulWidget {
  const MedicineDonationForm({super.key});

  @override
  State<MedicineDonationForm> createState() => _MedicineDonationFormState();
}

class _MedicineDonationFormState extends State<MedicineDonationForm> {
  final _formKey = GlobalKey<FormState>();
  final _medicineNameController = TextEditingController();
  final _quantityController = TextEditingController();
  final _expiryDateController = TextEditingController();
  final _descriptionController = TextEditingController();
  String _selectedCategory = 'Tablets';
  final List<String> _categories = ['Tablets', 'Syrup', 'Injection', 'Capsules', 'Ointment', 'Other'];

  @override
  void dispose() {
    _medicineNameController.dispose();
    _quantityController.dispose();
    _expiryDateController.dispose();
    _descriptionController.dispose();
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
          title: const Text('Donate Medicine'),
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
                            Icons.medication,
                            size: 48,
                            color: Color(0xFFFF6B35),
                          ),
                        ),
                        const SizedBox(height: 20),
                        const Text(
                          'Fill in the medicine details',
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
                _buildDropdown(),
                const SizedBox(height: 15),
                _buildTextField(
                  _quantityController,
                  'Quantity',
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
                _buildTextField(
                  _expiryDateController,
                  'Expiry Date (DD/MM/YYYY)',
                  Icons.calendar_today,
                  keyboardType: TextInputType.datetime,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter expiry date';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 15),
                _buildTextField(
                  _descriptionController,
                  'Description (Optional)',
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
                      'Submit Donation',
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
          initialValue: _selectedCategory,
          decoration: const InputDecoration(
            labelText: 'Category',
            prefixIcon: Icon(Icons.category, color: Color(0xFFFF6B35)),
            border: InputBorder.none,
          ),
          items: _categories.map((String category) {
            return DropdownMenuItem<String>(
              value: category,
              child: Text(category),
            );
          }).toList(),
          onChanged: (String? newValue) {
            setState(() {
              _selectedCategory = newValue!;
            });
          },
        ),
      ),
    );
  }

  Future<void> _showSuccessDialog() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final userName = prefs.getString('userName') ?? 'Anonymous';
      final userEmail = prefs.getString('userEmail') ?? 'anonymous@email.com';
      final userPhone = prefs.getString('userPhone') ?? '0000000000';

      final donation = DonationModel(
        medicineName: _medicineNameController.text,
        category: _selectedCategory,
        quantity: int.parse(_quantityController.text),
        expiryDate: _expiryDateController.text,
        description: _descriptionController.text,
        donorName: userName,
        donorEmail: userEmail,
        donorPhone: userPhone,
      );

      await DatabaseHelper.instance.createDonation(donation);

      if (mounted) {
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
            content: const Text('Your medicine donation has been submitted successfully!'),
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
        content: Text('Failed to submit donation: $error'),
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
