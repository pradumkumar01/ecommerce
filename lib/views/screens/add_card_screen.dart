import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:ecommerce/config/app_styles.dart';
import 'package:ecommerce/config/app_colors.dart';
import 'package:ecommerce/controllers/profile_controller.dart';

class AddCardScreen extends StatelessWidget {
  AddCardScreen({Key? key}) : super(key: key);

  final ProfileController controller = Get.find<ProfileController>();
  final _formKey = GlobalKey<FormState>();
  final selectedCardType = 'visa'.obs;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark
          ? AppColors.darkBackground
          : AppColors.lightBackground,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: isDark ? AppColors.darkText : AppColors.lightText,
          ),
          onPressed: () {
            controller.clearCardForm();
            Get.back();
          },
        ),
        title: Text(
          'Add Card',
          style: AppStyles.headlineLarge.copyWith(
            color: isDark ? AppColors.darkText : AppColors.lightText,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Card Preview
              Obx(() => _buildCardPreview(isDark)),
              const SizedBox(height: 32),
              // Card Type Selection
              _buildLabel('Card Type', isDark),
              const SizedBox(height: 12),
              Obx(() => _buildCardTypeSelector(isDark)),
              const SizedBox(height: 24),
              // Card Number
              _buildLabel('Card Number', isDark),
              const SizedBox(height: 8),
              _buildTextField(
                controller: controller.cardNumberController,
                hintText: '1234 5678 9012 3456',
                isDark: isDark,
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(16),
                  _CardNumberFormatter(),
                ],
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter card number';
                  }
                  final digits = value.replaceAll(' ', '');
                  if (digits.length < 16) {
                    return 'Card number must be 16 digits';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              // Expiry and CVV Row
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildLabel('Exp', isDark),
                        const SizedBox(height: 8),
                        _buildTextField(
                          controller: controller.expiryController,
                          hintText: 'MM/YY',
                          isDark: isDark,
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                            LengthLimitingTextInputFormatter(4),
                            _ExpiryDateFormatter(),
                          ],
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Required';
                            }
                            if (!value.contains('/') || value.length < 5) {
                              return 'Invalid format';
                            }
                            return null;
                          },
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildLabel('CCV', isDark),
                        const SizedBox(height: 8),
                        _buildTextField(
                          controller: controller.cvvController,
                          hintText: '123',
                          isDark: isDark,
                          keyboardType: TextInputType.number,
                          obscureText: true,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                            LengthLimitingTextInputFormatter(4),
                          ],
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Required';
                            }
                            if (value.length < 3) {
                              return 'Invalid CVV';
                            }
                            return null;
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              // Cardholder Name
              _buildLabel('Cardholder Name', isDark),
              const SizedBox(height: 8),
              _buildTextField(
                controller: controller.cardholderNameController,
                hintText: 'John Doe',
                isDark: isDark,
                textCapitalization: TextCapitalization.words,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter cardholder name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 40),
              // Save Card Button
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      controller.addPaymentCard(
                        cardType: selectedCardType.value,
                      );
                      Get.back();
                      Get.snackbar(
                        'Success',
                        'Card added successfully',
                        snackPosition: SnackPosition.BOTTOM,
                        backgroundColor: Colors.green,
                        colorText: Colors.white,
                        margin: const EdgeInsets.all(20),
                        borderRadius: 10,
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.lightPrimary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(28),
                    ),
                    elevation: 0,
                  ),
                  child: Text(
                    'Save Card',
                    style: AppStyles.bodyLarge.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCardPreview(bool isDark) {
    return Container(
      height: 200,
      decoration: BoxDecoration(
        gradient: _getCardGradient(selectedCardType.value),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Icon(Icons.credit_card, color: Colors.white, size: 32),
              _buildCardTypeIcon(selectedCardType.value),
            ],
          ),
          Text(
            controller.cardNumberController.text.isEmpty
                ? '**** **** **** ****'
                : _formatCardNumber(controller.cardNumberController.text),
            style: AppStyles.headlineLarge.copyWith(
              color: Colors.white,
              letterSpacing: 3,
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'CARD HOLDER',
                    style: AppStyles.bodySmall.copyWith(
                      color: Colors.white.withOpacity(0.7),
                      fontSize: 10,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    controller.cardholderNameController.text.isEmpty
                        ? 'YOUR NAME'
                        : controller.cardholderNameController.text
                              .toUpperCase(),
                    style: AppStyles.bodyMedium.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'EXPIRES',
                    style: AppStyles.bodySmall.copyWith(
                      color: Colors.white.withOpacity(0.7),
                      fontSize: 10,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    controller.expiryController.text.isEmpty
                        ? 'MM/YY'
                        : controller.expiryController.text,
                    style: AppStyles.bodyMedium.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCardTypeSelector(bool isDark) {
    final cardTypes = ['visa', 'mastercard', 'amex'];

    return Row(
      children: cardTypes.map((type) {
        final isSelected = selectedCardType.value == type;
        return Expanded(
          child: GestureDetector(
            onTap: () => selectedCardType.value = type,
            child: Container(
              margin: EdgeInsets.only(right: type != 'amex' ? 12 : 0),
              padding: const EdgeInsets.symmetric(vertical: 16),
              decoration: BoxDecoration(
                color: isSelected
                    ? AppColors.lightPrimary.withOpacity(0.1)
                    : isDark
                    ? const Color(0xFF2D2D2D)
                    : const Color(0xFFF5F5F5),
                borderRadius: BorderRadius.circular(12),
                border: isSelected
                    ? Border.all(color: AppColors.lightPrimary, width: 2)
                    : null,
              ),
              child: Center(
                child: Text(
                  type.toUpperCase(),
                  style: AppStyles.bodySmall.copyWith(
                    color: isSelected
                        ? AppColors.lightPrimary
                        : isDark
                        ? AppColors.darkText
                        : AppColors.lightText,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildCardTypeIcon(String cardType) {
    String text;
    switch (cardType) {
      case 'visa':
        text = 'VISA';
        break;
      case 'mastercard':
        text = 'MC';
        break;
      case 'amex':
        text = 'AMEX';
        break;
      default:
        text = 'CARD';
    }
    return Text(
      text,
      style: AppStyles.bodyMedium.copyWith(
        color: Colors.white,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  LinearGradient _getCardGradient(String cardType) {
    switch (cardType) {
      case 'visa':
        return const LinearGradient(
          colors: [Color(0xFF1A1F71), Color(0xFF2D3595)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        );
      case 'mastercard':
        return const LinearGradient(
          colors: [Color(0xFFEB001B), Color(0xFFF79E1B)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        );
      case 'amex':
        return const LinearGradient(
          colors: [Color(0xFF006FCF), Color(0xFF00A1E0)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        );
      default:
        return const LinearGradient(
          colors: [Color(0xFF4A4A4A), Color(0xFF6A6A6A)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        );
    }
  }

  String _formatCardNumber(String number) {
    final digits = number.replaceAll(' ', '');
    final buffer = StringBuffer();
    for (int i = 0; i < digits.length; i++) {
      if (i > 0 && i % 4 == 0) {
        buffer.write(' ');
      }
      buffer.write(digits[i]);
    }
    return buffer.toString().padRight(19, ' ');
  }

  Widget _buildLabel(String label, bool isDark) {
    return Text(
      label,
      style: AppStyles.bodyMedium.copyWith(
        color: isDark ? AppColors.darkText : AppColors.lightText,
        fontWeight: FontWeight.w600,
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hintText,
    required bool isDark,
    TextInputType keyboardType = TextInputType.text,
    bool obscureText = false,
    TextCapitalization textCapitalization = TextCapitalization.none,
    List<TextInputFormatter>? inputFormatters,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      obscureText: obscureText,
      textCapitalization: textCapitalization,
      inputFormatters: inputFormatters,
      validator: validator,
      onChanged: (_) {
        selectedCardType.refresh();
      },
      style: AppStyles.bodyMedium.copyWith(
        color: isDark ? AppColors.darkText : AppColors.lightText,
      ),
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: AppStyles.bodyMedium.copyWith(
          color: isDark
              ? AppColors.darkTextSecondary
              : AppColors.lightTextSecondary,
        ),
        filled: true,
        fillColor: isDark ? const Color(0xFF2D2D2D) : const Color(0xFFF5F5F5),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.lightPrimary, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.red, width: 1),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.red, width: 2),
        ),
      ),
    );
  }
}

class _CardNumberFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final text = newValue.text.replaceAll(' ', '');
    final buffer = StringBuffer();

    for (int i = 0; i < text.length; i++) {
      if (i > 0 && i % 4 == 0) {
        buffer.write(' ');
      }
      buffer.write(text[i]);
    }

    return TextEditingValue(
      text: buffer.toString(),
      selection: TextSelection.collapsed(offset: buffer.length),
    );
  }
}

class _ExpiryDateFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final text = newValue.text.replaceAll('/', '');
    final buffer = StringBuffer();

    for (int i = 0; i < text.length; i++) {
      if (i == 2) {
        buffer.write('/');
      }
      buffer.write(text[i]);
    }

    return TextEditingValue(
      text: buffer.toString(),
      selection: TextSelection.collapsed(offset: buffer.length),
    );
  }
}
