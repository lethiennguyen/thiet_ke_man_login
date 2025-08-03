import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ma_so_thue/ui/common/app_colors.dart';

/// A sleek, modern input field with built‑in clear & eye buttons,
/// animated focus border, and responsive width.
class ModernInputField extends StatefulWidget {
  final String label;
  final String hintText;
  final TextEditingController controller;
  final FocusNode focusNode;
  final TextInputType keyboardType;
  final bool isPassword;

  const ModernInputField({
    super.key,
    required this.label,
    required this.hintText,
    required this.controller,
    required this.focusNode,
    this.keyboardType = TextInputType.text,
    this.isPassword = false,
  });

  @override
  State<ModernInputField> createState() => _ModernInputFieldState();
}

class _ModernInputFieldState extends State<ModernInputField> {
  bool _obscure = true;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Label
        Text(
          widget.label,
          style: GoogleFonts.nunitoSans(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: theme.colorScheme.onBackground,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          focusNode: widget.focusNode,
          controller: widget.controller,
          keyboardType: widget.keyboardType,
          cursorColor: Colors.white,
          style: GoogleFonts.nunitoSans(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.white,
            hintText: widget.hintText,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 18,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: kBrandOrange, width: 2),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Color(0xffEBECED), width: 2),
            ),
          ),
        ),
        SizedBox(height: 8),
      ],
    );
  }
}

// Dăng Nhap Field
class CustomInputField extends StatelessWidget {
  final String label;
  final String hintText;
  final TextInputType keyboardType;
  final TextEditingController controller;
  final bool isFocused;
  final bool isColorBorder;
  final bool isPassword;
  final bool isPasswordVisible;
  final String? errorText;
  final VoidCallback? onClear;
  final VoidCallback? onTogglePassword;
  final FocusNode focusNode;
  final ValueChanged<String>? onChanged;
  final FormFieldValidator<String>? validator;

  const CustomInputField({
    super.key,
    required this.label,
    required this.hintText,
    required this.keyboardType,
    required this.controller,
    required this.isFocused,
    required this.isColorBorder,
    required this.isPassword,
    required this.isPasswordVisible,
    required this.errorText,
    required this.focusNode,
    this.onClear,
    this.onTogglePassword,
    this.onChanged,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 343,
          height: 86,
          child: Stack(
            children: [
              Container(
                padding: const EdgeInsets.only(bottom: 62),
                child: Text(
                  label,
                  style: GoogleFonts.nunitoSans(
                    fontWeight: FontWeight.w700,
                    fontSize: 16,
                    color: const Color(0xff242E37),
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.only(top: 32),
                child: AnimatedContainer(
                  height: 54,
                  duration: const Duration(milliseconds: 300),
                  decoration: BoxDecoration(
                    border: Border.all(
                      width: 1,
                      color:
                          isColorBorder
                              ? const Color(0xffF24E1E)
                              : const Color(0xffEBECED),
                    ),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Container(
                    padding: const EdgeInsets.only(
                      bottom: 15,
                      top: 15,
                      left: 16,
                    ),
                    child: TextFormField(
                      focusNode: focusNode,
                      keyboardType: keyboardType,
                      obscureText: isPassword ? !isPasswordVisible : false,
                      controller: controller,
                      cursorColor: const Color(0xffF24E1E),
                      decoration: InputDecoration(
                        hintText: hintText,
                        suffixIcon:
                            isPassword
                                ? GestureDetector(
                                  onTap: onTogglePassword,
                                  child: SvgPicture.asset(
                                    isPasswordVisible
                                        ? 'asset/eye-slash.svg'
                                        : 'asset/eye.svg',
                                    width: 20,
                                    height: 20,
                                  ),
                                )
                                : controller.text.isNotEmpty
                                ? GestureDetector(
                                  onTap: onClear,
                                  child: SvgPicture.asset(
                                    'asset/clear.svg',
                                    width: 20,
                                    height: 20,
                                  ),
                                )
                                : null,
                        border: InputBorder.none,
                      ),
                      onChanged: onChanged,
                      validator: validator,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.only(right: 16),
          height: 16,
          child: Align(
            alignment: Alignment.centerRight,
            child: Text(
              errorText ?? '',
              style: GoogleFonts.nunitoSans(
                fontWeight: FontWeight.w400,
                fontSize: 12,
                color: const Color(0xffFF0000),
              ),
            ),
          ),
        ),
        const SizedBox(height: 4),
      ],
    );
  }
}
