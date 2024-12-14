import 'package:flutter/material.dart';
import 'package:flutter_application_1/core/navigation/navigation_menu.dart';
import 'package:flutter_application_1/feature/auth/screens/signup_screen.dart';
import 'package:flutter_application_1/core/theme/theme.dart';
import 'package:flutter_application_1/feature/auth/services/api_service.dart';
import 'package:flutter_application_1/widgets/custom_scaffold.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final _formSignInKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _ispasswordvisible = false;
  bool _isLoading = false;
  bool rememberPassword = true;

  Future<void> _login() async {
    setState(() {
      _isLoading = true;
    });
    bool success = await ApiService.login(
        _usernameController.text, _passwordController.text);
    if (!mounted) {
      return;
    }
    if (success) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const NavigationMenu(),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Failed to login"),
        ),
      );
    }
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      child: Column(
        children: [
          const Expanded(
            flex: 1,
            child: SizedBox(
              height: 10,
            ),
          ),
          Expanded(
            flex: 7,
            child: Container(
              padding: const EdgeInsets.fromLTRB(25.0, 50.0, 25.0, 20.0),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(40.0),
                  topRight: Radius.circular(40.0),
                ),
              ),
              child: SingleChildScrollView(
                child: Form(
                  key: _formSignInKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        'Welcome back',
                        style: TextStyle(
                          fontSize: 30.0,
                          fontWeight: FontWeight.w900,
                          color: lightColorScheme.primary,
                        ),
                      ),
                      const SizedBox(
                        height: 40.0,
                      ),
                      TextFormField(
                        controller: _usernameController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter a username';
                          }
                          if (value.length < 3 || value.length > 16) {
                            return 'Username must be between 3 and 16 characters.';
                          }
                          final RegExp usernameRegex =
                              RegExp(r'^[a-zA-Z0-9_]+$');
                          if (!usernameRegex.hasMatch(value)) {
                            return 'Username can only contain letters, numbers, and underscores.';
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                          label: const Text('Username'),
                          hintText: 'Enter Username',
                          hintStyle: const TextStyle(
                            color: Colors.black26,
                          ),
                          border: OutlineInputBorder(
                            borderSide: const BorderSide(
                              color: Colors.black12, // Default border color
                            ),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                              color: Colors.black12, // Default border color
                            ),
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 25.0,
                      ),
                      TextFormField(
                        controller: _passwordController,
                        obscureText: !_ispasswordvisible,
                        obscuringCharacter: '*',
                        validator: (value) {
                          // Check for null or empty input
                          if (value == null || value.isEmpty) {
                            return 'Please enter a password';
                          }

                          // Length validation
                          if (value.length < 8) {
                            return 'Password must be at least 8 characters long';
                          }

                          // Uppercase letter check
                          if (!RegExp(r'^(?=.*[A-Z])').hasMatch(value)) {
                            return 'Password must contain at least 1 uppercase letter';
                          }

                          // Special character check
                          if (!RegExp(r'^(?=.*[!@#\$%^&*(),.?":{}|<>])')
                              .hasMatch(value)) {
                            return 'Password must contain at least 1 special character';
                          }

                          return null; // Return null if the password is valid
                        },
                        decoration: InputDecoration(
                          label: const Text('Password'),
                          hintText: 'Enter Password',
                          hintStyle: const TextStyle(
                            color: Colors.black26,
                          ),
                          border: OutlineInputBorder(
                            borderSide: const BorderSide(
                              color: Colors.black12, // Default border color
                            ),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                              color: Colors.black12, // Default border color
                            ),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          suffixIcon: IconButton(
                            onPressed: () {
                              setState(() {
                                _ispasswordvisible = !_ispasswordvisible;
                              });
                            },
                            icon: Icon(_ispasswordvisible
                                ? Icons.visibility
                                : Icons.visibility_off),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 25.0,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Checkbox(
                                value: rememberPassword,
                                onChanged: (bool? value) {
                                  setState(() {
                                    rememberPassword = value!;
                                  });
                                },
                                activeColor: lightColorScheme.primary,
                              ),
                              const Text(
                                'Remember me',
                                style: TextStyle(
                                  color: Colors.black45,
                                ),
                              ),
                            ],
                          ),
                          GestureDetector(
                            child: Text(
                              'Forget password?',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: lightColorScheme.primary,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 25.0,
                      ),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            if (_formSignInKey.currentState!.validate() &&
                                rememberPassword) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Processing Data'),
                                ),
                              );
                              _login();
                            } else if (!rememberPassword) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text(
                                        'Please agree to the processing of personal data')),
                              );
                            }
                          },
                          child: (!_isLoading)
                              ? const Text('Sign in')
                              : const SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                  ),
                                ),
                        ),
                      ),
                      const SizedBox(
                        height: 25.0,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Expanded(
                            child: Divider(
                              thickness: 0.7,
                              color: Colors.grey.withOpacity(0.5),
                            ),
                          ),
                          const Padding(
                            padding: EdgeInsets.symmetric(
                              vertical: 0,
                              horizontal: 10,
                            ),
                            child: Text(
                              'Sign up with',
                              style: TextStyle(
                                color: Colors.black45,
                              ),
                            ),
                          ),
                          Expanded(
                            child: Divider(
                              thickness: 0.7,
                              color: Colors.grey.withOpacity(0.5),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 25.0,
                      ),
                      const Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          // Logo(Logos.facebook_f),
                          // Logo(Logos.twitter),
                          // Logo(Logos.google),
                          // Logo(Logos.apple),
                          Icon(
                            Icons.facebook,
                            color: Colors.blue,
                          ),
                          // Icon(
                          //   Icons.,
                          //   color: Colors.blue,
                          // ),
                          Icon(
                            Icons.g_mobiledata_rounded,
                            color: Colors.blue,
                          ),
                          Icon(
                            Icons.apple,
                            color: Colors.blue,
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 25.0,
                      ),
                      // don't have an account
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            'Don\'t have an account? ',
                            style: TextStyle(
                              color: Colors.black45,
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (e) => const SignUpScreen(),
                                ),
                              );
                            },
                            child: Text(
                              'Sign up',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: lightColorScheme.primary,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 20.0,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
