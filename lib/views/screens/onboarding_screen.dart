import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ecommerce/config/app_colors.dart';
import 'package:ecommerce/config/app_styles.dart';
import 'package:ecommerce/controllers/auth_controller.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({Key? key}) : super(key: key);

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final authController = Get.find<AuthController>();

  String? selectedGender;
  String? selectedAgeRange;
  int _currentStep = 0;

  final List<String> genders = ['Man', 'Women'];
  final List<String> ageRanges = ['18-24', '25-34', '35-44', '45-54', '55+'];

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDarkMode
          ? AppColors.darkBackground
          : AppColors.lightBackground,
      appBar: AppBar(
        backgroundColor: isDarkMode
            ? AppColors.darkBackground
            : AppColors.lightBackground,
        elevation: 0,
        leading: _currentStep > 0
            ? IconButton(
                icon: Icon(
                  Icons.arrow_back,
                  color: isDarkMode ? AppColors.darkText : AppColors.lightText,
                ),
                onPressed: () {
                  setState(() {
                    _currentStep--;
                  });
                },
              )
            : null,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Tell us About yourself',
                style: AppStyles.displayMedium.copyWith(
                  color: isDarkMode ? AppColors.darkText : AppColors.lightText,
                ),
              ),
              const SizedBox(height: 30),

              if (_currentStep == 0) ...[
                // Gender Selection Step
                Text(
                  'Who do you shop for ?',
                  style: AppStyles.headlineMedium.copyWith(
                    color: isDarkMode
                        ? AppColors.darkText
                        : AppColors.lightText,
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  children:
                      [
                            ...genders.map((gender) {
                              return Expanded(
                                child: GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      selectedGender = gender;
                                    });
                                  },
                                  child: _buildSelectionCard(
                                    label: gender,
                                    isSelected: selectedGender == gender,
                                    isDarkMode: isDarkMode,
                                  ),
                                ),
                              );
                            }).toList(),
                          ]
                          .expand(
                            (widget) => [widget, const SizedBox(width: 12)],
                          )
                          .toList()
                        ..removeLast(),
                ),
                const SizedBox(height: 40),
                // Continue Button
                _buildPrimaryButton(
                  label: 'Continue',
                  onPressed: selectedGender != null
                      ? () {
                          setState(() {
                            _currentStep++;
                          });
                        }
                      : null,
                ),
              ] else if (_currentStep == 1) ...[
                // Age Range Selection Step
                Text(
                  'How Old are you ?',
                  style: AppStyles.headlineMedium.copyWith(
                    color: isDarkMode
                        ? AppColors.darkText
                        : AppColors.lightText,
                  ),
                ),
                const SizedBox(height: 20),
                Column(
                  children: [
                    ...ageRanges.map((ageRange) {
                      return Column(
                        children: [
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                selectedAgeRange = ageRange;
                              });
                            },
                            child: _buildAgeRangeOption(
                              label: ageRange,
                              isSelected: selectedAgeRange == ageRange,
                              isDarkMode: isDarkMode,
                            ),
                          ),
                          const SizedBox(height: 12),
                        ],
                      );
                    }).toList(),
                  ],
                ),
                const SizedBox(height: 40),
                // Finish Button
                _buildPrimaryButton(
                  label: 'Finish',
                  onPressed: selectedAgeRange != null
                      ? () {
                          authController.completeOnboarding(
                            gender: selectedGender,
                            ageRange: selectedAgeRange,
                          );
                          Get.offNamed('/home');
                        }
                      : null,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSelectionCard({
    required String label,
    required bool isSelected,
    required bool isDarkMode,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(
        color: isSelected
            ? AppColors.lightPrimary
            : (isDarkMode ? Color(0xFF3A3A3A) : Color(0xFFF5F5F5)),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Center(
        child: Text(
          label,
          style: AppStyles.bodyMedium.copyWith(
            color: isSelected
                ? Colors.white
                : (isDarkMode ? AppColors.darkText : AppColors.lightText),
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  Widget _buildAgeRangeOption({
    required String label,
    required bool isSelected,
    required bool isDarkMode,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: isSelected
            ? AppColors.lightPrimary.withOpacity(0.1)
            : (isDarkMode ? Color(0xFF3A3A3A) : Color(0xFFF5F5F5)),
        borderRadius: BorderRadius.circular(12),
        border: isSelected
            ? Border.all(color: AppColors.lightPrimary, width: 2)
            : Border.all(
                color: isDarkMode
                    ? AppColors.darkBorder
                    : AppColors.lightBorder,
                width: 1,
              ),
      ),
      child: Row(
        children: [
          Text(
            label,
            style: AppStyles.bodyMedium.copyWith(
              color: isDarkMode ? AppColors.darkText : AppColors.lightText,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
            ),
          ),
          const Spacer(),
          if (isSelected)
            Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                color: AppColors.lightPrimary,
                shape: BoxShape.circle,
              ),
              child: const Center(
                child: Icon(Icons.check, color: Colors.white, size: 12),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildPrimaryButton({
    required String label,
    required VoidCallback? onPressed,
  }) {
    return SizedBox(
      width: double.infinity,
      height: 48,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: onPressed != null
              ? AppColors.lightPrimary
              : AppColors.lightDisabled,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 0,
        ),
        child: Text(
          label,
          style: AppStyles.bodyMedium.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
