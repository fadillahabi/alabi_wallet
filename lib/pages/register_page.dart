import 'package:daily_financial_recording/constant/app_color.dart';
import 'package:daily_financial_recording/database/db_account.dart';
import 'package:daily_financial_recording/model/model_account.dart';
import 'package:flutter/material.dart';

class Register extends StatefulWidget {
  const Register({super.key});
  static const String id = "/register";

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final TextEditingController namaController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _visibilityPassword = true;
  bool _isLoading = false;

  Future<void> _register() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);

      final newAccount = ModelAccount(
        nama: namaController.text.trim(),
        phone: int.parse(phoneController.text.trim()),
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );

      try {
        await DBAccount().insertAccount(newAccount);

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Account created successfully'),
            backgroundColor: Colors.green,
          ),
        );

        Navigator.pushReplacementNamed(context, '/login');
      } catch (e) {
        final errorMsg = e.toString().replaceFirst('Exception: ', '');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(errorMsg), backgroundColor: Colors.red),
        );
      } finally {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.close, size: 32),
        ),
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: constraints.maxHeight),
              child: IntrinsicHeight(
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.only(top: 80, bottom: 40),
                        child: Column(
                          children: [
                            Image.asset(
                              'assets/images/logo_tanpa_nama.png',
                              height: 60,
                              color: AppColor.blue_main,
                            ),
                            SizedBox(height: 20),
                          ],
                        ),
                      ),

                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 24),
                        child: Column(
                          children: [
                            TextFormField(
                              controller: namaController,
                              decoration: _inputDecoration('Name'),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Enter full name';
                                }
                                return null;
                              },
                            ),
                            SizedBox(height: 12),
                            TextFormField(
                              controller: phoneController,
                              decoration: _inputDecoration('No. HP'),
                              keyboardType: TextInputType.phone,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Enter mobile number';
                                }
                                return null;
                              },
                            ),
                            SizedBox(height: 12),
                            TextFormField(
                              controller: emailController,
                              decoration: _inputDecoration('Email'),
                              keyboardType: TextInputType.emailAddress,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Enter email';
                                }
                                if (!value.contains('@')) {
                                  return 'Email invalid';
                                }
                                return null;
                              },
                            ),
                            SizedBox(height: 12),
                            TextFormField(
                              controller: passwordController,
                              obscureText: _visibilityPassword,
                              decoration: _inputDecoration(
                                'Password',
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    _visibilityPassword
                                        ? Icons.visibility_off
                                        : Icons.visibility,
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      _visibilityPassword =
                                          !_visibilityPassword;
                                    });
                                  },
                                ),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Enter password';
                                }
                                if (value.length < 6) {
                                  return 'Minimum 6 characters';
                                }
                                return null;
                              },
                            ),
                            SizedBox(height: 16),
                            SizedBox(
                              width: double.infinity,
                              height: 50,
                              child: ElevatedButton(
                                onPressed: _isLoading ? null : _register,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColor.blue_main,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(24),
                                    side: BorderSide(
                                      color: Colors.white,
                                      width: 2,
                                    ),
                                  ),
                                ),
                                child:
                                    _isLoading
                                        ? CircularProgressIndicator(
                                          color: Colors.white,
                                        )
                                        : Text(
                                          'Register',
                                          style: TextStyle(
                                            fontSize: 16,
                                            color: Colors.white,
                                          ),
                                        ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Spacer(),
                      Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 4,
                        ),
                        child: SizedBox(
                          width: double.infinity,
                          height: 48,
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.pushReplacementNamed(context, '/login');
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(24),
                                side: BorderSide(
                                  width: 1,
                                  color: AppColor.blue_main,
                                ),
                              ),
                            ),
                            child: Text(
                              'Already have an account? Log in',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: AppColor.blue_main,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SafeArea(
                        child: Text("v 1.0.0", style: TextStyle(fontSize: 12)),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  InputDecoration _inputDecoration(String label, {Widget? suffixIcon}) {
    return InputDecoration(
      labelText: label,
      labelStyle: TextStyle(color: Colors.grey[600]),
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.grey[300]!),
        borderRadius: BorderRadius.circular(16),
      ),
      focusedBorder: const OutlineInputBorder(
        borderSide: BorderSide(color: Colors.black38),
        borderRadius: BorderRadius.all(Radius.circular(16)),
      ),
      suffixIcon: suffixIcon,
    );
  }
}
