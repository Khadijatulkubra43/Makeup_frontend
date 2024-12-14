import 'package:flutter/material.dart';
import 'package:flutter_application_1/feature/auth/screens/signin_screen.dart';
import 'package:flutter_application_1/feature/auth/services/api_service.dart';
import 'package:flutter_application_1/widgets/custom_scaffold.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _firstnameController = TextEditingController();
  final _lastnameController = TextEditingController();
  final _usernameController = TextEditingController();
  final _password1Controller = TextEditingController();
  final _password2Controller = TextEditingController();
  bool _ispasswordvisible1 = false;
  bool _ispasswordvisible2 = false;
  bool _isLoading = false;
  final _formSignupKey = GlobalKey<FormState>();
  bool agreePersonalData = true;

  void _register() async {
    setState(() {
      _isLoading = true;
    });
    bool success = await ApiService.register(
      _usernameController.text,
      _password1Controller.text,
      _password2Controller.text,
      "dummyemail@gmail.com", // passing dummyemai.... :P
      _firstnameController.text,
      _lastnameController.text,
    );
    if (!mounted) {
      return;
    }
    if (success) {
      // TODO: Pass data
      // Navigate to SignInScreen after processing data
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const SignInScreen(),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Faild to register"),
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
              padding: const EdgeInsets.fromLTRB(25.0, 25.0, 25.0, 15.0),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(40.0),
                  topRight: Radius.circular(40.0),
                ),
              ),
              child: SingleChildScrollView(
                // get started form
                child: Form(
                  key: _formSignupKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // get started text
                      const Text(
                        'Get Started',
                        style: TextStyle(
                          fontSize: 30.0,
                          fontWeight: FontWeight.w900,
                          color: Color.fromARGB(255, 227, 114, 217),
                        ),
                      ),
                      const SizedBox(
                        height: 15.0,
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.only(right: 4.5),
                              child: TextFormField(
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please Enter First Name';
                                  }
                                  return null;
                                },
                                decoration: InputDecoration(
                                  labelText: "First Name",
                                  border: OutlineInputBorder(
                                    borderSide: const BorderSide(
                                      color: Colors
                                          .black12, // Default border color
                                    ),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(
                                      color: Colors
                                          .black12, // Default border color
                                    ),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                                controller: _firstnameController,
                              ),
                            ),
                          ),
                          Expanded(
                              child: Padding(
                            padding: const EdgeInsets.only(left: 4.5),
                            child: TextFormField(
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please Enter Last Name';
                                }
                                return null;
                              },
                              decoration: InputDecoration(
                                labelText: "Last Name",
                                border: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                    color:
                                        Colors.black12, // Default border color
                                  ),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                    color:
                                        Colors.black12, // Default border color
                                  ),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              controller: _lastnameController,
                            ),
                          )),
                        ],
                      ),
                      const SizedBox(
                        height: 10.0,
                      ),
                      // username
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
                              RegExp(r'^[a-zA-Z0-9_{"."}]+$');
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
                        height: 15.0,
                      ),
                      // password1
                      TextFormField(
                        controller: _password1Controller,
                        obscureText: !_ispasswordvisible1,
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
                          suffixIcon: IconButton(
                            onPressed: () {
                              setState(() {
                                _ispasswordvisible1 = !_ispasswordvisible1;
                              });
                            },
                            icon: Icon(
                              _ispasswordvisible1
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                            ),
                          ),
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
                        ),
                      ),
                      const SizedBox(
                        height: 10.0,
                      ),
                      // password2 confrim
                      TextFormField(
                        controller: _password2Controller,
                        obscureText: !_ispasswordvisible2,
                        obscuringCharacter: '*',
                        validator: (value) {
                          if (value != _password1Controller.text) {
                            return 'Password Did not Match';
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                          suffixIcon: IconButton(
                            onPressed: () {
                              setState(() {
                                _ispasswordvisible2 = !_ispasswordvisible2;
                              });
                            },
                            icon: Icon(
                              _ispasswordvisible2
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                            ),
                          ),
                          label: const Text('Confirm Password'),
                          hintText: 'Confirm Password',
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
                        height: 15.0,
                      ),
                      // i agree to the processing
                      Column(
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Checkbox(
                                value: agreePersonalData,
                                onChanged: (bool? value) {
                                  setState(() {
                                    agreePersonalData = value!;
                                  });
                                },
                                activeColor:
                                    const Color.fromARGB(255, 243, 108, 227),
                              ),
                              const Text(
                                'I agree to the processing of ',
                                style: TextStyle(
                                  color: Colors.black45,
                                ),
                              ),
                            ],
                          ),
                          const Text(
                            'Personal data',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Color.fromARGB(255, 229, 126, 207),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 25.0,
                      ),
                      // signup button
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            if (_formSignupKey.currentState!.validate() &&
                                agreePersonalData) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Processing Data'),
                                ),
                              );
                              _register();
                            } else if (!agreePersonalData) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                    'Please agree to the processing of personal data',
                                  ),
                                ),
                              );
                            }
                          },
                          child: (!_isLoading)
                              ? const Text('Sign up')
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
                        height: 15,
                      ),
                      // sign up divider
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
                        height: 30.0,
                      ),
                      // sign up social media logo
                      const Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Icon(
                            Icons.facebook,
                            color: Color.fromARGB(255, 227, 90, 218),
                          ),
                          Icon(
                            Icons.g_mobiledata_rounded,
                            color: Color.fromARGB(255, 227, 90, 218),
                          ),
                          Icon(
                            Icons.apple,
                            color: Color.fromARGB(255, 227, 90, 218),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 20.0,
                      ),
                      // already have an account
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            'Already have an account? ',
                            style: TextStyle(
                              color: Colors.black45,
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (e) => const SignInScreen(),
                                ),
                              );
                            },
                            child: const Text(
                              'Sign in',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Color.fromARGB(255, 227, 117, 211),
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
