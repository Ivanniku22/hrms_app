import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controller/auth_controller.dart';

class LoginView extends GetView<AuthController> {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F7FB),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(24, 40, 24, 32),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 430),
              child: Column(
                children: [
                  // App logo
                  Container(
                    width: 82,
                    height: 82,
                    decoration: BoxDecoration(
                      color: const Color(0xFFEFF6FF),
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: const Icon(
                      Icons.business_rounded,
                      size: 42,
                      color: Color(0xFF2563EB),
                    ),
                  ),

                  const SizedBox(height: 22),

                  const Text(
                    'Welcome to HRMS',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF111827),
                    ),
                  ),

                  const SizedBox(height: 8),

                  const Text(
                    'Sign in to manage your work,\nattendance and leave.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14,
                      height: 1.5,
                      color: Color(0xFF6B7280),
                    ),
                  ),

                  const SizedBox(height: 34),

                  // Login form
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: const Color(0xFFE5E7EB)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Sign In',
                          style: TextStyle(
                            fontSize: 19,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF111827),
                          ),
                        ),

                        const SizedBox(height: 18),

                        TextField(
                          keyboardType: TextInputType.emailAddress,
                          textInputAction: TextInputAction.next,
                          onChanged: (value) {
                            controller.email.value = value;
                          },
                          decoration: InputDecoration(
                            labelText: 'Email',
                            hintText: 'Enter your email',
                            prefixIcon: const Icon(
                              Icons.email_outlined,
                              color: Color(0xFF6B7280),
                            ),
                            filled: true,
                            fillColor: const Color(0xFFF9FAFB),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(14),
                              borderSide: const BorderSide(
                                color: Color(0xFFE5E7EB),
                              ),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(14),
                              borderSide: const BorderSide(
                                color: Color(0xFFE5E7EB),
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(14),
                              borderSide: const BorderSide(
                                color: Color(0xFF2563EB),
                                width: 1.5,
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(height: 14),

                        Obx(
                          () => TextField(
                            obscureText: controller.obscurePassword.value,
                            onChanged: (value) {
                              controller.password.value = value;
                            },
                            decoration: InputDecoration(
                              labelText: 'Password',
                              hintText: 'Enter your password',
                              prefixIcon: const Icon(
                                Icons.lock_outline_rounded,
                                color: Color(0xFF6B7280),
                              ),
                              suffixIcon: IconButton(
                                onPressed: controller.togglePasswordVisibility,
                                icon: Icon(
                                  controller.obscurePassword.value
                                      ? Icons.visibility_outlined
                                      : Icons.visibility_off_outlined,
                                  color: const Color(0xFF6B7280),
                                ),
                              ),
                              filled: true,
                              fillColor: const Color(0xFFF9FAFB),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(14),
                                borderSide: const BorderSide(
                                  color: Color(0xFFE5E7EB),
                                ),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(14),
                                borderSide: const BorderSide(
                                  color: Color(0xFFE5E7EB),
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(14),
                                borderSide: const BorderSide(
                                  color: Color(0xFF2563EB),
                                  width: 1.5,
                                ),
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(height: 22),

                        Obx(
                          () => SizedBox(
                            width: double.infinity,
                            height: 52,
                            child: ElevatedButton(
                              onPressed: controller.isLoading.value
                                  ? null
                                  : controller.login,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF2563EB),
                                foregroundColor: Colors.white,
                                disabledBackgroundColor: const Color(
                                  0xFF93C5FD,
                                ),
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(14),
                                ),
                              ),
                              child: controller.isLoading.value
                                  ? const SizedBox(
                                      height: 21,
                                      width: 21,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2.5,
                                        color: Colors.white,
                                      ),
                                    )
                                  : const Text(
                                      'Sign In',
                                      style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  const Text(
                    'HRMS • Employee Management System',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 12, color: Color(0xFF9CA3AF)),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
