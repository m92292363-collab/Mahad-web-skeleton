import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _otpController = TextEditingController();
  bool _isLoading = false;
  bool _isOtpSent = false;
  String _verificationId = '';
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    _initializeFirebase();
  }

  Future<void> _initializeFirebase() async {
    await Firebase.initializeApp();
  }

  Future<void> _sendOtp() async {
    if (_phoneController.text.isEmpty) {
      setState(() {
        _errorMessage = 'Please enter your phone number';
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });

    try {
      await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: '+220${_phoneController.text}', // Gambia country code
        verificationCompleted: (PhoneAuthCredential credential) async {
          await FirebaseAuth.instance.signInWithCredential(credential);
          _navigateToHome();
        },
        verificationFailed: (FirebaseAuthException e) {
          setState(() {
            _isLoading = false;
            _errorMessage = 'Failed to send OTP: ${e.message}';
          });
        },
        codeSent: (String verificationId, int? resendToken) {
          setState(() {
            _isOtpSent = true;
            _verificationId = verificationId;
            _isLoading = false;
          });
        },
        codeAutoRetrievalTimeout: (String verificationId) {
          setState(() {
            _verificationId = verificationId;
          });
        },
      );
    } catch (e) {
      setState(() {
        _isLoading = false;
        _errorMessage = 'Error: $e';
      });
    }
  }

  Future<void> _verifyOtp() async {
    if (_otpController.text.isEmpty) {
      setState(() {
        _errorMessage = 'Please enter the OTP';
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });

    try {
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: _verificationId,
        smsCode: _otpController.text,
      );
      
      await FirebaseAuth.instance.signInWithCredential(credential);
      _navigateToHome();
    } catch (e) {
      setState(() {
        _isLoading = false;
        _errorMessage = 'Invalid OTP. Please try again.';
      });
    }
  }

  void _navigateToHome() {
    Navigator.pushReplacementNamed(context, '/home');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 40),
                
                // Logo/Icon
                Center(
                  child: Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      color: const Color(0xFFE8F5E9),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Icon(
                      Icons.attach_money,
                      size: 50,
                      color: Color(0xFF2E7D32),
                    ),
                  ),
                ),
                
                const SizedBox(height: 24),
                
                // Title
                Center(
                  child: Text(
                    'Flow Finance',
                    style: GoogleFonts.inter(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF2E7D32),
                    ),
                  ),
                ),
                
                const SizedBox(height: 8),
                
                Center(
                  child: Text(
                    'Secure mobile money',
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                  ),
                ),
                
                const SizedBox(height: 48),
                
                // Phone Input Section
                if (!_isOtpSent) ...[
                  Text(
                    'Enter your phone number',
                    style: GoogleFonts.inter(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF1B5E20),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFFF8F9FA),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: const Color(0xFFE8F5E9),
                      ),
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          child: Text(
                            '+220',
                            style: GoogleFonts.inter(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: const Color(0xFF2E7D32),
                            ),
                          ),
                        ),
                        Expanded(
                          child: TextField(
                            controller: _phoneController,
                            keyboardType: TextInputType.phone,
                            style: GoogleFonts.inter(fontSize: 18),
                            decoration: InputDecoration(
                              hintText: '1234567',
                              hintStyle: GoogleFonts.inter(
                                color: Colors.grey[400],
                              ),
                              border: InputBorder.none,
                              contentPadding: const EdgeInsets.symmetric(vertical: 16),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
                
                // OTP Input Section
                if (_isOtpSent) ...[
                  Text(
                    'Enter verification code',
                    style: GoogleFonts.inter(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF1B5E20),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFFF8F9FA),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: const Color(0xFFE8F5E9),
                      ),
                    ),
                    child: TextField(
                      controller: _otpController,
                      keyboardType: TextInputType.number,
                      maxLength: 6,
                      style: GoogleFonts.inter(fontSize: 18),
                      decoration: InputDecoration(
                        hintText: '123456',
                        hintStyle: GoogleFonts.inter(
                          color: Colors.grey[400],
                        ),
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                        counterText: '',
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextButton(
                    onPressed: _sendOtp,
                    child: Text(
                      'Resend Code',
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        color: const Color(0xFF4CAF50),
                      ),
                    ),
                  ),
                ],
                
                const SizedBox(height: 16),
                
                // Error Message
                if (_errorMessage.isNotEmpty)
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.red[50],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.error_outline, color: Colors.red, size: 20),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            _errorMessage,
                            style: GoogleFonts.inter(
                              fontSize: 12,
                              color: Colors.red[700],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                
                const SizedBox(height: 24),
                
                // Continue Button
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : (_isOtpSent ? _verifyOtp : _sendOtp),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF4CAF50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      elevation: 0,
                    ),
                    child: _isLoading
                        ? const SizedBox(
                            width: 24,
                            height: 24,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            ),
                          )
                        : Text(
                            _isOtpSent ? 'Verify & Login' : 'Send OTP',
                            style: GoogleFonts.inter(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                  ),
                ),
                
                const SizedBox(height: 24),
                
                // Terms
                Center(
                  child: Text(
                    'By continuing, you agree to our Terms & Conditions',
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      color: Colors.grey[500],
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}