import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../theme/app_colors.dart';
import '../../utils/validators.dart';

class AddAddressScreen extends StatefulWidget {
  const AddAddressScreen({super.key});

  @override
  State<AddAddressScreen> createState() => _AddAddressScreenState();
}

class _AddAddressScreenState extends State<AddAddressScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _addressController = TextEditingController();
  final _cityController = TextEditingController();
  final _stateController = TextEditingController();
  final _pincodeController = TextEditingController();
  String _selectedType = 'Home';
  bool _isDefault = false;

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    _cityController.dispose();
    _stateController.dispose();
    _pincodeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(title: const Text('Add Address')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Address Type
              const Text(
                'Address Type',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 8),
              Row(
                children: ['Home', 'Office', 'Other'].map((type) {
                  return Expanded(
                    child: GestureDetector(
                      onTap: () => setState(() => _selectedType = type),
                      child: Container(
                        margin: const EdgeInsets.only(right: 12),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        decoration: BoxDecoration(
                          color: _selectedType == type
                              ? AppColors.primary
                              : AppColors.greyLight,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Center(
                          child: Text(
                            type,
                            style: TextStyle(
                              color: _selectedType == type
                                  ? AppColors.white
                                  : AppColors.black,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 24),

              TextFormField(
                controller: _nameController,
                validator: (v) => Validators.validateRequired(v, 'Name'),
                decoration: InputDecoration(
                  labelText: 'Full Name',
                  prefixIcon: Icon(Icons.person_outline, color: AppColors.primary),
                ),
              ),
              const SizedBox(height: 16),

              TextFormField(
                controller: _phoneController,
                keyboardType: TextInputType.phone,
                validator: Validators.validatePhone,
                decoration: InputDecoration(
                  labelText: 'Phone Number',
                  prefixIcon: Icon(Icons.phone_outlined, color: AppColors.primary),
                ),
              ),
              const SizedBox(height: 16),

              TextFormField(
                controller: _addressController,
                maxLines: 2,
                validator: (v) => Validators.validateRequired(v, 'Address'),
                decoration: InputDecoration(
                  labelText: 'Address',
                  prefixIcon: Icon(Icons.location_on_outlined, color: AppColors.primary),
                ),
              ),
              const SizedBox(height: 16),

              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _cityController,
                      validator: (v) => Validators.validateRequired(v, 'City'),
                      decoration: InputDecoration(
                        labelText: 'City',
                        prefixIcon: Icon(Icons.location_city, color: AppColors.primary),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: TextFormField(
                      controller: _stateController,
                      validator: (v) => Validators.validateRequired(v, 'State'),
                      decoration: InputDecoration(
                        labelText: 'State',
                        prefixIcon: Icon(Icons.map, color: AppColors.primary),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              TextFormField(
                controller: _pincodeController,
                keyboardType: TextInputType.number,
                validator: Validators.validatePincode,
                decoration: InputDecoration(
                  labelText: 'Pincode',
                  prefixIcon: Icon(Icons.pin_drop, color: AppColors.primary),
                ),
              ),
              const SizedBox(height: 16),

              // Default Address
              Row(
                children: [
                  Checkbox(
                    value: _isDefault,
                    onChanged: (v) => setState(() => _isDefault = v!),
                    activeColor: AppColors.primary,
                  ),
                  const Text('Set as default address'),
                ],
              ),
              const SizedBox(height: 32),

              SizedBox(
                width: double.infinity,
                height: 54,
                child: ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      Get.back();
                      Get.snackbar('Success', 'Address saved successfully');
                    }
                  },
                  child: const Text('Save Address', style: TextStyle(fontSize: 18)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
