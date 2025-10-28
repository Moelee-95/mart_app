import 'package:flutter/material.dart';
import 'package:grocery_stores/providers/smart_mart_provider.dart';
import 'package:provider/provider.dart';
import 'package:grocery_stores/generated/l10n.dart';

class AccountInfoScreen extends StatefulWidget {
  const AccountInfoScreen({super.key});

  @override
  State<AccountInfoScreen> createState() => _AccountInfoScreenState();
}

class _AccountInfoScreenState extends State<AccountInfoScreen> {
  // State variables that change during widget lifecycle
  bool isLoading = true;
  bool isEditing = false;
  bool isSaving = false;
  bool isDeletingAccount = false;

  // Form controllers
  final _emailController = TextEditingController();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _dateOfBirthController = TextEditingController();

  // User data
  String selectedGender = 'Female';
  bool receiveOffers = false;
  bool subscribeNewsletter = false;
  DateTime? selectedDate;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _firstNameController.dispose();
    _lastNameController.dispose();
    _dateOfBirthController.dispose();
    super.dispose();
  }

  // Simulate loading user data from API/Provider
  Future<void> _loadUserData() async {
    // Simulate network delay
    await Future.delayed(const Duration(seconds: 1));

    setState(() {
      // Load data from provider later
      _emailController.text = 'mohamadsalah11998822@gmail.com';
      _firstNameController.text = 'MO .Downhill';
      _lastNameController.text = '';
      _dateOfBirthController.text = '';
      selectedGender = 'Female';
      receiveOffers = false;
      subscribeNewsletter = false;
      isLoading = false;
    });
  }

  // Toggle edit mode
  void _toggleEditMode() {
    setState(() {
      isEditing = !isEditing;
    });
  }

  // Save user data
  Future<void> _saveUserData() async {
    setState(() {
      isSaving = true;
    });

    // Simulate saving to API/Provider
    await Future.delayed(const Duration(seconds: 1));

    if (mounted) {
      setState(() {
        isSaving = false;
        isEditing = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(S.of(context).accountInfoUpdatedSuccessfully),
          backgroundColor: Colors.green,
        ),
      );
    }
  }

  // Date picker
  Future<void> _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );

    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
        _dateOfBirthController.text =
            '${picked.day}/${picked.month}/${picked.year}';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Text(
          S.of(context).accountInfo,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w500,
            color: Colors.black,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          if (!isLoading && !isEditing)
            TextButton(
              onPressed: _toggleEditMode,
              child: Text(
                S.of(context).edit,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Colors.black,
                ),
              ),
            ),
        ],
      ),
      body: isLoading
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 16),
                  Text(
                    S.of(context).loadingAccountInfo,
                    style: TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            )
          : SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Email Field
                  _buildTextField(
                    controller: _emailController,
                    label: S.of(context).email,
                    enabled: isEditing,
                    keyboardType: TextInputType.emailAddress,
                  ),
                  const SizedBox(height: 16),

                  // First Name Field
                  _buildTextField(
                    controller: _firstNameController,
                    label: S.of(context).firstName,
                    enabled: isEditing,
                  ),
                  const SizedBox(height: 16),

                  // Last Name Field
                  _buildTextField(
                    controller: _lastNameController,
                    label: S.of(context).lastName,
                    enabled: isEditing,
                  ),
                  const SizedBox(height: 16),

                  // Date of Birth Field
                  _buildTextField(
                    controller: _dateOfBirthController,
                    label: S.of(context).dateOfBirthOptional,
                    enabled: isEditing,
                    readOnly: true,
                    suffixIcon: isEditing
                        ? IconButton(
                            icon: Icon(
                              Icons.calendar_today,
                              color: Colors.grey[600],
                            ),
                            onPressed: _selectDate,
                          )
                        : Icon(Icons.calendar_today, color: Colors.grey[600]),
                    onTap: isEditing ? _selectDate : null,
                  ),
                  const SizedBox(height: 24),

                  // Gender Section
                  _buildGenderSection(),
                  const SizedBox(height: 24),

                  // Checkbox Options
                  _buildCheckboxOption(
                    S.of(context).receiveOffersAndDiscounts,
                    receiveOffers,
                    (value) {
                      if (isEditing) {
                        setState(() {
                          receiveOffers = value ?? false;
                        });
                      }
                    },
                  ),
                  const SizedBox(height: 16),

                  _buildCheckboxOption(
                    S.of(context).subscribeToNewsletter,
                    subscribeNewsletter,
                    (value) {
                      if (isEditing) {
                        setState(() {
                          subscribeNewsletter = value ?? false;
                        });
                      }
                    },
                  ),
                  const SizedBox(height: 32),

                  // Action Buttons
                  if (isEditing) ...[
                    // Save Button
                    ElevatedButton(
                      onPressed: isSaving ? null : _saveUserData,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orange,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25),
                        ),
                      ),
                      child: Text(
                        isSaving ? S.of(context).saving : S.of(context).save,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ] else ...[
                    // Delete Account Button
                    OutlinedButton(
                      onPressed: isDeletingAccount
                          ? null
                          : _showDeleteAccountDialog,
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.black,
                        side: BorderSide(color: Colors.grey[300]!),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25),
                        ),
                      ),
                      child: Text(
                        isDeletingAccount
                            ? S.of(context).deleting
                            : S.of(context).deleteAccount,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    bool enabled = true,
    bool readOnly = false,
    TextInputType? keyboardType,
    Widget? suffixIcon,
    VoidCallback? onTap,
  }) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[300]!),
        color: enabled ? Colors.white : Colors.grey[50],
      ),
      child: TextField(
        controller: controller,
        enabled: enabled,
        readOnly: readOnly,
        keyboardType: keyboardType,
        onTap: onTap,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(color: Colors.grey[600]),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.all(16),
          suffixIcon: suffixIcon,
        ),
      ),
    );
  }

  Widget _buildGenderSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          S.of(context).genderOptional,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            _buildRadioOption(S.of(context).male),
            const SizedBox(width: 32),
            _buildRadioOption(S.of(context).female),
          ],
        ),
      ],
    );
  }

  Widget _buildRadioOption(String value) {
    return Row(
      children: [
        Radio<String>(
          value: value,
          groupValue: selectedGender,
          onChanged: isEditing
              ? (String? newValue) {
                  setState(() {
                    selectedGender = newValue ?? 'Female';
                  });
                }
              : null,
          activeColor: Colors.black,
        ),
        Text(value, style: const TextStyle(fontSize: 16, color: Colors.black)),
      ],
    );
  }

  Widget _buildCheckboxOption(
    String title,
    bool value,
    ValueChanged<bool?> onChanged,
  ) {
    return Row(
      children: [
        Checkbox(
          value: value,
          onChanged: isEditing ? onChanged : null,
          activeColor: Colors.orange,
        ),
        Expanded(
          child: Text(
            title,
            style: const TextStyle(fontSize: 16, color: Colors.black),
          ),
        ),
      ],
    );
  }

  void _showDeleteAccountDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(S.of(context).deleteAccount),
          content: Text(S.of(context).deleteAccountConfirmation),

          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(S.of(context).cancel),
            ),
            ElevatedButton(
              onPressed: () async {
                Navigator.of(context).pop();
                setState(() {
                  isDeletingAccount = true;
                });

                // Simulate delete process
                await Future.delayed(const Duration(seconds: 2));

                if (mounted) {
                  // Handle account deletion - logout and navigate to sign in
                  context.read<SmartMart>().customerLogout();
                  Navigator.of(
                    context,
                  ).pushNamedAndRemoveUntil('/signin', (route) => false);
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
              ),
              child: Text(S.of(context).delete),
            ),
          ],
        );
      },
    );
  }
}
