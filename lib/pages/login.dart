import 'package:daily_financial_recording/database/db_account.dart';
import 'package:daily_financial_recording/model/model_account.dart';
import 'package:daily_financial_recording/pages/register.dart';
import 'package:flutter/material.dart';

class Login extends StatefulWidget {
  const Login({super.key});
  static const String id = "/login";

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _visibilityPassword = true;
  bool _isLoading = false;

  Future<void> _login() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      final accounts = await DBAccount().getAllAccount();
      final email = emailController.text.trim();
      final password = passwordController.text.trim();

      final account = accounts.firstWhere(
        (account) => account.email == email && account.password == password,
        orElse: () => ModelAccount.empty(),
      );

      setState(() {
        _isLoading = false;
      });

      if (account.email.isNotEmpty) {
        Navigator.pushReplacementNamed(context, '/main_screen');
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Email or password wrong'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {},
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
                      // Header
                      Container(
                        padding: EdgeInsets.only(top: 80, bottom: 40),
                        child: Image.asset(
                          'assets/images/logo_tanpa_nama.png',
                          height: 60,
                          color: Color(0xff1E88E5),
                        ),
                      ),
                      SizedBox(height: 20),
                      // Form Login
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 24),
                        child: Column(
                          children: [
                            TextFormField(
                              controller: emailController,
                              decoration: InputDecoration(
                                labelText: 'Email',
                                labelStyle: TextStyle(color: Colors.grey[600]),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Colors.grey[300]!,
                                  ),
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.black38),
                                  borderRadius: BorderRadius.circular(16),
                                ),
                              ),
                              keyboardType: TextInputType.emailAddress,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Enter your email';
                                }
                                if (!value.contains('@')) {
                                  return 'Email Invalid';
                                }
                                return null;
                              },
                            ),
                            SizedBox(height: 12),
                            TextFormField(
                              controller: passwordController,
                              decoration: InputDecoration(
                                labelText: 'Password',
                                labelStyle: TextStyle(color: Colors.grey[600]),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Colors.grey[300]!,
                                  ),
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.black38),
                                  borderRadius: BorderRadius.circular(16),
                                ),
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
                              obscureText: _visibilityPassword,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Enter your password';
                                }
                                if (value.length < 6) {
                                  return 'Password must be at least 6 characters';
                                }
                                return null;
                              },
                            ),
                            SizedBox(height: 16),
                            SizedBox(
                              width: double.infinity,
                              height: 50,
                              child: ElevatedButton(
                                onPressed: _isLoading ? null : _login,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Color(0xFF118EE0),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(24),
                                  ),
                                ),
                                child:
                                    _isLoading
                                        ? CircularProgressIndicator(
                                          color: Colors.white,
                                        )
                                        : Text(
                                          'Log in',
                                          style: TextStyle(
                                            fontSize: 16,
                                            color: Colors.white,
                                          ),
                                        ),
                              ),
                            ),
                            Align(
                              alignment: Alignment.center,
                              child: TextButton(
                                onPressed: () {},
                                child: Text(
                                  'Forgotten password?',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.w400,
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
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => Register(),
                                ),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(24),
                                side: BorderSide(
                                  width: 1,
                                  color: Color(0xFF118EE0),
                                ),
                              ),
                            ),
                            child: Text(
                              'Create New Account',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF118EE0),
                              ),
                            ),
                          ),
                        ),
                      ),
                      SafeArea(
                        child: Text(
                          "v 1.0.0",
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.normal,
                          ),
                        ),
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
}
